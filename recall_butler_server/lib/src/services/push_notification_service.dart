import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:asn1lib/asn1lib.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/export.dart';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Service for sending push notifications via Firebase Cloud Messaging (FCM)
/// Uses FCM HTTP v1 API with OAuth2 service account authentication
class PushNotificationService {
  // FCM HTTP v1 API endpoint
  static const String _projectId = 'serverpod-butler';
  static const String _fcmEndpoint =
      'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send';

  // OAuth2 token endpoint
  static const String _tokenEndpoint = 'https://oauth2.googleapis.com/token';

  // FCM OAuth2 scope
  static const String _fcmScope =
      'https://www.googleapis.com/auth/firebase.messaging';

  // Cached access token
  static String? _accessToken;
  static DateTime? _tokenExpiresAt;

  // Service account credentials (loaded from file)
  static Map<String, dynamic>? _serviceAccountCredentials;

  // Priority threshold for sending notifications
  static const int criticalPriorityThreshold = 9;
  static const int highPriorityThreshold = 7;

  /// Load service account credentials from file
  static Future<Map<String, dynamic>?> _loadServiceAccountCredentials() async {
    if (_serviceAccountCredentials != null) {
      return _serviceAccountCredentials;
    }

    try {
      // Try different possible locations for the service account file
      final possiblePaths = [
        'config/firebase-service-account.json',
        '../config/firebase-service-account.json',
        '/home/sajal/Desktop/Hackathons/serverpod_butler/recall_butler/recall_butler_server/config/firebase-service-account.json',
      ];

      for (final path in possiblePaths) {
        final file = File(path);
        if (await file.exists()) {
          final content = await file.readAsString();
          _serviceAccountCredentials = jsonDecode(content);
          return _serviceAccountCredentials;
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get OAuth2 access token for FCM
  /// Uses JWT assertion with service account credentials
  static Future<String?> _getAccessToken(Session session) async {
    // Check if we have a valid cached token
    if (_accessToken != null &&
        _tokenExpiresAt != null &&
        DateTime.now().isBefore(_tokenExpiresAt!.subtract(const Duration(minutes: 5)))) {
      return _accessToken;
    }

    final credentials = await _loadServiceAccountCredentials();
    if (credentials == null) {
      session.log('Service account credentials not found', level: LogLevel.error);
      return null;
    }

    try {
      // Create JWT
      final jwt = _createJwt(credentials);
      if (jwt == null) {
        session.log('Failed to create JWT', level: LogLevel.error);
        return null;
      }

      // Exchange JWT for access token
      final response = await http.post(
        Uri.parse(_tokenEndpoint),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
          'assertion': jwt,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _accessToken = data['access_token'];
        final expiresIn = data['expires_in'] as int? ?? 3600;
        _tokenExpiresAt = DateTime.now().add(Duration(seconds: expiresIn));
        return _accessToken;
      } else {
        session.log('Failed to get access token: ${response.statusCode} - ${response.body}',
            level: LogLevel.error);
        return null;
      }
    } catch (e) {
      session.log('Error getting access token: $e', level: LogLevel.error);
      return null;
    }
  }

  /// Create a signed JWT for OAuth2 authentication
  static String? _createJwt(Map<String, dynamic> credentials) {
    try {
      final clientEmail = credentials['client_email'] as String?;
      final privateKeyPem = credentials['private_key'] as String?;

      if (clientEmail == null || privateKeyPem == null) {
        return null;
      }

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final expiry = now + 3600; // 1 hour

      // JWT Header
      final header = {'alg': 'RS256', 'typ': 'JWT'};

      // JWT Payload
      final payload = {
        'iss': clientEmail,
        'sub': clientEmail,
        'aud': _tokenEndpoint,
        'iat': now,
        'exp': expiry,
        'scope': _fcmScope,
      };

      // Encode header and payload
      final headerBase64 = _base64UrlEncode(jsonEncode(header));
      final payloadBase64 = _base64UrlEncode(jsonEncode(payload));
      final message = '$headerBase64.$payloadBase64';

      // Sign with RSA-SHA256
      final signature = _signWithRsa(message, privateKeyPem);
      if (signature == null) {
        return null;
      }

      return '$message.$signature';
    } catch (e) {
      return null;
    }
  }

  /// Base64 URL encode without padding
  static String _base64UrlEncode(String input) {
    final bytes = utf8.encode(input);
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  /// Sign data with RSA-SHA256 using PEM private key
  static String? _signWithRsa(String message, String privateKeyPem) {
    try {
      // Parse PEM private key
      final privateKey = _parsePrivateKeyFromPem(privateKeyPem);
      if (privateKey == null) {
        return null;
      }

      // Create RSA signer with PKCS1 signature
      final signer = Signer('SHA-256/RSA');

      // Initialize with private key
      signer.init(true, PrivateKeyParameter<RSAPrivateKey>(privateKey));

      // Sign the message
      final messageBytes = Uint8List.fromList(utf8.encode(message));
      final signature = signer.generateSignature(messageBytes) as RSASignature;

      // Return base64url encoded signature
      return base64Url.encode(signature.bytes).replaceAll('=', '');
    } catch (e) {
      return null;
    }
  }

  /// Parse RSA private key from PEM format
  static RSAPrivateKey? _parsePrivateKeyFromPem(String pem) {
    try {
      // Remove PEM header/footer and whitespace
      final lines = pem
          .replaceAll('-----BEGIN PRIVATE KEY-----', '')
          .replaceAll('-----END PRIVATE KEY-----', '')
          .replaceAll('\n', '')
          .replaceAll('\r', '')
          .trim();

      // Decode base64
      final bytes = base64.decode(lines);

      // Parse PKCS#8 format using asn1lib
      final parser = ASN1Parser(bytes);
      final topLevelSeq = parser.nextObject() as ASN1Sequence;

      // PKCS#8 structure: version, algorithm, privateKey
      final privateKeyOctet = topLevelSeq.elements[2] as ASN1OctetString;

      // Parse the inner RSA private key
      final rsaParser = ASN1Parser(privateKeyOctet.contentBytes());
      final rsaSeq = rsaParser.nextObject() as ASN1Sequence;

      // RSA private key structure: version, n, e, d, p, q, dP, dQ, qInv
      final modulus = (rsaSeq.elements[1] as ASN1Integer).valueAsBigInteger;
      final privateExponent = (rsaSeq.elements[3] as ASN1Integer).valueAsBigInteger;
      final p = (rsaSeq.elements[4] as ASN1Integer).valueAsBigInteger;
      final q = (rsaSeq.elements[5] as ASN1Integer).valueAsBigInteger;

      return RSAPrivateKey(modulus, privateExponent, p, q);
    } catch (e) {
      return null;
    }
  }

  /// Send push notification for a critical email
  /// Only sends if priority >= threshold and not already notified
  static Future<bool> notifyCriticalEmail(
    Session session,
    EmailSummary email,
    int userId,
  ) async {
    // Check if already notified for this email
    final existingNotification = await NotificationLog.db.findFirstRow(
      session,
      where: (t) => t.sourceType.equals('email') & t.sourceId.equals(email.gmailId),
    );

    if (existingNotification != null) {
      session.log('Notification already sent for email ${email.gmailId}');
      return false;
    }

    // Check priority threshold
    if (email.importanceScore < criticalPriorityThreshold) {
      return false;
    }

    // Get user's device tokens
    final deviceTokens = await DeviceToken.db.find(
      session,
      where: (t) => t.userId.equals(userId) & t.isActive.equals(true),
    );

    if (deviceTokens.isEmpty) {
      session.log('No device tokens found for user $userId');
      return false;
    }

    // Build notification content
    final title = _buildEmailNotificationTitle(email);
    final body = _buildEmailNotificationBody(email);

    // Send to all user devices
    bool anySent = false;
    for (final deviceToken in deviceTokens) {
      final success = await _sendNotification(
        session,
        deviceToken.fcmToken,
        title: title,
        body: body,
        data: {
          'type': 'critical_email',
          'emailId': email.id.toString(),
          'gmailId': email.gmailId,
          'priority': email.importanceScore.toString(),
        },
        priority: 'high',
      );

      if (success) {
        anySent = true;
        // Update last used timestamp
        deviceToken.lastUsedAt = DateTime.now();
        await DeviceToken.db.updateRow(session, deviceToken);
      }
    }

    // Log the notification
    if (anySent) {
      final log = NotificationLog(
        userId: userId,
        sourceType: 'email',
        sourceId: email.gmailId,
        title: title,
        body: body,
        priority: email.importanceScore,
        sentAt: DateTime.now(),
      );
      await NotificationLog.db.insertRow(session, log);
    }

    return anySent;
  }

  /// Send push notification for a calendar event reminder
  static Future<bool> notifyCalendarEvent(
    Session session,
    CalendarEventCache event,
    int userId, {
    int minutesBefore = 15,
  }) async {
    // Check if already notified
    final existingNotification = await NotificationLog.db.findFirstRow(
      session,
      where: (t) => t.sourceType.equals('calendar') & t.sourceId.equals(event.googleEventId),
    );

    if (existingNotification != null) {
      return false;
    }

    // Get user's device tokens
    final deviceTokens = await DeviceToken.db.find(
      session,
      where: (t) => t.userId.equals(userId) & t.isActive.equals(true),
    );

    if (deviceTokens.isEmpty) {
      return false;
    }

    final title = 'Upcoming: ${event.title}';
    final body = 'Starting in $minutesBefore minutes${event.location != null ? ' at ${event.location}' : ''}';

    bool anySent = false;
    for (final deviceToken in deviceTokens) {
      final success = await _sendNotification(
        session,
        deviceToken.fcmToken,
        title: title,
        body: body,
        data: {
          'type': 'calendar_event',
          'eventId': event.id.toString(),
          'googleEventId': event.googleEventId,
        },
        priority: 'high',
      );

      if (success) anySent = true;
    }

    if (anySent) {
      final log = NotificationLog(
        userId: userId,
        sourceType: 'calendar',
        sourceId: event.googleEventId,
        title: title,
        body: body,
        priority: 8,
        sentAt: DateTime.now(),
      );
      await NotificationLog.db.insertRow(session, log);
    }

    return anySent;
  }

  /// Send a custom notification to a user
  static Future<bool> sendToUser(
    Session session,
    int userId, {
    required String title,
    required String body,
    Map<String, String>? data,
    String priority = 'normal',
  }) async {
    final deviceTokens = await DeviceToken.db.find(
      session,
      where: (t) => t.userId.equals(userId) & t.isActive.equals(true),
    );

    if (deviceTokens.isEmpty) {
      return false;
    }

    bool anySent = false;
    for (final deviceToken in deviceTokens) {
      final success = await _sendNotification(
        session,
        deviceToken.fcmToken,
        title: title,
        body: body,
        data: data,
        priority: priority,
      );
      if (success) anySent = true;
    }

    return anySent;
  }

  /// Core method to send FCM notification using HTTP v1 API
  /// Uses OAuth2 service account authentication
  static Future<bool> _sendNotification(
    Session session,
    String fcmToken, {
    required String title,
    required String body,
    Map<String, String>? data,
    String priority = 'normal',
  }) async {
    final accessToken = await _getAccessToken(session);

    if (accessToken == null) {
      session.log('Failed to get FCM access token', level: LogLevel.error);
      return false;
    }

    try {
      // FCM v1 API message format
      // Convert data values to strings (FCM requires string values)
      final stringData = <String, String>{};
      if (data != null) {
        for (final entry in data.entries) {
          stringData[entry.key] = entry.value.toString();
        }
      }

      final message = {
        'message': {
          'token': fcmToken,
          'notification': {
            'title': title,
            'body': body,
          },
          'data': stringData,
          'android': {
            'priority': priority == 'high' ? 'high' : 'normal',
            'notification': {
              'channel_id': 'critical_alerts',
              'sound': 'default',
            },
          },
          'apns': {
            'payload': {
              'aps': {
                'alert': {
                  'title': title,
                  'body': body,
                },
                'sound': 'default',
                'badge': 1,
                'content-available': 1,
              },
            },
            'headers': {
              'apns-priority': priority == 'high' ? '10' : '5',
            },
          },
        },
      };

      final response = await http.post(
        Uri.parse(_fcmEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        session.log('Push notification sent successfully');
        return true;
      } else {
        session.log('FCM request failed: ${response.statusCode} - ${response.body}',
            level: LogLevel.warning);

        // Handle invalid token errors
        final responseData = jsonDecode(response.body);
        final errorCode = responseData['error']?['details']?[0]?['errorCode'];
        if (errorCode == 'UNREGISTERED' || errorCode == 'INVALID_ARGUMENT') {
          await _deactivateToken(session, fcmToken);
        }

        // If token expired, clear cached token and retry once
        if (response.statusCode == 401) {
          _accessToken = null;
          _tokenExpiresAt = null;
        }

        return false;
      }
    } catch (e) {
      session.log('Failed to send push notification: $e', level: LogLevel.error);
      return false;
    }
  }

  /// Build notification title for critical email
  static String _buildEmailNotificationTitle(EmailSummary email) {
    if (email.importanceScore >= 10) {
      return 'URGENT: ${email.subject}';
    } else if (email.importanceScore >= 9) {
      return 'Important: ${email.subject}';
    } else {
      return email.subject;
    }
  }

  /// Build notification body for email
  static String _buildEmailNotificationBody(EmailSummary email) {
    final from = email.fromName ?? email.fromEmail;
    final summary = email.aiSummary ?? email.snippet ?? '';

    // Truncate if too long
    final truncatedSummary = summary.length > 100
        ? '${summary.substring(0, 100)}...'
        : summary;

    return 'From: $from\n$truncatedSummary';
  }

  /// Deactivate an invalid token
  static Future<void> _deactivateToken(Session session, String fcmToken) async {
    final token = await DeviceToken.db.findFirstRow(
      session,
      where: (t) => t.fcmToken.equals(fcmToken),
    );

    if (token != null) {
      token.isActive = false;
      token.updatedAt = DateTime.now();
      await DeviceToken.db.updateRow(session, token);
      session.log('Deactivated invalid FCM token');
    }
  }

  /// Check and send notifications for all unnotified critical emails
  /// Called by background worker
  static Future<int> processUnnotifiedCriticalEmails(
    Session session, {
    int limit = 10,
  }) async {
    // Find critical emails that haven't been notified
    final criticalEmails = await EmailSummary.db.find(
      session,
      where: (t) =>
          t.isProcessed.equals(true) &
          (t.importanceScore >= criticalPriorityThreshold),
      orderBy: (t) => t.importanceScore,
      orderDescending: true,
      limit: limit,
    );

    int notifiedCount = 0;

    for (final email in criticalEmails) {
      // Check if already notified
      final exists = await NotificationLog.db.findFirstRow(
        session,
        where: (t) => t.sourceType.equals('email') & t.sourceId.equals(email.gmailId),
      );

      if (exists == null) {
        final sent = await notifyCriticalEmail(session, email, email.userId);
        if (sent) notifiedCount++;
      }
    }

    if (notifiedCount > 0) {
      session.log('Sent $notifiedCount critical email notifications');
    }

    return notifiedCount;
  }
}

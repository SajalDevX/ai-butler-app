import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'google_auth_helper.dart';

/// Service for interacting with Gmail API
/// Handles email fetching, parsing, and syncing
class GmailService {
  static const String _baseUrl = 'https://gmail.googleapis.com/gmail/v1';
  static const int _maxEmailsPerSync = 15; // Reduced for faster initial sync
  static const int _maxBodyLength = 10000; // Truncate long emails

  /// Sync emails for a user
  /// Uses history API for incremental sync if historyId is available
  static Future<GmailSyncResult> syncEmails(
    Session session,
    int userId, {
    bool fullSync = false,
  }) async {
    final accessToken = await GoogleAuthHelper.getValidAccessToken(session, userId);
    if (accessToken == null) {
      return GmailSyncResult(
        success: false,
        error: 'Not authenticated with Google',
        newEmailCount: 0,
        updatedEmailCount: 0,
      );
    }

    // Get user's Google token for historyId
    final googleToken = await GoogleToken.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );

    if (googleToken == null) {
      return GmailSyncResult(
        success: false,
        error: 'Google token not found',
        newEmailCount: 0,
        updatedEmailCount: 0,
      );
    }

    try {
      int newCount = 0;
      int updatedCount = 0;
      String? newHistoryId;

      if (!fullSync && googleToken.gmailHistoryId != null) {
        // Incremental sync using history API
        final historyResult = await _syncWithHistory(
          session,
          userId,
          accessToken,
          googleToken.gmailHistoryId!,
        );
        newCount = historyResult['newCount'] as int;
        updatedCount = historyResult['updatedCount'] as int;
        newHistoryId = historyResult['historyId'] as String?;
      } else {
        // Full sync - fetch recent emails
        final result = await _fullSync(session, userId, accessToken);
        newCount = result['newCount'] as int;
        newHistoryId = result['historyId'] as String?;
      }

      // Update last sync time and historyId
      if (newHistoryId != null) {
        googleToken.gmailHistoryId = newHistoryId;
      }
      googleToken.lastGmailSync = DateTime.now();
      googleToken.updatedAt = DateTime.now();
      await GoogleToken.db.updateRow(session, googleToken);

      session.log('Gmail sync complete: $newCount new, $updatedCount updated');

      return GmailSyncResult(
        success: true,
        newEmailCount: newCount,
        updatedEmailCount: updatedCount,
      );
    } catch (e, stackTrace) {
      session.log('Gmail sync error: $e\n$stackTrace', level: LogLevel.error);
      return GmailSyncResult(
        success: false,
        error: e.toString(),
        newEmailCount: 0,
        updatedEmailCount: 0,
      );
    }
  }

  /// Full sync - fetch recent emails
  static Future<Map<String, dynamic>> _fullSync(
    Session session,
    int userId,
    String accessToken,
  ) async {
    // List recent messages
    final listResponse = await http.get(
      Uri.parse('$_baseUrl/users/me/messages?maxResults=$_maxEmailsPerSync&labelIds=INBOX'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (listResponse.statusCode != 200) {
      throw Exception('Failed to list messages: ${listResponse.statusCode}');
    }

    final listData = jsonDecode(listResponse.body) as Map<String, dynamic>;
    final messages = listData['messages'] as List<dynamic>? ?? [];
    final historyId = listData['resultSizeEstimate'] != null
        ? await _getHistoryId(accessToken)
        : null;

    int newCount = 0;

    for (final msg in messages) {
      final messageId = msg['id'] as String;

      // Check if already exists
      final existing = await EmailSummary.db.findFirstRow(
        session,
        where: (t) => t.gmailId.equals(messageId),
      );

      if (existing != null) continue;

      // Fetch full message
      final emailData = await _fetchMessage(accessToken, messageId);
      if (emailData != null) {
        await _saveEmail(session, userId, emailData);
        newCount++;
      }
    }

    return {'newCount': newCount, 'historyId': historyId};
  }

  /// Incremental sync using Gmail History API
  static Future<Map<String, dynamic>> _syncWithHistory(
    Session session,
    int userId,
    String accessToken,
    String startHistoryId,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/users/me/history?startHistoryId=$startHistoryId&historyTypes=messageAdded',
      ),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 404) {
      // History expired, need full sync
      return _fullSync(session, userId, accessToken);
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch history: ${response.statusCode}');
    }

    final historyData = jsonDecode(response.body) as Map<String, dynamic>;
    final historyList = historyData['history'] as List<dynamic>? ?? [];
    final newHistoryId = historyData['historyId'] as String?;

    int newCount = 0;
    int updatedCount = 0;

    for (final history in historyList) {
      final messagesAdded = history['messagesAdded'] as List<dynamic>? ?? [];

      for (final added in messagesAdded) {
        final message = added['message'] as Map<String, dynamic>;
        final messageId = message['id'] as String;

        // Check if already exists
        final existing = await EmailSummary.db.findFirstRow(
          session,
          where: (t) => t.gmailId.equals(messageId),
        );

        if (existing != null) {
          updatedCount++;
          continue;
        }

        // Fetch and save new email
        final emailData = await _fetchMessage(accessToken, messageId);
        if (emailData != null) {
          await _saveEmail(session, userId, emailData);
          newCount++;
        }
      }
    }

    return {
      'newCount': newCount,
      'updatedCount': updatedCount,
      'historyId': newHistoryId,
    };
  }

  /// Fetch a single message with full details
  static Future<Map<String, dynamic>?> _fetchMessage(
    String accessToken,
    String messageId,
  ) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users/me/messages/$messageId?format=full'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode != 200) return null;

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Get current historyId for the mailbox
  static Future<String?> _getHistoryId(String accessToken) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users/me/profile'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['historyId'] as String?;
  }

  /// Save email to database
  static Future<EmailSummary> _saveEmail(
    Session session,
    int userId,
    Map<String, dynamic> emailData,
  ) async {
    final headers = _parseHeaders(emailData);
    final body = _extractBody(emailData);
    final attachments = _getAttachments(emailData);

    final email = EmailSummary(
      userId: userId,
      gmailId: emailData['id'] as String,
      threadId: emailData['threadId'] as String,
      subject: headers['subject'] ?? '(No Subject)',
      fromEmail: headers['fromEmail'] ?? '',
      fromName: headers['fromName'],
      toEmails: jsonEncode(headers['to'] ?? []),
      ccEmails: headers['cc'] != null ? jsonEncode(headers['cc']) : null,
      receivedAt: DateTime.fromMillisecondsSinceEpoch(
        int.parse(emailData['internalDate'] as String),
      ),
      snippet: emailData['snippet'] as String?,
      bodyText: body,
      hasAttachments: attachments.isNotEmpty,
      attachmentNames: attachments.isNotEmpty ? jsonEncode(attachments) : null,
      category: _categorizeEmail(emailData),
      requiresAction: false,
      isRead: _hasLabel(emailData, 'UNREAD') == false,
      isArchived: _hasLabel(emailData, 'INBOX') == false,
      isProcessed: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      importanceScore: 5, // Default, AI will update
    );

    return await EmailSummary.db.insertRow(session, email);
  }

  /// Parse email headers
  static Map<String, dynamic> _parseHeaders(Map<String, dynamic> emailData) {
    final headers = <String, dynamic>{};
    final payload = emailData['payload'] as Map<String, dynamic>?;

    if (payload == null) return headers;

    final headerList = payload['headers'] as List<dynamic>? ?? [];

    for (final header in headerList) {
      final name = (header['name'] as String).toLowerCase();
      final value = header['value'] as String;

      switch (name) {
        case 'subject':
          headers['subject'] = value;
          break;
        case 'from':
          final fromParts = _parseEmailAddress(value);
          headers['fromEmail'] = fromParts['email'];
          headers['fromName'] = fromParts['name'];
          break;
        case 'to':
          headers['to'] = _parseEmailList(value);
          break;
        case 'cc':
          headers['cc'] = _parseEmailList(value);
          break;
      }
    }

    return headers;
  }

  /// Parse single email address (e.g., "Name <email@example.com>")
  static Map<String, String?> _parseEmailAddress(String value) {
    final match = RegExp(r'^(.+?)\s*<(.+)>$').firstMatch(value);
    if (match != null) {
      return {
        'name': match.group(1)?.trim(),
        'email': match.group(2)?.trim(),
      };
    }
    return {'name': null, 'email': value.trim()};
  }

  /// Parse comma-separated email list
  static List<String> _parseEmailList(String value) {
    return value
        .split(',')
        .map((e) => _parseEmailAddress(e.trim())['email'] ?? '')
        .where((e) => e.isNotEmpty)
        .toList();
  }

  /// Extract email body text
  static String? _extractBody(Map<String, dynamic> emailData) {
    final payload = emailData['payload'] as Map<String, dynamic>?;
    if (payload == null) return null;

    // Try to find plain text part
    String? body = _findBodyPart(payload, 'text/plain');
    body ??= _findBodyPart(payload, 'text/html');

    if (body != null && body.length > _maxBodyLength) {
      body = body.substring(0, _maxBodyLength);
    }

    return body;
  }

  /// Recursively find body part by MIME type
  static String? _findBodyPart(Map<String, dynamic> part, String mimeType) {
    final partMimeType = part['mimeType'] as String?;

    if (partMimeType == mimeType) {
      final body = part['body'] as Map<String, dynamic>?;
      final data = body?['data'] as String?;
      if (data != null) {
        return _decodeBase64Url(data);
      }
    }

    // Check nested parts
    final parts = part['parts'] as List<dynamic>?;
    if (parts != null) {
      for (final subPart in parts) {
        final result = _findBodyPart(subPart as Map<String, dynamic>, mimeType);
        if (result != null) return result;
      }
    }

    return null;
  }

  /// Decode base64url-encoded string
  static String _decodeBase64Url(String data) {
    // Convert base64url to standard base64
    var normalized = data.replaceAll('-', '+').replaceAll('_', '/');
    // Add padding if needed
    while (normalized.length % 4 != 0) {
      normalized += '=';
    }
    return utf8.decode(base64Decode(normalized));
  }

  /// Get attachment names from email
  static List<String> _getAttachments(Map<String, dynamic> emailData) {
    final attachments = <String>[];
    final payload = emailData['payload'] as Map<String, dynamic>?;

    if (payload == null) return attachments;

    _collectAttachments(payload, attachments);
    return attachments;
  }

  /// Recursively collect attachment filenames
  static void _collectAttachments(Map<String, dynamic> part, List<String> attachments) {
    final filename = part['filename'] as String?;
    if (filename != null && filename.isNotEmpty) {
      attachments.add(filename);
    }

    final parts = part['parts'] as List<dynamic>?;
    if (parts != null) {
      for (final subPart in parts) {
        _collectAttachments(subPart as Map<String, dynamic>, attachments);
      }
    }
  }

  /// Check if email has a specific label
  static bool _hasLabel(Map<String, dynamic> emailData, String label) {
    final labels = emailData['labelIds'] as List<dynamic>? ?? [];
    return labels.contains(label);
  }

  /// Categorize email based on labels
  static String _categorizeEmail(Map<String, dynamic> emailData) {
    final labels = emailData['labelIds'] as List<dynamic>? ?? [];

    if (labels.contains('CATEGORY_SOCIAL')) return 'social';
    if (labels.contains('CATEGORY_PROMOTIONS')) return 'promotions';
    if (labels.contains('CATEGORY_UPDATES')) return 'updates';
    if (labels.contains('CATEGORY_FORUMS')) return 'forums';
    return 'primary';
  }

  /// Get unprocessed emails for AI analysis
  static Future<List<EmailSummary>> getUnprocessedEmails(
    Session session,
    int userId, {
    int limit = 10,
  }) async {
    return await EmailSummary.db.find(
      session,
      where: (t) => t.userId.equals(userId) & t.isProcessed.equals(false),
      orderBy: (t) => t.receivedAt,
      orderDescending: true,
      limit: limit,
    );
  }

  /// Get emails by importance score
  static Future<List<EmailSummary>> getImportantEmails(
    Session session,
    int userId, {
    int minScore = 7,
    int limit = 20,
  }) async {
    return await EmailSummary.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.importanceScore.between(minScore, 10),
      orderBy: (t) => t.importanceScore,
      orderDescending: true,
      limit: limit,
    );
  }

  /// Get emails requiring action
  static Future<List<EmailSummary>> getActionableEmails(
    Session session,
    int userId, {
    int limit = 20,
  }) async {
    return await EmailSummary.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) & t.requiresAction.equals(true),
      orderBy: (t) => t.receivedAt,
      orderDescending: true,
      limit: limit,
    );
  }

  /// Create draft reply for an email
  static Future<String?> createDraft(
    Session session,
    int userId,
    String threadId,
    String messageId,
    String replyBody,
  ) async {
    final accessToken = await GoogleAuthHelper.getValidAccessToken(session, userId);
    if (accessToken == null) return null;

    // Get original email for reply headers
    final original = await EmailSummary.db.findFirstRow(
      session,
      where: (t) => t.gmailId.equals(messageId),
    );

    if (original == null) return null;

    // Build RFC 2822 message
    final message = StringBuffer();
    message.writeln('To: ${original.fromEmail}');
    message.writeln('Subject: Re: ${original.subject}');
    message.writeln('In-Reply-To: <$messageId>');
    message.writeln('References: <$messageId>');
    message.writeln('Content-Type: text/plain; charset=UTF-8');
    message.writeln();
    message.writeln(replyBody);

    // Base64url encode the message
    final encodedMessage = base64Url.encode(utf8.encode(message.toString()));

    // Create draft
    final response = await http.post(
      Uri.parse('$_baseUrl/users/me/drafts'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'message': {
          'raw': encodedMessage,
          'threadId': threadId,
        },
      }),
    );

    if (response.statusCode != 200) {
      session.log('Failed to create draft: ${response.body}', level: LogLevel.error);
      return null;
    }

    final draftData = jsonDecode(response.body) as Map<String, dynamic>;
    return draftData['id'] as String?;
  }
}

/// Result of Gmail sync operation
class GmailSyncResult {
  final bool success;
  final String? error;
  final int newEmailCount;
  final int updatedEmailCount;

  GmailSyncResult({
    required this.success,
    this.error,
    required this.newEmailCount,
    required this.updatedEmailCount,
  });
}

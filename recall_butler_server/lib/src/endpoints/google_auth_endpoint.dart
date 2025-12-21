import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/encryption_service.dart';

/// Endpoint for Google OAuth authentication
/// Handles token exchange, refresh, and revocation
class GoogleAuthEndpoint extends Endpoint {
  // Google OAuth endpoints
  static const String _tokenEndpoint = 'https://oauth2.googleapis.com/token';
  static const String _revokeEndpoint = 'https://oauth2.googleapis.com/revoke';

  // Scopes for Gmail and Calendar
  static const List<String> gmailScopes = [
    'https://www.googleapis.com/auth/gmail.readonly',
    'https://www.googleapis.com/auth/gmail.compose',
    'https://www.googleapis.com/auth/gmail.modify',
  ];

  static const List<String> calendarScopes = [
    'https://www.googleapis.com/auth/calendar.readonly',
    'https://www.googleapis.com/auth/calendar.events.readonly',
  ];

  /// Exchange authorization code for tokens
  /// Called after user completes Google OAuth consent screen
  Future<GoogleAuthResult> exchangeCode(
    Session session,
    String authCode,
    String redirectUri,
    bool enableGmail,
    bool enableCalendar,
  ) async {
    final userId = await _getUserId(session);

    final clientId = session.serverpod.getPassword('googleClientId');
    final clientSecret = session.serverpod.getPassword('googleClientSecret');

    if (clientId == null || clientSecret == null) {
      return GoogleAuthResult(
        success: false,
        error: 'Google OAuth not configured on server',
      );
    }

    try {
      // Build request body - only include redirect_uri if provided (not needed for mobile)
      final requestBody = {
        'client_id': clientId,
        'client_secret': clientSecret,
        'code': authCode,
        'grant_type': 'authorization_code',
      };

      // Only add redirect_uri if it's not empty (web clients need it, mobile doesn't)
      if (redirectUri.isNotEmpty) {
        requestBody['redirect_uri'] = redirectUri;
      }

      // Exchange code for tokens
      final response = await http.post(
        Uri.parse(_tokenEndpoint),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: requestBody,
      );

      if (response.statusCode != 200) {
        session.log('Token exchange failed: ${response.body}', level: LogLevel.error);
        // Parse error details from Google
        String errorMessage = 'Failed to exchange authorization code';
        try {
          final errorData = jsonDecode(response.body) as Map<String, dynamic>;
          final errorDesc = errorData['error_description'] ?? errorData['error'] ?? '';
          if (errorDesc.toString().isNotEmpty) {
            errorMessage = '$errorMessage: $errorDesc';
          }
        } catch (_) {}
        return GoogleAuthResult(
          success: false,
          error: errorMessage,
        );
      }

      final tokenData = jsonDecode(response.body) as Map<String, dynamic>;

      final accessToken = tokenData['access_token'] as String;
      final refreshToken = tokenData['refresh_token'] as String?;
      final expiresIn = tokenData['expires_in'] as int;
      final scope = tokenData['scope'] as String? ?? '';

      if (refreshToken == null) {
        return GoogleAuthResult(
          success: false,
          error: 'No refresh token received. Please revoke access and try again.',
        );
      }

      // Calculate expiry time
      final expiresAt = DateTime.now().add(Duration(seconds: expiresIn - 60));

      // Encrypt tokens before storing
      final encryptedAccess = EncryptionService.encrypt(accessToken);
      final encryptedRefresh = EncryptionService.encrypt(refreshToken);

      // Check if token already exists for user
      var existingToken = await GoogleToken.db.findFirstRow(
        session,
        where: (t) => t.userId.equals(userId),
      );

      final now = DateTime.now();

      if (existingToken != null) {
        // Update existing token
        existingToken.accessToken = encryptedAccess;
        existingToken.refreshToken = encryptedRefresh;
        existingToken.expiresAt = expiresAt;
        existingToken.scope = scope;
        existingToken.gmailEnabled = enableGmail;
        existingToken.calendarEnabled = enableCalendar;
        existingToken.updatedAt = now;

        await GoogleToken.db.updateRow(session, existingToken);
        session.log('Updated Google tokens for user $userId');
      } else {
        // Create new token record
        final googleToken = GoogleToken(
          userId: userId,
          accessToken: encryptedAccess,
          refreshToken: encryptedRefresh,
          expiresAt: expiresAt,
          scope: scope,
          gmailEnabled: enableGmail,
          calendarEnabled: enableCalendar,
          createdAt: now,
          updatedAt: now,
        );

        await GoogleToken.db.insertRow(session, googleToken);
        session.log('Stored new Google tokens for user $userId');
      }

      // Determine which features are available based on granted scopes
      final hasGmailScope = gmailScopes.any((s) => scope.contains(s));
      final hasCalendarScope = calendarScopes.any((s) => scope.contains(s));

      return GoogleAuthResult(
        success: true,
        gmailEnabled: enableGmail && hasGmailScope,
        calendarEnabled: enableCalendar && hasCalendarScope,
      );
    } catch (e, stackTrace) {
      session.log('Token exchange error: $e\n$stackTrace', level: LogLevel.error);
      return GoogleAuthResult(
        success: false,
        error: 'Failed to complete authentication: $e',
      );
    }
  }

  /// Get current authentication status
  Future<GoogleAuthStatus> getAuthStatus(Session session) async {
    final userId = await _getUserId(session);

    final token = await GoogleToken.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );

    if (token == null) {
      return GoogleAuthStatus(
        isAuthenticated: false,
        gmailEnabled: false,
        calendarEnabled: false,
      );
    }

    // Check if token is expired
    final isExpired = token.expiresAt.isBefore(DateTime.now());

    return GoogleAuthStatus(
      isAuthenticated: !isExpired,
      gmailEnabled: token.gmailEnabled,
      calendarEnabled: token.calendarEnabled,
      lastGmailSync: token.lastGmailSync,
      lastCalendarSync: token.lastCalendarSync,
      tokenExpiresAt: token.expiresAt,
    );
  }

  /// Update feature toggles (enable/disable Gmail or Calendar)
  Future<bool> updateFeatures(
    Session session,
    bool enableGmail,
    bool enableCalendar,
  ) async {
    final userId = await _getUserId(session);

    final token = await GoogleToken.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );

    if (token == null) {
      return false;
    }

    token.gmailEnabled = enableGmail;
    token.calendarEnabled = enableCalendar;
    token.updatedAt = DateTime.now();

    await GoogleToken.db.updateRow(session, token);
    return true;
  }

  /// Revoke Google access and delete stored tokens
  Future<bool> revokeAccess(Session session) async {
    final userId = await _getUserId(session);

    final token = await GoogleToken.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );

    if (token == null) {
      return true; // Nothing to revoke
    }

    try {
      // Decrypt access token for revocation
      final accessToken = EncryptionService.decrypt(token.accessToken);

      // Revoke token with Google
      await http.post(
        Uri.parse('$_revokeEndpoint?token=$accessToken'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      // Delete all related data
      await EmailSummary.db.deleteWhere(
        session,
        where: (t) => t.userId.equals(userId),
      );

      await CalendarEventCache.db.deleteWhere(
        session,
        where: (t) => t.userId.equals(userId),
      );

      // Delete token record
      await GoogleToken.db.deleteRow(session, token);

      session.log('Revoked Google access for user $userId');
      return true;
    } catch (e) {
      session.log('Failed to revoke access: $e', level: LogLevel.error);
      // Still delete local data even if revocation fails
      await GoogleToken.db.deleteRow(session, token);
      return true;
    }
  }

  /// Helper to get user ID from session
  Future<int> _getUserId(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      return 1; // Default user for demo
    }
    return authInfo.userId;
  }
}

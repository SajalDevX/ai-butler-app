import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'encryption_service.dart';

/// Helper class for Google OAuth token management
/// Used internally by Gmail and Calendar services
class GoogleAuthHelper {
  static const String _tokenEndpoint = 'https://oauth2.googleapis.com/token';

  /// Refresh access token using refresh token
  /// Returns new access token or null if refresh failed
  static Future<String?> refreshAccessToken(
    Session session,
    GoogleToken token,
  ) async {
    final clientId = session.serverpod.getPassword('googleClientId');
    final clientSecret = session.serverpod.getPassword('googleClientSecret');

    if (clientId == null || clientSecret == null) {
      session.log('Google OAuth not configured', level: LogLevel.error);
      return null;
    }

    try {
      final refreshToken = EncryptionService.decrypt(token.refreshToken);

      final response = await http.post(
        Uri.parse(_tokenEndpoint),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'client_id': clientId,
          'client_secret': clientSecret,
          'refresh_token': refreshToken,
          'grant_type': 'refresh_token',
        },
      );

      if (response.statusCode != 200) {
        session.log('Token refresh failed: ${response.body}', level: LogLevel.error);
        return null;
      }

      final tokenData = jsonDecode(response.body) as Map<String, dynamic>;
      final newAccessToken = tokenData['access_token'] as String;
      final expiresIn = tokenData['expires_in'] as int;

      // Update stored token
      token.accessToken = EncryptionService.encrypt(newAccessToken);
      token.expiresAt = DateTime.now().add(Duration(seconds: expiresIn - 60));
      token.updatedAt = DateTime.now();

      await GoogleToken.db.updateRow(session, token);

      return newAccessToken;
    } catch (e, stackTrace) {
      session.log('Token refresh error: $e\n$stackTrace', level: LogLevel.error);
      return null;
    }
  }

  /// Get valid access token, refreshing if needed
  static Future<String?> getValidAccessToken(
    Session session,
    int userId,
  ) async {
    final token = await GoogleToken.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );

    if (token == null) {
      return null;
    }

    // Check if token needs refresh (5 minute buffer)
    if (token.expiresAt.isBefore(DateTime.now().add(const Duration(minutes: 5)))) {
      return await refreshAccessToken(session, token);
    }

    return EncryptionService.decrypt(token.accessToken);
  }
}

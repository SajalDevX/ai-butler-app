import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class UserPreferenceEndpoint extends Endpoint {
  /// Get user preferences, creating default if not exists
  Future<UserPreference> getPreferences(Session session) async {
    final userId = await _getUserId(session);

    var prefs = await UserPreference.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );

    if (prefs == null) {
      // Create default preferences
      prefs = UserPreference(
        userId: userId,
        timezone: 'UTC',
        overlayEnabled: false,
        weeklyDigestEnabled: true,
        proactiveRemindersEnabled: true,
        theme: 'dark',
      );
      prefs = await UserPreference.db.insertRow(session, prefs);
    }

    return prefs;
  }

  /// Update user preferences
  Future<UserPreference> updatePreferences(
    Session session, {
    String? timezone,
    String? notificationTime,
    bool? overlayEnabled,
    bool? weeklyDigestEnabled,
    bool? proactiveRemindersEnabled,
    String? theme,
  }) async {
    final userId = await _getUserId(session);

    var prefs = await UserPreference.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );

    if (prefs == null) {
      prefs = await getPreferences(session);
    }

    if (timezone != null) prefs.timezone = timezone;
    if (notificationTime != null) prefs.notificationTime = notificationTime;
    if (overlayEnabled != null) prefs.overlayEnabled = overlayEnabled;
    if (weeklyDigestEnabled != null) {
      prefs.weeklyDigestEnabled = weeklyDigestEnabled;
    }
    if (proactiveRemindersEnabled != null) {
      prefs.proactiveRemindersEnabled = proactiveRemindersEnabled;
    }
    if (theme != null) prefs.theme = theme;

    return await UserPreference.db.updateRow(session, prefs);
  }

  /// Toggle floating overlay
  Future<bool> toggleOverlay(Session session) async {
    final prefs = await getPreferences(session);
    prefs.overlayEnabled = !prefs.overlayEnabled;
    await UserPreference.db.updateRow(session, prefs);
    return prefs.overlayEnabled;
  }

  /// Helper to get user ID from session
  Future<int> _getUserId(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      return 1; // Demo mode
    }
    return authInfo.userId;
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recall_butler_client/recall_butler_client.dart';
import 'client_provider.dart';

/// Notifier for user preferences
class PreferencesNotifier extends StateNotifier<UserPreference?> {
  final Client _client;

  PreferencesNotifier(this._client) : super(null);

  /// Load preferences
  Future<void> loadPreferences() async {
    try {
      final prefs = await _client.userPreference.getPreferences();
      state = prefs;
    } catch (e) {
      // Create default preferences locally
      state = UserPreference(
        userId: 0,
        timezone: 'UTC',
        overlayEnabled: false,
        weeklyDigestEnabled: true,
        proactiveRemindersEnabled: true,
        theme: 'dark',
      );
    }
  }

  /// Update preferences
  Future<void> updatePreferences({
    String? timezone,
    String? notificationTime,
    bool? overlayEnabled,
    bool? weeklyDigestEnabled,
    bool? proactiveRemindersEnabled,
    String? theme,
  }) async {
    try {
      final prefs = await _client.userPreference.updatePreferences(
        timezone: timezone,
        notificationTime: notificationTime,
        overlayEnabled: overlayEnabled,
        weeklyDigestEnabled: weeklyDigestEnabled,
        proactiveRemindersEnabled: proactiveRemindersEnabled,
        theme: theme,
      );
      state = prefs;
    } catch (e) {
      // Update locally if server fails
      if (state != null) {
        state = UserPreference(
          id: state!.id,
          userId: state!.userId,
          timezone: timezone ?? state!.timezone,
          notificationTime: notificationTime ?? state!.notificationTime,
          overlayEnabled: overlayEnabled ?? state!.overlayEnabled,
          weeklyDigestEnabled: weeklyDigestEnabled ?? state!.weeklyDigestEnabled,
          proactiveRemindersEnabled:
              proactiveRemindersEnabled ?? state!.proactiveRemindersEnabled,
          theme: theme ?? state!.theme,
        );
      }
    }
  }

  /// Toggle overlay
  Future<void> toggleOverlay() async {
    try {
      final enabled = await _client.userPreference.toggleOverlay();
      if (state != null) {
        state = UserPreference(
          id: state!.id,
          userId: state!.userId,
          timezone: state!.timezone,
          notificationTime: state!.notificationTime,
          overlayEnabled: enabled,
          weeklyDigestEnabled: state!.weeklyDigestEnabled,
          proactiveRemindersEnabled: state!.proactiveRemindersEnabled,
          theme: state!.theme,
        );
      }
    } catch (e) {
      // Toggle locally
      if (state != null) {
        state = UserPreference(
          id: state!.id,
          userId: state!.userId,
          timezone: state!.timezone,
          notificationTime: state!.notificationTime,
          overlayEnabled: !state!.overlayEnabled,
          weeklyDigestEnabled: state!.weeklyDigestEnabled,
          proactiveRemindersEnabled: state!.proactiveRemindersEnabled,
          theme: state!.theme,
        );
      }
    }
  }
}

/// Provider for preferences
final preferencesProvider =
    StateNotifierProvider<PreferencesNotifier, UserPreference?>((ref) {
  final client = ref.watch(clientProvider);
  final notifier = PreferencesNotifier(client);
  notifier.loadPreferences();
  return notifier;
});

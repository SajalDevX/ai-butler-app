import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recall_butler_client/recall_butler_client.dart';

import 'client_provider.dart';

/// Google Sign-In scopes for Gmail and Calendar
const List<String> _scopes = [
  'email',
  'https://www.googleapis.com/auth/gmail.readonly',
  'https://www.googleapis.com/auth/gmail.compose',
  'https://www.googleapis.com/auth/gmail.modify',
  'https://www.googleapis.com/auth/calendar.readonly',
  'https://www.googleapis.com/auth/calendar.events.readonly',
];

/// Google Sign-In instance
/// Note: forceCodeForRefreshToken is required to get a refresh token from server-side exchange
final _googleSignIn = GoogleSignIn(
  scopes: _scopes,
  serverClientId: '962155967274-79oe4u2eme13mn4oaap7a2nc1estvnpu.apps.googleusercontent.com',
  forceCodeForRefreshToken: true,
);

/// State for Google Auth
class GoogleAuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final bool gmailEnabled;
  final bool calendarEnabled;
  final DateTime? lastGmailSync;
  final DateTime? lastCalendarSync;
  final String? error;

  const GoogleAuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.gmailEnabled = false,
    this.calendarEnabled = false,
    this.lastGmailSync,
    this.lastCalendarSync,
    this.error,
  });

  GoogleAuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    bool? gmailEnabled,
    bool? calendarEnabled,
    DateTime? lastGmailSync,
    DateTime? lastCalendarSync,
    String? error,
  }) {
    return GoogleAuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      gmailEnabled: gmailEnabled ?? this.gmailEnabled,
      calendarEnabled: calendarEnabled ?? this.calendarEnabled,
      lastGmailSync: lastGmailSync ?? this.lastGmailSync,
      lastCalendarSync: lastCalendarSync ?? this.lastCalendarSync,
      error: error,
    );
  }
}

/// Provider for Google Auth state and actions
class GoogleAuthNotifier extends StateNotifier<GoogleAuthState> {
  final Client _client;

  GoogleAuthNotifier(this._client) : super(const GoogleAuthState()) {
    // Check auth status on init
    checkAuthStatus();
  }

  /// Check current authentication status from server
  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final status = await _client.googleAuth.getAuthStatus();

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: status.isAuthenticated,
        gmailEnabled: status.gmailEnabled,
        calendarEnabled: status.calendarEnabled,
        lastGmailSync: status.lastGmailSync,
        lastCalendarSync: status.lastCalendarSync,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to check auth status: $e',
      );
    }
  }

  /// Sign in with Google and exchange code for tokens
  /// Note: Sync is handled by background workers, not triggered immediately
  Future<bool> signIn({
    bool enableGmail = true,
    bool enableCalendar = true,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Sign out first to ensure we get a fresh auth code
      await _googleSignIn.signOut();

      // Start Google Sign-In flow
      final account = await _googleSignIn.signIn();

      if (account == null) {
        state = state.copyWith(isLoading: false, error: 'Sign in cancelled');
        return false;
      }

      // Get auth code for server
      final auth = await account.authentication;
      final serverAuthCode = _googleSignIn.currentUser?.serverAuthCode;

      if (serverAuthCode == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to get server auth code. Please try again.',
        );
        return false;
      }

      // Exchange code on server
      final result = await _client.googleAuth.exchangeCode(
        serverAuthCode,
        '', // Redirect URI not needed for mobile
        enableGmail,
        enableCalendar,
      );

      if (!result.success) {
        state = state.copyWith(
          isLoading: false,
          error: result.error ?? 'Failed to authenticate',
        );
        return false;
      }

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        gmailEnabled: result.gmailEnabled ?? enableGmail,
        calendarEnabled: result.calendarEnabled ?? enableCalendar,
      );

      // Note: Initial sync will be handled by background workers (every 15 min)
      // User can manually trigger sync via syncNow() if needed immediately

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Sign in failed: $e',
      );
      return false;
    }
  }

  /// Update feature toggles
  Future<bool> updateFeatures({
    required bool enableGmail,
    required bool enableCalendar,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final success = await _client.googleAuth.updateFeatures(
        enableGmail,
        enableCalendar,
      );

      if (success) {
        state = state.copyWith(
          isLoading: false,
          gmailEnabled: enableGmail,
          calendarEnabled: enableCalendar,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to update features',
        );
      }

      return success;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update features: $e',
      );
      return false;
    }
  }

  /// Disconnect Google account
  Future<bool> disconnect() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Revoke on server
      await _client.googleAuth.revokeAccess();

      // Sign out from Google
      await _googleSignIn.signOut();

      state = const GoogleAuthState();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to disconnect: $e',
      );
      return false;
    }
  }

  /// Trigger manual sync
  /// This may take a while for initial sync with many emails
  Future<void> syncNow() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Sync emails if enabled (incremental sync by default)
      if (state.gmailEnabled) {
        try {
          await _client.integration.syncEmails(fullSync: false);
        } catch (e) {
          // Email sync might timeout on first sync, that's okay
          // Background workers will continue syncing
          print('Email sync error (may complete in background): $e');
        }
      }

      // Sync calendar if enabled
      if (state.calendarEnabled) {
        try {
          await _client.integration.syncCalendar(daysAhead: 30);
        } catch (e) {
          print('Calendar sync error: $e');
        }
      }

      // Refresh status regardless of sync errors
      await checkAuthStatus();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Sync failed: $e',
      );
    }
  }
}

/// Provider for Google Auth
final googleAuthProvider =
    StateNotifierProvider<GoogleAuthNotifier, GoogleAuthState>((ref) {
  final client = ref.watch(clientProvider);
  return GoogleAuthNotifier(client);
});

/// Provider for integration dashboard data
final integrationDashboardProvider = FutureProvider<IntegrationDashboard?>((ref) async {
  final client = ref.watch(clientProvider);
  final authState = ref.watch(googleAuthProvider);

  if (!authState.isAuthenticated) {
    return null;
  }

  try {
    return await client.integration.getDashboard();
  } catch (e) {
    return null;
  }
});

/// Provider for important emails
final importantEmailsProvider = FutureProvider<List<EmailSummary>>((ref) async {
  final client = ref.watch(clientProvider);
  final authState = ref.watch(googleAuthProvider);

  if (!authState.isAuthenticated || !authState.gmailEnabled) {
    return [];
  }

  try {
    return await client.integration.getImportantEmails();
  } catch (e) {
    return [];
  }
});

/// Provider for today's calendar events
final todayEventsProvider = FutureProvider<List<CalendarEventCache>>((ref) async {
  final client = ref.watch(clientProvider);
  final authState = ref.watch(googleAuthProvider);

  if (!authState.isAuthenticated || !authState.calendarEnabled) {
    return [];
  }

  try {
    return await client.integration.getTodayEvents();
  } catch (e) {
    return [];
  }
});

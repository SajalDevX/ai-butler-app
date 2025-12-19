/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:recall_butler_client/src/protocol/action.dart' as _i3;
import 'package:recall_butler_client/src/protocol/capture.dart' as _i4;
import 'package:recall_butler_client/src/protocol/capture_request.dart' as _i5;
import 'package:recall_butler_client/src/protocol/collection.dart' as _i6;
import 'package:recall_butler_client/src/protocol/dashboard_stats.dart' as _i7;
import 'package:recall_butler_client/src/protocol/morning_briefing.dart' as _i8;
import 'package:recall_butler_client/src/protocol/google_auth_result.dart'
    as _i9;
import 'package:recall_butler_client/src/protocol/google_auth_status.dart'
    as _i10;
import 'package:recall_butler_client/src/protocol/weekly_digest.dart' as _i11;
import 'package:recall_butler_client/src/protocol/email_summary.dart' as _i12;
import 'package:recall_butler_client/src/protocol/email_draft_result.dart'
    as _i13;
import 'package:recall_butler_client/src/protocol/sync_result.dart' as _i14;
import 'package:recall_butler_client/src/protocol/calendar_event_cache.dart'
    as _i15;
import 'package:recall_butler_client/src/protocol/meeting_prep_result.dart'
    as _i16;
import 'package:recall_butler_client/src/protocol/integration_dashboard.dart'
    as _i17;
import 'package:recall_butler_client/src/protocol/notification_log.dart'
    as _i18;
import 'package:recall_butler_client/src/protocol/search_result.dart' as _i19;
import 'package:recall_butler_client/src/protocol/search_request.dart' as _i20;
import 'package:recall_butler_client/src/protocol/user_preference.dart' as _i21;
import 'package:recall_butler_client/src/protocol/greeting.dart' as _i22;
import 'protocol.dart' as _i23;

/// {@category Endpoint}
class EndpointAction extends _i1.EndpointRef {
  EndpointAction(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'action';

  /// Create a new action
  _i2.Future<_i3.Action> createAction(
    String type,
    String title, {
    String? notes,
    DateTime? dueAt,
    String? priority,
    int? captureId,
  }) =>
      caller.callServerEndpoint<_i3.Action>(
        'action',
        'createAction',
        {
          'type': type,
          'title': title,
          'notes': notes,
          'dueAt': dueAt,
          'priority': priority,
          'captureId': captureId,
        },
      );

  /// Create multiple actions from AI extraction (used when processing captures)
  _i2.Future<List<_i3.Action>> createActionsFromCapture(
    int captureId,
    List<Map<String, dynamic>> actionItems,
  ) =>
      caller.callServerEndpoint<List<_i3.Action>>(
        'action',
        'createActionsFromCapture',
        {
          'captureId': captureId,
          'actionItems': actionItems,
        },
      );

  /// Get all actions for the current user
  _i2.Future<List<_i3.Action>> getActions({
    int? limit,
    int? offset,
    String? type,
    bool? isCompleted,
    bool? dueSoon,
  }) =>
      caller.callServerEndpoint<List<_i3.Action>>(
        'action',
        'getActions',
        {
          'limit': limit,
          'offset': offset,
          'type': type,
          'isCompleted': isCompleted,
          'dueSoon': dueSoon,
        },
      );

  /// Get pending actions (not completed)
  _i2.Future<List<_i3.Action>> getPendingActions() =>
      caller.callServerEndpoint<List<_i3.Action>>(
        'action',
        'getPendingActions',
        {},
      );

  /// Get actions due today
  _i2.Future<List<_i3.Action>> getTodayActions() =>
      caller.callServerEndpoint<List<_i3.Action>>(
        'action',
        'getTodayActions',
        {},
      );

  /// Get overdue actions
  _i2.Future<List<_i3.Action>> getOverdueActions() =>
      caller.callServerEndpoint<List<_i3.Action>>(
        'action',
        'getOverdueActions',
        {},
      );

  /// Get a single action by ID
  _i2.Future<_i3.Action?> getAction(int actionId) =>
      caller.callServerEndpoint<_i3.Action?>(
        'action',
        'getAction',
        {'actionId': actionId},
      );

  /// Update an action
  _i2.Future<_i3.Action?> updateAction(
    int actionId, {
    String? title,
    String? notes,
    DateTime? dueAt,
    String? priority,
    String? type,
  }) =>
      caller.callServerEndpoint<_i3.Action?>(
        'action',
        'updateAction',
        {
          'actionId': actionId,
          'title': title,
          'notes': notes,
          'dueAt': dueAt,
          'priority': priority,
          'type': type,
        },
      );

  /// Mark an action as completed
  _i2.Future<_i3.Action?> completeAction(int actionId) =>
      caller.callServerEndpoint<_i3.Action?>(
        'action',
        'completeAction',
        {'actionId': actionId},
      );

  /// Mark an action as not completed (undo)
  _i2.Future<_i3.Action?> uncompleteAction(int actionId) =>
      caller.callServerEndpoint<_i3.Action?>(
        'action',
        'uncompleteAction',
        {'actionId': actionId},
      );

  /// Delete an action
  _i2.Future<bool> deleteAction(int actionId) =>
      caller.callServerEndpoint<bool>(
        'action',
        'deleteAction',
        {'actionId': actionId},
      );

  /// Get action statistics for dashboard
  _i2.Future<Map<String, dynamic>> getActionStats() =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'action',
        'getActionStats',
        {},
      );

  /// Get actions for a specific capture
  _i2.Future<List<_i3.Action>> getActionsForCapture(int captureId) =>
      caller.callServerEndpoint<List<_i3.Action>>(
        'action',
        'getActionsForCapture',
        {'captureId': captureId},
      );
}

/// {@category Endpoint}
class EndpointCapture extends _i1.EndpointRef {
  EndpointCapture(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'capture';

  /// Creates a new capture from uploaded content
  /// Uses two-phase processing:
  /// - Phase 1 (Sync): Quick AI analysis, returns in <2 seconds
  /// - Phase 2 (Async): Deep analysis runs in background
  _i2.Future<_i4.Capture> createCapture(_i5.CaptureRequest request) =>
      caller.callServerEndpoint<_i4.Capture>(
        'capture',
        'createCapture',
        {'request': request},
      );

  /// Get all captures for the current user
  _i2.Future<List<_i4.Capture>> getCaptures({
    int? limit,
    int? offset,
    String? category,
    String? type,
  }) =>
      caller.callServerEndpoint<List<_i4.Capture>>(
        'capture',
        'getCaptures',
        {
          'limit': limit,
          'offset': offset,
          'category': category,
          'type': type,
        },
      );

  /// Get a single capture by ID
  _i2.Future<_i4.Capture?> getCapture(int captureId) =>
      caller.callServerEndpoint<_i4.Capture?>(
        'capture',
        'getCapture',
        {'captureId': captureId},
      );

  /// Delete a capture
  _i2.Future<bool> deleteCapture(int captureId) =>
      caller.callServerEndpoint<bool>(
        'capture',
        'deleteCapture',
        {'captureId': captureId},
      );

  /// Get captures by date range (for timeline view)
  _i2.Future<List<_i4.Capture>> getCapturesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) =>
      caller.callServerEndpoint<List<_i4.Capture>>(
        'capture',
        'getCapturesByDateRange',
        {
          'startDate': startDate,
          'endDate': endDate,
        },
      );

  /// Update capture category
  _i2.Future<_i4.Capture?> updateCategory(
    int captureId,
    String category,
  ) =>
      caller.callServerEndpoint<_i4.Capture?>(
        'capture',
        'updateCategory',
        {
          'captureId': captureId,
          'category': category,
        },
      );

  /// Get captures marked as reminders
  _i2.Future<List<_i4.Capture>> getReminders() =>
      caller.callServerEndpoint<List<_i4.Capture>>(
        'capture',
        'getReminders',
        {},
      );
}

/// {@category Endpoint}
class EndpointCollection extends _i1.EndpointRef {
  EndpointCollection(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'collection';

  /// Create a new collection
  _i2.Future<_i6.Collection> createCollection(
    String name, {
    String? description,
  }) =>
      caller.callServerEndpoint<_i6.Collection>(
        'collection',
        'createCollection',
        {
          'name': name,
          'description': description,
        },
      );

  /// Get all collections for the user
  _i2.Future<List<_i6.Collection>> getCollections() =>
      caller.callServerEndpoint<List<_i6.Collection>>(
        'collection',
        'getCollections',
        {},
      );

  /// Get a single collection with its captures
  _i2.Future<_i6.Collection?> getCollection(int collectionId) =>
      caller.callServerEndpoint<_i6.Collection?>(
        'collection',
        'getCollection',
        {'collectionId': collectionId},
      );

  /// Get captures in a collection
  _i2.Future<List<_i4.Capture>> getCollectionCaptures(int collectionId) =>
      caller.callServerEndpoint<List<_i4.Capture>>(
        'collection',
        'getCollectionCaptures',
        {'collectionId': collectionId},
      );

  /// Add a capture to a collection
  _i2.Future<bool> addCaptureToCollection(
    int captureId,
    int collectionId,
  ) =>
      caller.callServerEndpoint<bool>(
        'collection',
        'addCaptureToCollection',
        {
          'captureId': captureId,
          'collectionId': collectionId,
        },
      );

  /// Remove a capture from a collection
  _i2.Future<bool> removeCaptureFromCollection(
    int captureId,
    int collectionId,
  ) =>
      caller.callServerEndpoint<bool>(
        'collection',
        'removeCaptureFromCollection',
        {
          'captureId': captureId,
          'collectionId': collectionId,
        },
      );

  /// Update collection details
  _i2.Future<_i6.Collection?> updateCollection(
    int collectionId, {
    String? name,
    String? description,
  }) =>
      caller.callServerEndpoint<_i6.Collection?>(
        'collection',
        'updateCollection',
        {
          'collectionId': collectionId,
          'name': name,
          'description': description,
        },
      );

  /// Delete a collection
  _i2.Future<bool> deleteCollection(int collectionId) =>
      caller.callServerEndpoint<bool>(
        'collection',
        'deleteCollection',
        {'collectionId': collectionId},
      );
}

/// {@category Endpoint}
class EndpointDashboard extends _i1.EndpointRef {
  EndpointDashboard(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'dashboard';

  /// Get comprehensive dashboard statistics
  _i2.Future<_i7.DashboardStats> getDashboardStats() =>
      caller.callServerEndpoint<_i7.DashboardStats>(
        'dashboard',
        'getDashboardStats',
        {},
      );

  /// Get morning briefing content
  _i2.Future<_i8.MorningBriefing> getMorningBriefing() =>
      caller.callServerEndpoint<_i8.MorningBriefing>(
        'dashboard',
        'getMorningBriefing',
        {},
      );
}

/// Endpoint for Google OAuth authentication
/// Handles token exchange, refresh, and revocation
/// {@category Endpoint}
class EndpointGoogleAuth extends _i1.EndpointRef {
  EndpointGoogleAuth(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'googleAuth';

  /// Exchange authorization code for tokens
  /// Called after user completes Google OAuth consent screen
  _i2.Future<_i9.GoogleAuthResult> exchangeCode(
    String authCode,
    String redirectUri,
    bool enableGmail,
    bool enableCalendar,
  ) =>
      caller.callServerEndpoint<_i9.GoogleAuthResult>(
        'googleAuth',
        'exchangeCode',
        {
          'authCode': authCode,
          'redirectUri': redirectUri,
          'enableGmail': enableGmail,
          'enableCalendar': enableCalendar,
        },
      );

  /// Get current authentication status
  _i2.Future<_i10.GoogleAuthStatus> getAuthStatus() =>
      caller.callServerEndpoint<_i10.GoogleAuthStatus>(
        'googleAuth',
        'getAuthStatus',
        {},
      );

  /// Update feature toggles (enable/disable Gmail or Calendar)
  _i2.Future<bool> updateFeatures(
    bool enableGmail,
    bool enableCalendar,
  ) =>
      caller.callServerEndpoint<bool>(
        'googleAuth',
        'updateFeatures',
        {
          'enableGmail': enableGmail,
          'enableCalendar': enableCalendar,
        },
      );

  /// Revoke Google access and delete stored tokens
  _i2.Future<bool> revokeAccess() => caller.callServerEndpoint<bool>(
        'googleAuth',
        'revokeAccess',
        {},
      );
}

/// {@category Endpoint}
class EndpointInsight extends _i1.EndpointRef {
  EndpointInsight(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'insight';

  /// Get proactive insights for the user
  _i2.Future<List<_i4.Capture>> getProactiveInsights() =>
      caller.callServerEndpoint<List<_i4.Capture>>(
        'insight',
        'getProactiveInsights',
        {},
      );

  /// Get related captures for a given capture
  _i2.Future<List<_i4.Capture>> getRelatedCaptures(int captureId) =>
      caller.callServerEndpoint<List<_i4.Capture>>(
        'insight',
        'getRelatedCaptures',
        {'captureId': captureId},
      );

  /// Generate weekly digest
  _i2.Future<_i11.WeeklyDigest> getWeeklyDigest() =>
      caller.callServerEndpoint<_i11.WeeklyDigest>(
        'insight',
        'getWeeklyDigest',
        {},
      );

  /// Get capture statistics
  _i2.Future<Map<String, dynamic>> getStatistics() =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'insight',
        'getStatistics',
        {},
      );

  /// Dismiss a proactive insight
  _i2.Future<void> dismissInsight(int captureId) =>
      caller.callServerEndpoint<void>(
        'insight',
        'dismissInsight',
        {'captureId': captureId},
      );
}

/// Endpoint for Google integration features (Gmail, Calendar)
/// {@category Endpoint}
class EndpointIntegration extends _i1.EndpointRef {
  EndpointIntegration(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'integration';

  /// Get emails with optional filters
  _i2.Future<List<_i12.EmailSummary>> getEmails({
    int? limit,
    int? offset,
    String? category,
    int? minImportance,
    bool? requiresAction,
    bool? unreadOnly,
  }) =>
      caller.callServerEndpoint<List<_i12.EmailSummary>>(
        'integration',
        'getEmails',
        {
          'limit': limit,
          'offset': offset,
          'category': category,
          'minImportance': minImportance,
          'requiresAction': requiresAction,
          'unreadOnly': unreadOnly,
        },
      );

  /// Get a single email by ID
  _i2.Future<_i12.EmailSummary?> getEmail(int emailId) =>
      caller.callServerEndpoint<_i12.EmailSummary?>(
        'integration',
        'getEmail',
        {'emailId': emailId},
      );

  /// Get important emails (importance >= 7)
  _i2.Future<List<_i12.EmailSummary>> getImportantEmails({int? limit}) =>
      caller.callServerEndpoint<List<_i12.EmailSummary>>(
        'integration',
        'getImportantEmails',
        {'limit': limit},
      );

  /// Get emails requiring action
  _i2.Future<List<_i12.EmailSummary>> getActionableEmails({int? limit}) =>
      caller.callServerEndpoint<List<_i12.EmailSummary>>(
        'integration',
        'getActionableEmails',
        {'limit': limit},
      );

  /// Generate AI draft reply for an email
  _i2.Future<_i13.EmailDraftResult> generateDraft(
    int emailId, {
    required String tone,
    String? additionalContext,
  }) =>
      caller.callServerEndpoint<_i13.EmailDraftResult>(
        'integration',
        'generateDraft',
        {
          'emailId': emailId,
          'tone': tone,
          'additionalContext': additionalContext,
        },
      );

  /// Create a Gmail draft from generated text
  _i2.Future<bool> createGmailDraft(
    int emailId,
    String replyText,
  ) =>
      caller.callServerEndpoint<bool>(
        'integration',
        'createGmailDraft',
        {
          'emailId': emailId,
          'replyText': replyText,
        },
      );

  /// Trigger manual email sync
  _i2.Future<_i14.SyncResult> syncEmails({required bool fullSync}) =>
      caller.callServerEndpoint<_i14.SyncResult>(
        'integration',
        'syncEmails',
        {'fullSync': fullSync},
      );

  /// Get daily email digest
  _i2.Future<String?> getDailyDigest() => caller.callServerEndpoint<String?>(
        'integration',
        'getDailyDigest',
        {},
      );

  /// Get upcoming calendar events
  _i2.Future<List<_i15.CalendarEventCache>> getUpcomingEvents({
    required int hoursAhead,
    int? limit,
  }) =>
      caller.callServerEndpoint<List<_i15.CalendarEventCache>>(
        'integration',
        'getUpcomingEvents',
        {
          'hoursAhead': hoursAhead,
          'limit': limit,
        },
      );

  /// Get today's calendar events
  _i2.Future<List<_i15.CalendarEventCache>> getTodayEvents() =>
      caller.callServerEndpoint<List<_i15.CalendarEventCache>>(
        'integration',
        'getTodayEvents',
        {},
      );

  /// Get events for a date range
  _i2.Future<List<_i15.CalendarEventCache>> getEventsByRange(
    DateTime startDate,
    DateTime endDate,
  ) =>
      caller.callServerEndpoint<List<_i15.CalendarEventCache>>(
        'integration',
        'getEventsByRange',
        {
          'startDate': startDate,
          'endDate': endDate,
        },
      );

  /// Get a single event by ID
  _i2.Future<_i15.CalendarEventCache?> getEvent(int eventId) =>
      caller.callServerEndpoint<_i15.CalendarEventCache?>(
        'integration',
        'getEvent',
        {'eventId': eventId},
      );

  /// Generate meeting preparation brief
  _i2.Future<_i16.MeetingPrepResult> generateMeetingPrep(int eventId) =>
      caller.callServerEndpoint<_i16.MeetingPrepResult>(
        'integration',
        'generateMeetingPrep',
        {'eventId': eventId},
      );

  /// Trigger manual calendar sync
  _i2.Future<_i14.SyncResult> syncCalendar({required int daysAhead}) =>
      caller.callServerEndpoint<_i14.SyncResult>(
        'integration',
        'syncCalendar',
        {'daysAhead': daysAhead},
      );

  /// Get integrated dashboard data
  _i2.Future<_i17.IntegrationDashboard> getDashboard() =>
      caller.callServerEndpoint<_i17.IntegrationDashboard>(
        'integration',
        'getDashboard',
        {},
      );
}

/// Endpoint for managing push notifications and device tokens
/// {@category Endpoint}
class EndpointNotification extends _i1.EndpointRef {
  EndpointNotification(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'notification';

  /// Register a device token for push notifications
  _i2.Future<bool> registerDeviceToken(
    String fcmToken,
    String deviceType,
    String? deviceName,
  ) =>
      caller.callServerEndpoint<bool>(
        'notification',
        'registerDeviceToken',
        {
          'fcmToken': fcmToken,
          'deviceType': deviceType,
          'deviceName': deviceName,
        },
      );

  /// Unregister a device token (called on logout or when user disables notifications)
  _i2.Future<bool> unregisterDeviceToken(String fcmToken) =>
      caller.callServerEndpoint<bool>(
        'notification',
        'unregisterDeviceToken',
        {'fcmToken': fcmToken},
      );

  /// Get notification history for the user
  _i2.Future<List<_i18.NotificationLog>> getNotificationHistory(
          {required int limit}) =>
      caller.callServerEndpoint<List<_i18.NotificationLog>>(
        'notification',
        'getNotificationHistory',
        {'limit': limit},
      );

  /// Mark a notification as read
  _i2.Future<bool> markNotificationRead(int notificationId) =>
      caller.callServerEndpoint<bool>(
        'notification',
        'markNotificationRead',
        {'notificationId': notificationId},
      );

  /// Get count of unread critical notifications
  _i2.Future<int> getUnreadCriticalCount() => caller.callServerEndpoint<int>(
        'notification',
        'getUnreadCriticalCount',
        {},
      );

  /// Send a test notification (for debugging)
  _i2.Future<bool> sendTestNotification() => caller.callServerEndpoint<bool>(
        'notification',
        'sendTestNotification',
        {},
      );

  /// Process and send notifications for unnotified critical emails
  /// Call this to retroactively notify for emails processed before notification was enabled
  _i2.Future<int> processUnnotifiedEmails() => caller.callServerEndpoint<int>(
        'notification',
        'processUnnotifiedEmails',
        {},
      );
}

/// {@category Endpoint}
class EndpointSearch extends _i1.EndpointRef {
  EndpointSearch(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'search';

  /// Perform semantic search across captures
  _i2.Future<_i19.SearchResult> search(_i20.SearchRequest request) =>
      caller.callServerEndpoint<_i19.SearchResult>(
        'search',
        'search',
        {'request': request},
      );

  /// Quick search for autocomplete
  _i2.Future<List<String>> quickSearch(String query) =>
      caller.callServerEndpoint<List<String>>(
        'search',
        'quickSearch',
        {'query': query},
      );

  /// Get recent searches for the user
  _i2.Future<List<String>> getRecentSearches() =>
      caller.callServerEndpoint<List<String>>(
        'search',
        'getRecentSearches',
        {},
      );

  /// Record when user clicks on a search result
  _i2.Future<void> recordSearchClick(
    int searchQueryId,
    int captureId,
  ) =>
      caller.callServerEndpoint<void>(
        'search',
        'recordSearchClick',
        {
          'searchQueryId': searchQueryId,
          'captureId': captureId,
        },
      );
}

/// {@category Endpoint}
class EndpointUserPreference extends _i1.EndpointRef {
  EndpointUserPreference(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'userPreference';

  /// Get user preferences, creating default if not exists
  _i2.Future<_i21.UserPreference> getPreferences() =>
      caller.callServerEndpoint<_i21.UserPreference>(
        'userPreference',
        'getPreferences',
        {},
      );

  /// Update user preferences
  _i2.Future<_i21.UserPreference> updatePreferences({
    String? timezone,
    String? notificationTime,
    bool? overlayEnabled,
    bool? weeklyDigestEnabled,
    bool? proactiveRemindersEnabled,
    String? theme,
  }) =>
      caller.callServerEndpoint<_i21.UserPreference>(
        'userPreference',
        'updatePreferences',
        {
          'timezone': timezone,
          'notificationTime': notificationTime,
          'overlayEnabled': overlayEnabled,
          'weeklyDigestEnabled': weeklyDigestEnabled,
          'proactiveRemindersEnabled': proactiveRemindersEnabled,
          'theme': theme,
        },
      );

  /// Toggle floating overlay
  _i2.Future<bool> toggleOverlay() => caller.callServerEndpoint<bool>(
        'userPreference',
        'toggleOverlay',
        {},
      );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i1.EndpointRef {
  EndpointGreeting(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i2.Future<_i22.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i22.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )? onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
          host,
          _i23.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    action = EndpointAction(this);
    capture = EndpointCapture(this);
    collection = EndpointCollection(this);
    dashboard = EndpointDashboard(this);
    googleAuth = EndpointGoogleAuth(this);
    insight = EndpointInsight(this);
    integration = EndpointIntegration(this);
    notification = EndpointNotification(this);
    search = EndpointSearch(this);
    userPreference = EndpointUserPreference(this);
    greeting = EndpointGreeting(this);
  }

  late final EndpointAction action;

  late final EndpointCapture capture;

  late final EndpointCollection collection;

  late final EndpointDashboard dashboard;

  late final EndpointGoogleAuth googleAuth;

  late final EndpointInsight insight;

  late final EndpointIntegration integration;

  late final EndpointNotification notification;

  late final EndpointSearch search;

  late final EndpointUserPreference userPreference;

  late final EndpointGreeting greeting;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'action': action,
        'capture': capture,
        'collection': collection,
        'dashboard': dashboard,
        'googleAuth': googleAuth,
        'insight': insight,
        'integration': integration,
        'notification': notification,
        'search': search,
        'userPreference': userPreference,
        'greeting': greeting,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {};
}

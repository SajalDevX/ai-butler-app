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
import 'package:recall_butler_client/src/protocol/weekly_digest.dart' as _i9;
import 'package:recall_butler_client/src/protocol/search_result.dart' as _i10;
import 'package:recall_butler_client/src/protocol/search_request.dart' as _i11;
import 'package:recall_butler_client/src/protocol/user_preference.dart' as _i12;
import 'package:recall_butler_client/src/protocol/greeting.dart' as _i13;
import 'protocol.dart' as _i14;

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
  _i2.Future<_i9.WeeklyDigest> getWeeklyDigest() =>
      caller.callServerEndpoint<_i9.WeeklyDigest>(
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

/// {@category Endpoint}
class EndpointSearch extends _i1.EndpointRef {
  EndpointSearch(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'search';

  /// Perform semantic search across captures
  _i2.Future<_i10.SearchResult> search(_i11.SearchRequest request) =>
      caller.callServerEndpoint<_i10.SearchResult>(
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
  _i2.Future<_i12.UserPreference> getPreferences() =>
      caller.callServerEndpoint<_i12.UserPreference>(
        'userPreference',
        'getPreferences',
        {},
      );

  /// Update user preferences
  _i2.Future<_i12.UserPreference> updatePreferences({
    String? timezone,
    String? notificationTime,
    bool? overlayEnabled,
    bool? weeklyDigestEnabled,
    bool? proactiveRemindersEnabled,
    String? theme,
  }) =>
      caller.callServerEndpoint<_i12.UserPreference>(
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
  _i2.Future<_i13.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i13.Greeting>(
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
          _i14.Protocol(),
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
    insight = EndpointInsight(this);
    search = EndpointSearch(this);
    userPreference = EndpointUserPreference(this);
    greeting = EndpointGreeting(this);
  }

  late final EndpointAction action;

  late final EndpointCapture capture;

  late final EndpointCollection collection;

  late final EndpointDashboard dashboard;

  late final EndpointInsight insight;

  late final EndpointSearch search;

  late final EndpointUserPreference userPreference;

  late final EndpointGreeting greeting;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'action': action,
        'capture': capture,
        'collection': collection,
        'dashboard': dashboard,
        'insight': insight,
        'search': search,
        'userPreference': userPreference,
        'greeting': greeting,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {};
}

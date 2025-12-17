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
import 'package:recall_butler_client/src/protocol/capture.dart' as _i3;
import 'package:recall_butler_client/src/protocol/capture_request.dart' as _i4;
import 'package:recall_butler_client/src/protocol/collection.dart' as _i5;
import 'package:recall_butler_client/src/protocol/weekly_digest.dart' as _i6;
import 'package:recall_butler_client/src/protocol/search_result.dart' as _i7;
import 'package:recall_butler_client/src/protocol/search_request.dart' as _i8;
import 'package:recall_butler_client/src/protocol/user_preference.dart' as _i9;
import 'package:recall_butler_client/src/protocol/greeting.dart' as _i10;
import 'protocol.dart' as _i11;

/// {@category Endpoint}
class EndpointCapture extends _i1.EndpointRef {
  EndpointCapture(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'capture';

  /// Creates a new capture from uploaded content
  _i2.Future<_i3.Capture> createCapture(_i4.CaptureRequest request) =>
      caller.callServerEndpoint<_i3.Capture>(
        'capture',
        'createCapture',
        {'request': request},
      );

  /// Get all captures for the current user
  _i2.Future<List<_i3.Capture>> getCaptures({
    int? limit,
    int? offset,
    String? category,
    String? type,
  }) =>
      caller.callServerEndpoint<List<_i3.Capture>>(
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
  _i2.Future<_i3.Capture?> getCapture(int captureId) =>
      caller.callServerEndpoint<_i3.Capture?>(
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
  _i2.Future<List<_i3.Capture>> getCapturesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) =>
      caller.callServerEndpoint<List<_i3.Capture>>(
        'capture',
        'getCapturesByDateRange',
        {
          'startDate': startDate,
          'endDate': endDate,
        },
      );

  /// Update capture category
  _i2.Future<_i3.Capture?> updateCategory(
    int captureId,
    String category,
  ) =>
      caller.callServerEndpoint<_i3.Capture?>(
        'capture',
        'updateCategory',
        {
          'captureId': captureId,
          'category': category,
        },
      );

  /// Get captures marked as reminders
  _i2.Future<List<_i3.Capture>> getReminders() =>
      caller.callServerEndpoint<List<_i3.Capture>>(
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
  _i2.Future<_i5.Collection> createCollection(
    String name, {
    String? description,
  }) =>
      caller.callServerEndpoint<_i5.Collection>(
        'collection',
        'createCollection',
        {
          'name': name,
          'description': description,
        },
      );

  /// Get all collections for the user
  _i2.Future<List<_i5.Collection>> getCollections() =>
      caller.callServerEndpoint<List<_i5.Collection>>(
        'collection',
        'getCollections',
        {},
      );

  /// Get a single collection with its captures
  _i2.Future<_i5.Collection?> getCollection(int collectionId) =>
      caller.callServerEndpoint<_i5.Collection?>(
        'collection',
        'getCollection',
        {'collectionId': collectionId},
      );

  /// Get captures in a collection
  _i2.Future<List<_i3.Capture>> getCollectionCaptures(int collectionId) =>
      caller.callServerEndpoint<List<_i3.Capture>>(
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
  _i2.Future<_i5.Collection?> updateCollection(
    int collectionId, {
    String? name,
    String? description,
  }) =>
      caller.callServerEndpoint<_i5.Collection?>(
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
class EndpointInsight extends _i1.EndpointRef {
  EndpointInsight(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'insight';

  /// Get proactive insights for the user
  _i2.Future<List<_i3.Capture>> getProactiveInsights() =>
      caller.callServerEndpoint<List<_i3.Capture>>(
        'insight',
        'getProactiveInsights',
        {},
      );

  /// Get related captures for a given capture
  _i2.Future<List<_i3.Capture>> getRelatedCaptures(int captureId) =>
      caller.callServerEndpoint<List<_i3.Capture>>(
        'insight',
        'getRelatedCaptures',
        {'captureId': captureId},
      );

  /// Generate weekly digest
  _i2.Future<_i6.WeeklyDigest> getWeeklyDigest() =>
      caller.callServerEndpoint<_i6.WeeklyDigest>(
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
  _i2.Future<_i7.SearchResult> search(_i8.SearchRequest request) =>
      caller.callServerEndpoint<_i7.SearchResult>(
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
  _i2.Future<_i9.UserPreference> getPreferences() =>
      caller.callServerEndpoint<_i9.UserPreference>(
        'userPreference',
        'getPreferences',
        {},
      );

  /// Update user preferences
  _i2.Future<_i9.UserPreference> updatePreferences({
    String? timezone,
    String? notificationTime,
    bool? overlayEnabled,
    bool? weeklyDigestEnabled,
    bool? proactiveRemindersEnabled,
    String? theme,
  }) =>
      caller.callServerEndpoint<_i9.UserPreference>(
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
  _i2.Future<_i10.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i10.Greeting>(
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
          _i11.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    capture = EndpointCapture(this);
    collection = EndpointCollection(this);
    insight = EndpointInsight(this);
    search = EndpointSearch(this);
    userPreference = EndpointUserPreference(this);
    greeting = EndpointGreeting(this);
  }

  late final EndpointCapture capture;

  late final EndpointCollection collection;

  late final EndpointInsight insight;

  late final EndpointSearch search;

  late final EndpointUserPreference userPreference;

  late final EndpointGreeting greeting;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'capture': capture,
        'collection': collection,
        'insight': insight,
        'search': search,
        'userPreference': userPreference,
        'greeting': greeting,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {};
}

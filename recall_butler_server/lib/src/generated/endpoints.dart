/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../endpoints/action_endpoint.dart' as _i2;
import '../endpoints/capture_endpoint.dart' as _i3;
import '../endpoints/collection_endpoint.dart' as _i4;
import '../endpoints/dashboard_endpoint.dart' as _i5;
import '../endpoints/google_auth_endpoint.dart' as _i6;
import '../endpoints/insight_endpoint.dart' as _i7;
import '../endpoints/integration_endpoint.dart' as _i8;
import '../endpoints/notification_endpoint.dart' as _i9;
import '../endpoints/search_endpoint.dart' as _i10;
import '../endpoints/user_preference_endpoint.dart' as _i11;
import '../greeting_endpoint.dart' as _i12;
import 'package:recall_butler_server/src/generated/capture_request.dart'
    as _i13;
import 'package:recall_butler_server/src/generated/search_request.dart' as _i14;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'action': _i2.ActionEndpoint()
        ..initialize(
          server,
          'action',
          null,
        ),
      'capture': _i3.CaptureEndpoint()
        ..initialize(
          server,
          'capture',
          null,
        ),
      'collection': _i4.CollectionEndpoint()
        ..initialize(
          server,
          'collection',
          null,
        ),
      'dashboard': _i5.DashboardEndpoint()
        ..initialize(
          server,
          'dashboard',
          null,
        ),
      'googleAuth': _i6.GoogleAuthEndpoint()
        ..initialize(
          server,
          'googleAuth',
          null,
        ),
      'insight': _i7.InsightEndpoint()
        ..initialize(
          server,
          'insight',
          null,
        ),
      'integration': _i8.IntegrationEndpoint()
        ..initialize(
          server,
          'integration',
          null,
        ),
      'notification': _i9.NotificationEndpoint()
        ..initialize(
          server,
          'notification',
          null,
        ),
      'search': _i10.SearchEndpoint()
        ..initialize(
          server,
          'search',
          null,
        ),
      'userPreference': _i11.UserPreferenceEndpoint()
        ..initialize(
          server,
          'userPreference',
          null,
        ),
      'greeting': _i12.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['action'] = _i1.EndpointConnector(
      name: 'action',
      endpoint: endpoints['action']!,
      methodConnectors: {
        'createAction': _i1.MethodConnector(
          name: 'createAction',
          params: {
            'type': _i1.ParameterDescription(
              name: 'type',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'notes': _i1.ParameterDescription(
              name: 'notes',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'dueAt': _i1.ParameterDescription(
              name: 'dueAt',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'priority': _i1.ParameterDescription(
              name: 'priority',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'captureId': _i1.ParameterDescription(
              name: 'captureId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['action'] as _i2.ActionEndpoint).createAction(
            session,
            params['type'],
            params['title'],
            notes: params['notes'],
            dueAt: params['dueAt'],
            priority: params['priority'],
            captureId: params['captureId'],
          ),
        ),
        'createActionsFromCapture': _i1.MethodConnector(
          name: 'createActionsFromCapture',
          params: {
            'captureId': _i1.ParameterDescription(
              name: 'captureId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'actionItems': _i1.ParameterDescription(
              name: 'actionItems',
              type: _i1.getType<List<Map<String, dynamic>>>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['action'] as _i2.ActionEndpoint)
                  .createActionsFromCapture(
            session,
            params['captureId'],
            params['actionItems'],
          ),
        ),
        'getActions': _i1.MethodConnector(
          name: 'getActions',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'type': _i1.ParameterDescription(
              name: 'type',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'isCompleted': _i1.ParameterDescription(
              name: 'isCompleted',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
            'dueSoon': _i1.ParameterDescription(
              name: 'dueSoon',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['action'] as _i2.ActionEndpoint).getActions(
            session,
            limit: params['limit'],
            offset: params['offset'],
            type: params['type'],
            isCompleted: params['isCompleted'],
            dueSoon: params['dueSoon'],
          ),
        ),
        'getPendingActions': _i1.MethodConnector(
          name: 'getPendingActions',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['action'] as _i2.ActionEndpoint)
                  .getPendingActions(session),
        ),
        'getTodayActions': _i1.MethodConnector(
          name: 'getTodayActions',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['action'] as _i2.ActionEndpoint)
                  .getTodayActions(session),
        ),
        'getOverdueActions': _i1.MethodConnector(
          name: 'getOverdueActions',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['action'] as _i2.ActionEndpoint)
                  .getOverdueActions(session),
        ),
        'getAction': _i1.MethodConnector(
          name: 'getAction',
          params: {
            'actionId': _i1.ParameterDescription(
              name: 'actionId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['action'] as _i2.ActionEndpoint).getAction(
            session,
            params['actionId'],
          ),
        ),
        'updateAction': _i1.MethodConnector(
          name: 'updateAction',
          params: {
            'actionId': _i1.ParameterDescription(
              name: 'actionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'notes': _i1.ParameterDescription(
              name: 'notes',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'dueAt': _i1.ParameterDescription(
              name: 'dueAt',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'priority': _i1.ParameterDescription(
              name: 'priority',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'type': _i1.ParameterDescription(
              name: 'type',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['action'] as _i2.ActionEndpoint).updateAction(
            session,
            params['actionId'],
            title: params['title'],
            notes: params['notes'],
            dueAt: params['dueAt'],
            priority: params['priority'],
            type: params['type'],
          ),
        ),
        'completeAction': _i1.MethodConnector(
          name: 'completeAction',
          params: {
            'actionId': _i1.ParameterDescription(
              name: 'actionId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['action'] as _i2.ActionEndpoint).completeAction(
            session,
            params['actionId'],
          ),
        ),
        'uncompleteAction': _i1.MethodConnector(
          name: 'uncompleteAction',
          params: {
            'actionId': _i1.ParameterDescription(
              name: 'actionId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['action'] as _i2.ActionEndpoint).uncompleteAction(
            session,
            params['actionId'],
          ),
        ),
        'deleteAction': _i1.MethodConnector(
          name: 'deleteAction',
          params: {
            'actionId': _i1.ParameterDescription(
              name: 'actionId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['action'] as _i2.ActionEndpoint).deleteAction(
            session,
            params['actionId'],
          ),
        ),
        'getActionStats': _i1.MethodConnector(
          name: 'getActionStats',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['action'] as _i2.ActionEndpoint)
                  .getActionStats(session),
        ),
        'getActionsForCapture': _i1.MethodConnector(
          name: 'getActionsForCapture',
          params: {
            'captureId': _i1.ParameterDescription(
              name: 'captureId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['action'] as _i2.ActionEndpoint).getActionsForCapture(
            session,
            params['captureId'],
          ),
        ),
      },
    );
    connectors['capture'] = _i1.EndpointConnector(
      name: 'capture',
      endpoint: endpoints['capture']!,
      methodConnectors: {
        'createCapture': _i1.MethodConnector(
          name: 'createCapture',
          params: {
            'request': _i1.ParameterDescription(
              name: 'request',
              type: _i1.getType<_i13.CaptureRequest>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['capture'] as _i3.CaptureEndpoint).createCapture(
            session,
            params['request'],
          ),
        ),
        'getCaptures': _i1.MethodConnector(
          name: 'getCaptures',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'type': _i1.ParameterDescription(
              name: 'type',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['capture'] as _i3.CaptureEndpoint).getCaptures(
            session,
            limit: params['limit'],
            offset: params['offset'],
            category: params['category'],
            type: params['type'],
          ),
        ),
        'getCapture': _i1.MethodConnector(
          name: 'getCapture',
          params: {
            'captureId': _i1.ParameterDescription(
              name: 'captureId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['capture'] as _i3.CaptureEndpoint).getCapture(
            session,
            params['captureId'],
          ),
        ),
        'deleteCapture': _i1.MethodConnector(
          name: 'deleteCapture',
          params: {
            'captureId': _i1.ParameterDescription(
              name: 'captureId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['capture'] as _i3.CaptureEndpoint).deleteCapture(
            session,
            params['captureId'],
          ),
        ),
        'getCapturesByDateRange': _i1.MethodConnector(
          name: 'getCapturesByDateRange',
          params: {
            'startDate': _i1.ParameterDescription(
              name: 'startDate',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'endDate': _i1.ParameterDescription(
              name: 'endDate',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['capture'] as _i3.CaptureEndpoint)
                  .getCapturesByDateRange(
            session,
            params['startDate'],
            params['endDate'],
          ),
        ),
        'updateCategory': _i1.MethodConnector(
          name: 'updateCategory',
          params: {
            'captureId': _i1.ParameterDescription(
              name: 'captureId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['capture'] as _i3.CaptureEndpoint).updateCategory(
            session,
            params['captureId'],
            params['category'],
          ),
        ),
        'getReminders': _i1.MethodConnector(
          name: 'getReminders',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['capture'] as _i3.CaptureEndpoint)
                  .getReminders(session),
        ),
      },
    );
    connectors['collection'] = _i1.EndpointConnector(
      name: 'collection',
      endpoint: endpoints['collection']!,
      methodConnectors: {
        'createCollection': _i1.MethodConnector(
          name: 'createCollection',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['collection'] as _i4.CollectionEndpoint)
                  .createCollection(
            session,
            params['name'],
            description: params['description'],
          ),
        ),
        'getCollections': _i1.MethodConnector(
          name: 'getCollections',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['collection'] as _i4.CollectionEndpoint)
                  .getCollections(session),
        ),
        'getCollection': _i1.MethodConnector(
          name: 'getCollection',
          params: {
            'collectionId': _i1.ParameterDescription(
              name: 'collectionId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['collection'] as _i4.CollectionEndpoint).getCollection(
            session,
            params['collectionId'],
          ),
        ),
        'getCollectionCaptures': _i1.MethodConnector(
          name: 'getCollectionCaptures',
          params: {
            'collectionId': _i1.ParameterDescription(
              name: 'collectionId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['collection'] as _i4.CollectionEndpoint)
                  .getCollectionCaptures(
            session,
            params['collectionId'],
          ),
        ),
        'addCaptureToCollection': _i1.MethodConnector(
          name: 'addCaptureToCollection',
          params: {
            'captureId': _i1.ParameterDescription(
              name: 'captureId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'collectionId': _i1.ParameterDescription(
              name: 'collectionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['collection'] as _i4.CollectionEndpoint)
                  .addCaptureToCollection(
            session,
            params['captureId'],
            params['collectionId'],
          ),
        ),
        'removeCaptureFromCollection': _i1.MethodConnector(
          name: 'removeCaptureFromCollection',
          params: {
            'captureId': _i1.ParameterDescription(
              name: 'captureId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'collectionId': _i1.ParameterDescription(
              name: 'collectionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['collection'] as _i4.CollectionEndpoint)
                  .removeCaptureFromCollection(
            session,
            params['captureId'],
            params['collectionId'],
          ),
        ),
        'updateCollection': _i1.MethodConnector(
          name: 'updateCollection',
          params: {
            'collectionId': _i1.ParameterDescription(
              name: 'collectionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['collection'] as _i4.CollectionEndpoint)
                  .updateCollection(
            session,
            params['collectionId'],
            name: params['name'],
            description: params['description'],
          ),
        ),
        'deleteCollection': _i1.MethodConnector(
          name: 'deleteCollection',
          params: {
            'collectionId': _i1.ParameterDescription(
              name: 'collectionId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['collection'] as _i4.CollectionEndpoint)
                  .deleteCollection(
            session,
            params['collectionId'],
          ),
        ),
      },
    );
    connectors['dashboard'] = _i1.EndpointConnector(
      name: 'dashboard',
      endpoint: endpoints['dashboard']!,
      methodConnectors: {
        'getDashboardStats': _i1.MethodConnector(
          name: 'getDashboardStats',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['dashboard'] as _i5.DashboardEndpoint)
                  .getDashboardStats(session),
        ),
        'getMorningBriefing': _i1.MethodConnector(
          name: 'getMorningBriefing',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['dashboard'] as _i5.DashboardEndpoint)
                  .getMorningBriefing(session),
        ),
      },
    );
    connectors['googleAuth'] = _i1.EndpointConnector(
      name: 'googleAuth',
      endpoint: endpoints['googleAuth']!,
      methodConnectors: {
        'exchangeCode': _i1.MethodConnector(
          name: 'exchangeCode',
          params: {
            'authCode': _i1.ParameterDescription(
              name: 'authCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'redirectUri': _i1.ParameterDescription(
              name: 'redirectUri',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'enableGmail': _i1.ParameterDescription(
              name: 'enableGmail',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'enableCalendar': _i1.ParameterDescription(
              name: 'enableCalendar',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['googleAuth'] as _i6.GoogleAuthEndpoint).exchangeCode(
            session,
            params['authCode'],
            params['redirectUri'],
            params['enableGmail'],
            params['enableCalendar'],
          ),
        ),
        'getAuthStatus': _i1.MethodConnector(
          name: 'getAuthStatus',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['googleAuth'] as _i6.GoogleAuthEndpoint)
                  .getAuthStatus(session),
        ),
        'updateFeatures': _i1.MethodConnector(
          name: 'updateFeatures',
          params: {
            'enableGmail': _i1.ParameterDescription(
              name: 'enableGmail',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'enableCalendar': _i1.ParameterDescription(
              name: 'enableCalendar',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['googleAuth'] as _i6.GoogleAuthEndpoint)
                  .updateFeatures(
            session,
            params['enableGmail'],
            params['enableCalendar'],
          ),
        ),
        'revokeAccess': _i1.MethodConnector(
          name: 'revokeAccess',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['googleAuth'] as _i6.GoogleAuthEndpoint)
                  .revokeAccess(session),
        ),
      },
    );
    connectors['insight'] = _i1.EndpointConnector(
      name: 'insight',
      endpoint: endpoints['insight']!,
      methodConnectors: {
        'getProactiveInsights': _i1.MethodConnector(
          name: 'getProactiveInsights',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['insight'] as _i7.InsightEndpoint)
                  .getProactiveInsights(session),
        ),
        'getRelatedCaptures': _i1.MethodConnector(
          name: 'getRelatedCaptures',
          params: {
            'captureId': _i1.ParameterDescription(
              name: 'captureId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['insight'] as _i7.InsightEndpoint).getRelatedCaptures(
            session,
            params['captureId'],
          ),
        ),
        'getWeeklyDigest': _i1.MethodConnector(
          name: 'getWeeklyDigest',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['insight'] as _i7.InsightEndpoint)
                  .getWeeklyDigest(session),
        ),
        'getStatistics': _i1.MethodConnector(
          name: 'getStatistics',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['insight'] as _i7.InsightEndpoint)
                  .getStatistics(session),
        ),
        'dismissInsight': _i1.MethodConnector(
          name: 'dismissInsight',
          params: {
            'captureId': _i1.ParameterDescription(
              name: 'captureId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['insight'] as _i7.InsightEndpoint).dismissInsight(
            session,
            params['captureId'],
          ),
        ),
      },
    );
    connectors['integration'] = _i1.EndpointConnector(
      name: 'integration',
      endpoint: endpoints['integration']!,
      methodConnectors: {
        'getEmails': _i1.MethodConnector(
          name: 'getEmails',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'minImportance': _i1.ParameterDescription(
              name: 'minImportance',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'requiresAction': _i1.ParameterDescription(
              name: 'requiresAction',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
            'unreadOnly': _i1.ParameterDescription(
              name: 'unreadOnly',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['integration'] as _i8.IntegrationEndpoint).getEmails(
            session,
            limit: params['limit'],
            offset: params['offset'],
            category: params['category'],
            minImportance: params['minImportance'],
            requiresAction: params['requiresAction'],
            unreadOnly: params['unreadOnly'],
          ),
        ),
        'getEmail': _i1.MethodConnector(
          name: 'getEmail',
          params: {
            'emailId': _i1.ParameterDescription(
              name: 'emailId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['integration'] as _i8.IntegrationEndpoint).getEmail(
            session,
            params['emailId'],
          ),
        ),
        'getImportantEmails': _i1.MethodConnector(
          name: 'getImportantEmails',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['integration'] as _i8.IntegrationEndpoint)
                  .getImportantEmails(
            session,
            limit: params['limit'],
          ),
        ),
        'getActionableEmails': _i1.MethodConnector(
          name: 'getActionableEmails',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['integration'] as _i8.IntegrationEndpoint)
                  .getActionableEmails(
            session,
            limit: params['limit'],
          ),
        ),
        'generateDraft': _i1.MethodConnector(
          name: 'generateDraft',
          params: {
            'emailId': _i1.ParameterDescription(
              name: 'emailId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'tone': _i1.ParameterDescription(
              name: 'tone',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'additionalContext': _i1.ParameterDescription(
              name: 'additionalContext',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['integration'] as _i8.IntegrationEndpoint)
                  .generateDraft(
            session,
            params['emailId'],
            tone: params['tone'],
            additionalContext: params['additionalContext'],
          ),
        ),
        'createGmailDraft': _i1.MethodConnector(
          name: 'createGmailDraft',
          params: {
            'emailId': _i1.ParameterDescription(
              name: 'emailId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'replyText': _i1.ParameterDescription(
              name: 'replyText',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['integration'] as _i8.IntegrationEndpoint)
                  .createGmailDraft(
            session,
            params['emailId'],
            params['replyText'],
          ),
        ),
        'syncEmails': _i1.MethodConnector(
          name: 'syncEmails',
          params: {
            'fullSync': _i1.ParameterDescription(
              name: 'fullSync',
              type: _i1.getType<bool>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['integration'] as _i8.IntegrationEndpoint).syncEmails(
            session,
            fullSync: params['fullSync'],
          ),
        ),
        'getDailyDigest': _i1.MethodConnector(
          name: 'getDailyDigest',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['integration'] as _i8.IntegrationEndpoint)
                  .getDailyDigest(session),
        ),
        'getUpcomingEvents': _i1.MethodConnector(
          name: 'getUpcomingEvents',
          params: {
            'hoursAhead': _i1.ParameterDescription(
              name: 'hoursAhead',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['integration'] as _i8.IntegrationEndpoint)
                  .getUpcomingEvents(
            session,
            hoursAhead: params['hoursAhead'],
            limit: params['limit'],
          ),
        ),
        'getTodayEvents': _i1.MethodConnector(
          name: 'getTodayEvents',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['integration'] as _i8.IntegrationEndpoint)
                  .getTodayEvents(session),
        ),
        'getEventsByRange': _i1.MethodConnector(
          name: 'getEventsByRange',
          params: {
            'startDate': _i1.ParameterDescription(
              name: 'startDate',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'endDate': _i1.ParameterDescription(
              name: 'endDate',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['integration'] as _i8.IntegrationEndpoint)
                  .getEventsByRange(
            session,
            params['startDate'],
            params['endDate'],
          ),
        ),
        'getEvent': _i1.MethodConnector(
          name: 'getEvent',
          params: {
            'eventId': _i1.ParameterDescription(
              name: 'eventId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['integration'] as _i8.IntegrationEndpoint).getEvent(
            session,
            params['eventId'],
          ),
        ),
        'generateMeetingPrep': _i1.MethodConnector(
          name: 'generateMeetingPrep',
          params: {
            'eventId': _i1.ParameterDescription(
              name: 'eventId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['integration'] as _i8.IntegrationEndpoint)
                  .generateMeetingPrep(
            session,
            params['eventId'],
          ),
        ),
        'syncCalendar': _i1.MethodConnector(
          name: 'syncCalendar',
          params: {
            'daysAhead': _i1.ParameterDescription(
              name: 'daysAhead',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['integration'] as _i8.IntegrationEndpoint)
                  .syncCalendar(
            session,
            daysAhead: params['daysAhead'],
          ),
        ),
        'getDashboard': _i1.MethodConnector(
          name: 'getDashboard',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['integration'] as _i8.IntegrationEndpoint)
                  .getDashboard(session),
        ),
      },
    );
    connectors['notification'] = _i1.EndpointConnector(
      name: 'notification',
      endpoint: endpoints['notification']!,
      methodConnectors: {
        'registerDeviceToken': _i1.MethodConnector(
          name: 'registerDeviceToken',
          params: {
            'fcmToken': _i1.ParameterDescription(
              name: 'fcmToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'deviceType': _i1.ParameterDescription(
              name: 'deviceType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'deviceName': _i1.ParameterDescription(
              name: 'deviceName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['notification'] as _i9.NotificationEndpoint)
                  .registerDeviceToken(
            session,
            params['fcmToken'],
            params['deviceType'],
            params['deviceName'],
          ),
        ),
        'unregisterDeviceToken': _i1.MethodConnector(
          name: 'unregisterDeviceToken',
          params: {
            'fcmToken': _i1.ParameterDescription(
              name: 'fcmToken',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['notification'] as _i9.NotificationEndpoint)
                  .unregisterDeviceToken(
            session,
            params['fcmToken'],
          ),
        ),
        'getNotificationHistory': _i1.MethodConnector(
          name: 'getNotificationHistory',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['notification'] as _i9.NotificationEndpoint)
                  .getNotificationHistory(
            session,
            limit: params['limit'],
          ),
        ),
        'markNotificationRead': _i1.MethodConnector(
          name: 'markNotificationRead',
          params: {
            'notificationId': _i1.ParameterDescription(
              name: 'notificationId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['notification'] as _i9.NotificationEndpoint)
                  .markNotificationRead(
            session,
            params['notificationId'],
          ),
        ),
        'getUnreadCriticalCount': _i1.MethodConnector(
          name: 'getUnreadCriticalCount',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['notification'] as _i9.NotificationEndpoint)
                  .getUnreadCriticalCount(session),
        ),
        'sendTestNotification': _i1.MethodConnector(
          name: 'sendTestNotification',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['notification'] as _i9.NotificationEndpoint)
                  .sendTestNotification(session),
        ),
        'processUnnotifiedEmails': _i1.MethodConnector(
          name: 'processUnnotifiedEmails',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['notification'] as _i9.NotificationEndpoint)
                  .processUnnotifiedEmails(session),
        ),
      },
    );
    connectors['search'] = _i1.EndpointConnector(
      name: 'search',
      endpoint: endpoints['search']!,
      methodConnectors: {
        'search': _i1.MethodConnector(
          name: 'search',
          params: {
            'request': _i1.ParameterDescription(
              name: 'request',
              type: _i1.getType<_i14.SearchRequest>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['search'] as _i10.SearchEndpoint).search(
            session,
            params['request'],
          ),
        ),
        'quickSearch': _i1.MethodConnector(
          name: 'quickSearch',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['search'] as _i10.SearchEndpoint).quickSearch(
            session,
            params['query'],
          ),
        ),
        'getRecentSearches': _i1.MethodConnector(
          name: 'getRecentSearches',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['search'] as _i10.SearchEndpoint)
                  .getRecentSearches(session),
        ),
        'recordSearchClick': _i1.MethodConnector(
          name: 'recordSearchClick',
          params: {
            'searchQueryId': _i1.ParameterDescription(
              name: 'searchQueryId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'captureId': _i1.ParameterDescription(
              name: 'captureId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['search'] as _i10.SearchEndpoint).recordSearchClick(
            session,
            params['searchQueryId'],
            params['captureId'],
          ),
        ),
      },
    );
    connectors['userPreference'] = _i1.EndpointConnector(
      name: 'userPreference',
      endpoint: endpoints['userPreference']!,
      methodConnectors: {
        'getPreferences': _i1.MethodConnector(
          name: 'getPreferences',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['userPreference'] as _i11.UserPreferenceEndpoint)
                  .getPreferences(session),
        ),
        'updatePreferences': _i1.MethodConnector(
          name: 'updatePreferences',
          params: {
            'timezone': _i1.ParameterDescription(
              name: 'timezone',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'notificationTime': _i1.ParameterDescription(
              name: 'notificationTime',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'overlayEnabled': _i1.ParameterDescription(
              name: 'overlayEnabled',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
            'weeklyDigestEnabled': _i1.ParameterDescription(
              name: 'weeklyDigestEnabled',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
            'proactiveRemindersEnabled': _i1.ParameterDescription(
              name: 'proactiveRemindersEnabled',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
            'theme': _i1.ParameterDescription(
              name: 'theme',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['userPreference'] as _i11.UserPreferenceEndpoint)
                  .updatePreferences(
            session,
            timezone: params['timezone'],
            notificationTime: params['notificationTime'],
            overlayEnabled: params['overlayEnabled'],
            weeklyDigestEnabled: params['weeklyDigestEnabled'],
            proactiveRemindersEnabled: params['proactiveRemindersEnabled'],
            theme: params['theme'],
          ),
        ),
        'toggleOverlay': _i1.MethodConnector(
          name: 'toggleOverlay',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['userPreference'] as _i11.UserPreferenceEndpoint)
                  .toggleOverlay(session),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['greeting'] as _i12.GreetingEndpoint).hello(
            session,
            params['name'],
          ),
        )
      },
    );
  }
}

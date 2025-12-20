import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recall_butler_client/recall_butler_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'firebase_options.dart';
import 'src/app.dart';
import 'src/providers/client_provider.dart';
import 'src/services/api_logger.dart';
import 'src/services/notification_service.dart';

/// Background message handler for FCM - must be top-level
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint('Background message: ${message.notification?.title}');
}

/// Global Serverpod client instance
late final Client client;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style for dark theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF1E293B), // AppColors.surface
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Configure timeago for relative timestamps
  timeago.setLocaleMessages('en', timeago.EnMessages());

  // Initialize Firebase for push notifications
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize local notification service
  await NotificationService().initialize();
  await NotificationService().requestPermissions();

  // Initialize the Serverpod client
  // For physical devices: Update this IP to your computer's local IP
  // Find it with: hostname -I | awk '{print $1}'
  const localNetworkIp = '10.22.225.69'; // <-- UPDATE THIS FOR YOUR NETWORK

  // Priority: 1) SERVER_URL env var, 2) localNetworkIp for physical, 3) localhost helper for emulator
  const serverUrlFromEnv = String.fromEnvironment('SERVER_URL');
  final serverUrl = serverUrlFromEnv.isNotEmpty
      ? serverUrlFromEnv
      : 'http://$localNetworkIp:8080/';

  client = Client(
    serverUrl,
    onSucceededCall: kDebugMode ? _onApiCallSucceeded : null,
    onFailedCall: kDebugMode ? _onApiCallFailed : null,
  )..connectivityMonitor = FlutterConnectivityMonitor();

  runApp(
    ProviderScope(
      overrides: [
        clientProvider.overrideWithValue(client),
      ],
      child: const RecallButlerApp(),
    ),
  );
}

/// Callback for successful API calls (debug mode only)
void _onApiCallSucceeded(MethodCallContext context) {
  ApiLogger.logSuccess(
    endpoint: context.endpointName,
    method: context.methodName,
    parameters: context.arguments,
  );
}

/// Callback for failed API calls (debug mode only)
void _onApiCallFailed(
  MethodCallContext context,
  Object error,
  StackTrace stackTrace,
) {
  ApiLogger.logError(
    endpoint: context.endpointName,
    method: context.methodName,
    parameters: context.arguments,
    error: error,
    stackTrace: stackTrace,
  );
}

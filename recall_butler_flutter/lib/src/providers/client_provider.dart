import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recall_butler_client/recall_butler_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

/// Production server URL (AWS)
const String productionServerUrl = 'http://35.89.112.97:8080/';

/// Local development IP - update this for your network
const String localDevIp = '10.22.225.69';

/// Check if using production from compile-time flag
const bool useProduction = bool.fromEnvironment('USE_PRODUCTION', defaultValue: false);

/// Provider for the Serverpod client
final clientProvider = Provider<Client>((ref) {
  // Use production if flag is set
  if (useProduction) {
    return Client(
      productionServerUrl,
      connectionTimeout: const Duration(seconds: 120),
    )..connectivityMonitor = FlutterConnectivityMonitor();
  }

  // Otherwise use platform-specific URLs for development
  String baseUrl;
  if (kIsWeb) {
    // Web uses relative URL or localhost
    baseUrl = 'http://localhost:8080/';
  } else if (Platform.isAndroid || Platform.isIOS) {
    // Mobile devices use host machine's local network IP
    baseUrl = 'http://$localDevIp:8080/';
  } else {
    // Desktop uses localhost
    baseUrl = 'http://localhost:8080/';
  }

  return Client(
    baseUrl,
    connectionTimeout: const Duration(seconds: 120), // Extended for AI processing
  )..connectivityMonitor = FlutterConnectivityMonitor();
});

/// Provider for connection state
final connectionStateProvider = StreamProvider<bool>((ref) async* {
  final client = ref.watch(clientProvider);

  // Initial state
  yield false;

  // Try to connect
  try {
    await client.openStreamingConnection();
    yield true;
  } catch (e) {
    yield false;
  }
});

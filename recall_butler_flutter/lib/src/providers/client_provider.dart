import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recall_butler_client/recall_butler_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

/// Provider for the Serverpod client
final clientProvider = Provider<Client>((ref) {
  // Use different URLs based on platform
  String baseUrl;
  if (kIsWeb) {
    // Web uses relative URL or localhost
    baseUrl = 'http://localhost:8080/';
  } else if (Platform.isAndroid || Platform.isIOS) {
    // Mobile devices use host machine's local network IP
    baseUrl = 'http://10.22.225.69:8080/';
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

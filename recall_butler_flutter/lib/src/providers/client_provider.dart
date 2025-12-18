import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recall_butler_client/recall_butler_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

/// Provider for the Serverpod client
final clientProvider = Provider<Client>((ref) {
  return Client(
    'http://localhost:8080/',
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

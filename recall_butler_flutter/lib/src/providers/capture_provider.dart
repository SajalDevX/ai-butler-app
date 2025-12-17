import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recall_butler_client/recall_butler_client.dart';
import 'client_provider.dart';

/// State for captures
class CapturesState {
  final List<Capture> captures;
  final bool isLoading;
  final String? error;
  final String? selectedCategory;
  final String? selectedType;

  const CapturesState({
    this.captures = const [],
    this.isLoading = false,
    this.error,
    this.selectedCategory,
    this.selectedType,
  });

  CapturesState copyWith({
    List<Capture>? captures,
    bool? isLoading,
    String? error,
    String? selectedCategory,
    String? selectedType,
  }) {
    return CapturesState(
      captures: captures ?? this.captures,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedType: selectedType ?? this.selectedType,
    );
  }
}

/// Notifier for captures state
class CapturesNotifier extends StateNotifier<CapturesState> {
  final Client _client;

  CapturesNotifier(this._client) : super(const CapturesState());

  /// Load all captures
  Future<void> loadCaptures({int? limit, int? offset}) async {
    state = state.copyWith(isLoading: true);

    try {
      final captures = await _client.capture.getCaptures(
        limit: limit,
        offset: offset,
        category: state.selectedCategory,
        type: state.selectedType,
      );
      state = state.copyWith(captures: captures, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Create a new capture from image bytes
  /// The server processes AI synchronously, so the returned capture is complete
  Future<Capture?> createImageCapture(
    Uint8List bytes,
    String type, {
    String? sourceApp,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      final request = CaptureRequest(
        type: type,
        fileData: base64Encode(bytes),
        sourceApp: sourceApp,
      );

      // Server waits for AI processing before returning
      final capture = await _client.capture.createCapture(request);

      // Add to the beginning of the list (already processed)
      state = state.copyWith(
        captures: [capture, ...state.captures],
        isLoading: false,
      );

      return capture;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }

  /// Create a capture from a file
  Future<Capture?> createCaptureFromFile(
    File file,
    String type, {
    String? sourceApp,
  }) async {
    final bytes = await file.readAsBytes();
    return createImageCapture(bytes, type, sourceApp: sourceApp);
  }

  /// Create a link capture
  /// The server processes AI synchronously, so the returned capture is complete
  Future<Capture?> createLinkCapture(String url) async {
    state = state.copyWith(isLoading: true);

    try {
      final request = CaptureRequest(
        type: 'link',
        url: url,
      );

      // Server waits for AI processing before returning
      final capture = await _client.capture.createCapture(request);

      state = state.copyWith(
        captures: [capture, ...state.captures],
        isLoading: false,
      );

      return capture;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }

  /// Delete a capture
  Future<bool> deleteCapture(int captureId) async {
    try {
      final success = await _client.capture.deleteCapture(captureId);
      if (success) {
        state = state.copyWith(
          captures: state.captures.where((c) => c.id != captureId).toList(),
        );
      }
      return success;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Update category filter
  void setCategory(String? category) {
    state = state.copyWith(selectedCategory: category);
    loadCaptures();
  }

  /// Update type filter
  void setType(String? type) {
    state = state.copyWith(selectedType: type);
    loadCaptures();
  }

  /// Clear filters
  void clearFilters() {
    state = const CapturesState();
    loadCaptures();
  }

  /// Get captures by date range
  Future<List<Capture>> getCapturesByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      return await _client.capture.getCapturesByDateRange(start, end);
    } catch (e) {
      return [];
    }
  }

  /// Get reminders
  Future<List<Capture>> getReminders() async {
    try {
      return await _client.capture.getReminders();
    } catch (e) {
      return [];
    }
  }
}

/// Provider for captures
final capturesProvider =
    StateNotifierProvider<CapturesNotifier, CapturesState>((ref) {
  final client = ref.watch(clientProvider);
  return CapturesNotifier(client);
});

/// Provider for a single capture
final captureProvider = FutureProvider.family<Capture?, int>((ref, id) async {
  final client = ref.watch(clientProvider);
  return client.capture.getCapture(id);
});

/// Provider for reminders
final remindersProvider = FutureProvider<List<Capture>>((ref) async {
  final client = ref.watch(clientProvider);
  return client.capture.getReminders();
});

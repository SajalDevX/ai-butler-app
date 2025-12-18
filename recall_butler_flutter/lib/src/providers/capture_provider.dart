import 'dart:async';
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

/// Counter for generating unique temporary IDs (negative to avoid conflicts with server IDs)
int _tempIdCounter = -1;

/// Notifier for captures state
class CapturesNotifier extends StateNotifier<CapturesState> {
  final Client _client;

  /// Active polling timers for captures that are still processing
  final Map<int, Timer> _pollingTimers = {};

  /// Polling interval in seconds
  static const int _pollingIntervalSeconds = 3;

  CapturesNotifier(this._client) : super(const CapturesState());

  @override
  void dispose() {
    // Cancel all polling timers when disposed
    for (final timer in _pollingTimers.values) {
      timer.cancel();
    }
    _pollingTimers.clear();
    super.dispose();
  }

  /// Start polling for a capture's processing status
  void _startPollingForCapture(int captureId) {
    // Don't start if already polling
    if (_pollingTimers.containsKey(captureId)) return;

    _pollingTimers[captureId] = Timer.periodic(
      Duration(seconds: _pollingIntervalSeconds),
      (_) => _pollCaptureStatus(captureId),
    );
  }

  /// Stop polling for a specific capture
  void _stopPollingForCapture(int captureId) {
    _pollingTimers[captureId]?.cancel();
    _pollingTimers.remove(captureId);
  }

  /// Poll the server for a capture's updated status
  Future<void> _pollCaptureStatus(int captureId) async {
    try {
      final updatedCapture = await _client.capture.getCapture(captureId);

      if (updatedCapture == null) {
        _stopPollingForCapture(captureId);
        return;
      }

      // Update the capture in state
      state = state.copyWith(
        captures: state.captures.map((c) {
          if (c.id == captureId) {
            return updatedCapture;
          }
          return c;
        }).toList(),
      );

      // Stop polling if processing is complete or failed
      if (updatedCapture.processingStatus == 'completed' ||
          updatedCapture.processingStatus == 'failed') {
        _stopPollingForCapture(captureId);
      }
    } catch (e) {
      // Log error but keep polling
      print('Error polling capture $captureId: $e');
    }
  }

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
  /// Uses optimistic UI: immediately shows the capture with 'processing' status,
  /// then updates with real data when the API returns
  Future<Capture?> createImageCapture(
    Uint8List bytes,
    String type, {
    String? sourceApp,
  }) async {
    // Generate a unique temporary ID
    final tempId = _tempIdCounter--;

    // Create a data URL for local preview
    final base64Data = base64Encode(bytes);
    final dataUrl = 'data:image/jpeg;base64,$base64Data';

    // Create optimistic capture with processing status
    final optimisticCapture = Capture(
      id: tempId,
      userId: 0, // Will be set by server
      type: type,
      thumbnailUrl: dataUrl, // Use data URL for local preview
      originalUrl: dataUrl,
      category: 'Other', // Default category until AI processes
      createdAt: DateTime.now(),
      isReminder: false,
      sourceApp: sourceApp,
      processingStatus: 'processing',
    );

    // Immediately add to state (optimistic update)
    state = state.copyWith(
      captures: [optimisticCapture, ...state.captures],
    );

    try {
      final request = CaptureRequest(
        type: type,
        fileData: base64Data,
        sourceApp: sourceApp,
      );

      // Make API call (runs while UI already shows the capture)
      final capture = await _client.capture.createCapture(request);

      // Replace optimistic capture with real data from server
      state = state.copyWith(
        captures: state.captures.map((c) {
          if (c.id == tempId) {
            return capture;
          }
          return c;
        }).toList(),
      );

      // Start polling if capture is still processing
      if (capture.id != null &&
          capture.processingStatus != 'completed' &&
          capture.processingStatus != 'failed') {
        _startPollingForCapture(capture.id!);
      }

      return capture;
    } catch (e) {
      // On error, mark the optimistic capture as failed
      state = state.copyWith(
        captures: state.captures.map((c) {
          if (c.id == tempId) {
            return c.copyWith(processingStatus: 'failed');
          }
          return c;
        }).toList(),
        error: e.toString(),
      );
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
  /// Uses optimistic UI: immediately shows the capture with 'processing' status,
  /// then updates with real data when the API returns
  Future<Capture?> createLinkCapture(String url) async {
    // Generate a unique temporary ID
    final tempId = _tempIdCounter--;

    // Create optimistic capture with processing status
    final optimisticCapture = Capture(
      id: tempId,
      userId: 0, // Will be set by server
      type: 'link',
      extractedText: url, // Show URL as extracted text until AI processes
      category: 'Other', // Default category until AI processes
      createdAt: DateTime.now(),
      isReminder: false,
      processingStatus: 'processing',
    );

    // Immediately add to state (optimistic update)
    state = state.copyWith(
      captures: [optimisticCapture, ...state.captures],
    );

    try {
      final request = CaptureRequest(
        type: 'link',
        url: url,
      );

      // Make API call (runs while UI already shows the capture)
      final capture = await _client.capture.createCapture(request);

      // Replace optimistic capture with real data from server
      state = state.copyWith(
        captures: state.captures.map((c) {
          if (c.id == tempId) {
            return capture;
          }
          return c;
        }).toList(),
      );

      // Start polling if capture is still processing
      if (capture.id != null &&
          capture.processingStatus != 'completed' &&
          capture.processingStatus != 'failed') {
        _startPollingForCapture(capture.id!);
      }

      return capture;
    } catch (e) {
      // On error, mark the optimistic capture as failed
      state = state.copyWith(
        captures: state.captures.map((c) {
          if (c.id == tempId) {
            return c.copyWith(processingStatus: 'failed');
          }
          return c;
        }).toList(),
        error: e.toString(),
      );
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

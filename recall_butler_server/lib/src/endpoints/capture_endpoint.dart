import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/gemini_service.dart';
import '../services/file_storage_service.dart';

class CaptureEndpoint extends Endpoint {
  /// Creates a new capture from uploaded content
  Future<Capture> createCapture(
    Session session,
    CaptureRequest request,
  ) async {
    final userId = await _getUserId(session);

    // Create initial capture record with pending status
    var capture = Capture(
      userId: userId,
      type: request.type,
      category: 'Other',
      createdAt: DateTime.now(),
      isReminder: false,
      sourceApp: request.sourceApp,
      processingStatus: 'pending',
    );

    // Insert the capture to get an ID
    capture = await Capture.db.insertRow(session, capture);

    // Process file upload if present
    if (request.fileData != null) {
      try {
        final bytes = base64Decode(request.fileData!);
        final urls = await FileStorageService.uploadCaptureFile(
          session,
          capture.id!,
          bytes,
          request.type,
        );
        capture.originalUrl = urls['original'];
        capture.thumbnailUrl = urls['thumbnail'];
      } catch (e) {
        session.log('Error uploading file: $e', level: LogLevel.error);
      }
    }

    // Store URL for link captures
    if (request.type == 'link' && request.url != null) {
      capture.originalUrl = request.url;
    }

    // Update capture with file URLs and set processing status
    capture.processingStatus = 'processing';
    capture = await Capture.db.updateRow(session, capture);

    // Process with AI asynchronously (don't wait - return immediately)
    // ignore: unawaited_futures
    _processWithAIAsync(session, capture);

    return capture;
  }

  /// Process capture with Gemini AI asynchronously (fire and forget)
  Future<void> _processWithAIAsync(Session session, Capture capture) async {
    // Create a new session for background processing
    final bgSession = await session.serverpod.createSession(enableLogging: true);

    try {
      final result = await GeminiService.processCapture(bgSession, capture);

      capture.extractedText = result.extractedText;
      capture.aiSummary = result.description;
      capture.tags = jsonEncode(result.tags);
      capture.category = result.category;
      capture.isReminder = result.isReminder;
      capture.processingStatus = 'completed';

      capture = await Capture.db.updateRow(bgSession, capture);
      bgSession.log('AI processing completed for capture ${capture.id}');

      // Auto-extract and create actions from the capture
      await _extractAndCreateActions(bgSession, capture);
    } catch (e, stackTrace) {
      bgSession.log('AI processing failed: $e\n$stackTrace', level: LogLevel.error);

      // Update status to failed
      capture.processingStatus = 'failed';
      await Capture.db.updateRow(bgSession, capture);
    } finally {
      await bgSession.close();
    }
  }

  /// Extract actions from capture and create them automatically
  Future<void> _extractAndCreateActions(Session session, Capture capture) async {
    try {
      final actionItems = await GeminiService.extractActions(session, capture);

      if (actionItems.isEmpty) {
        session.log('No actions extracted from capture ${capture.id}');
        return;
      }

      final userId = await _getUserId(session);

      for (final item in actionItems) {
        final action = Action(
          userId: userId,
          captureId: capture.id,
          type: item['type'] ?? 'task',
          title: item['title'] ?? '',
          notes: item['notes'],
          dueAt: item['dueAt'] != null ? DateTime.tryParse(item['dueAt']) : null,
          isCompleted: false,
          priority: item['priority'] ?? 'medium',
          createdAt: DateTime.now(),
        );

        if (action.title.isNotEmpty) {
          await Action.db.insertRow(session, action);
          session.log('Created action: ${action.title} from capture ${capture.id}');
        }
      }
    } catch (e) {
      session.log('Failed to extract actions: $e', level: LogLevel.warning);
    }
  }

  /// Get all captures for the current user
  Future<List<Capture>> getCaptures(
    Session session, {
    int? limit,
    int? offset,
    String? category,
    String? type,
  }) async {
    final userId = await _getUserId(session);

    var whereClause = Capture.t.userId.equals(userId);

    if (category != null) {
      whereClause = whereClause & Capture.t.category.equals(category);
    }
    if (type != null) {
      whereClause = whereClause & Capture.t.type.equals(type);
    }

    return await Capture.db.find(
      session,
      where: (t) => whereClause,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: limit ?? 50,
      offset: offset ?? 0,
    );
  }

  /// Get a single capture by ID
  Future<Capture?> getCapture(Session session, int captureId) async {
    final userId = await _getUserId(session);

    return await Capture.db.findFirstRow(
      session,
      where: (t) => t.id.equals(captureId) & t.userId.equals(userId),
    );
  }

  /// Delete a capture
  Future<bool> deleteCapture(Session session, int captureId) async {
    final userId = await _getUserId(session);

    final capture = await Capture.db.findFirstRow(
      session,
      where: (t) => t.id.equals(captureId) & t.userId.equals(userId),
    );

    if (capture == null) {
      return false;
    }

    // Delete associated files
    if (capture.originalUrl != null) {
      await FileStorageService.deleteFile(session, capture.originalUrl!);
    }
    if (capture.thumbnailUrl != null) {
      await FileStorageService.deleteFile(session, capture.thumbnailUrl!);
    }

    // Delete from collections
    await CaptureCollection.db.deleteWhere(
      session,
      where: (t) => t.captureId.equals(captureId),
    );

    // Delete capture
    await Capture.db.deleteRow(session, capture);

    return true;
  }

  /// Get captures by date range (for timeline view)
  Future<List<Capture>> getCapturesByDateRange(
    Session session,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final userId = await _getUserId(session);

    return await Capture.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.createdAt.between(startDate, endDate),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Update capture category
  Future<Capture?> updateCategory(
    Session session,
    int captureId,
    String category,
  ) async {
    final capture = await getCapture(session, captureId);
    if (capture == null) return null;

    capture.category = category;
    return await Capture.db.updateRow(session, capture);
  }

  /// Get captures marked as reminders
  Future<List<Capture>> getReminders(Session session) async {
    final userId = await _getUserId(session);

    return await Capture.db.find(
      session,
      where: (t) => t.userId.equals(userId) & t.isReminder.equals(true),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Helper to get user ID from session
  /// For demo purposes, returns a default user ID if not authenticated
  Future<int> _getUserId(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      // Default user ID for demo/development
      return 1;
    }
    return authInfo.userId;
  }
}

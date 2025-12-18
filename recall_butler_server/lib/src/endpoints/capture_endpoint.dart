import 'dart:convert';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/gemini_service.dart';
import '../services/file_storage_service.dart';

class CaptureEndpoint extends Endpoint {
  /// Creates a new capture from uploaded content
  /// Uses two-phase processing:
  /// - Phase 1 (Sync): Quick AI analysis, returns in <2 seconds
  /// - Phase 2 (Async): Deep analysis runs in background
  Future<Capture> createCapture(
    Session session,
    CaptureRequest request,
  ) async {
    final userId = await _getUserId(session);
    final stopwatch = Stopwatch()..start();

    // ═══════════════════════════════════════════════════════════════
    // PHASE 1: SYNC (Fast Path - Target: <2 seconds)
    // ═══════════════════════════════════════════════════════════════

    // Create initial capture record
    var capture = Capture(
      userId: userId,
      type: request.type,
      category: 'Other',
      createdAt: DateTime.now(),
      isReminder: false,
      sourceApp: request.sourceApp,
      processingStatus: 'analyzing',
      processingProgress: 10,
    );

    // Insert to get an ID
    capture = await Capture.db.insertRow(session, capture);
    session.log('Capture created in ${stopwatch.elapsedMilliseconds}ms');

    // Store bytes for AI analysis
    Uint8List? thumbnailBytes;
    Uint8List? originalBytes;

    // Process file upload if present
    if (request.fileData != null) {
      try {
        originalBytes = base64Decode(request.fileData!);
        final urls = await FileStorageService.uploadCaptureFile(
          session,
          capture.id!,
          originalBytes,
          request.type,
        );
        capture.originalUrl = urls['original'];
        capture.thumbnailUrl = urls['thumbnail'];
        thumbnailBytes = FileStorageService.lastThumbnailBytes;

        session.log('File uploaded in ${stopwatch.elapsedMilliseconds}ms');
      } catch (e) {
        session.log('Error uploading file: $e', level: LogLevel.error);
      }
    }

    // Store URL for link captures
    if (request.type == 'link' && request.url != null) {
      capture.originalUrl = request.url;
    }

    // Quick AI analysis (fast, simple prompt)
    if (thumbnailBytes != null && (request.type == 'screenshot' || request.type == 'photo')) {
      try {
        final quickResult = await GeminiService.quickAnalysis(
          session,
          request.type,
          thumbnailBytes,
        );
        capture.quickDescription = quickResult.description;
        capture.quickType = quickResult.detectedType;
        session.log('Quick analysis in ${stopwatch.elapsedMilliseconds}ms');
      } catch (e) {
        session.log('Quick analysis failed: $e', level: LogLevel.warning);
        capture.quickDescription = 'Image captured - processing...';
        capture.quickType = 'other';
      }
    } else {
      capture.quickDescription = 'Content captured - processing...';
      capture.quickType = request.type;
    }

    // Update capture with quick analysis and set status to processing
    capture.processingStatus = 'processing';
    capture.processingProgress = 20;
    capture = await Capture.db.updateRow(session, capture);

    session.log('Phase 1 complete in ${stopwatch.elapsedMilliseconds}ms - returning to client');

    // ═══════════════════════════════════════════════════════════════
    // PHASE 2: ASYNC (Background - Schedule for later)
    // ═══════════════════════════════════════════════════════════════

    // Schedule background processing via Future Call (non-blocking)
    // Use original bytes for better OCR quality in deep analysis
    // ignore: unawaited_futures
    _scheduleDeepProcessing(session, capture.id!, originalBytes);

    // Return immediately with quick analysis results
    return capture;
  }

  /// Schedule deep AI processing in background
  Future<void> _scheduleDeepProcessing(
    Session session,
    int captureId,
    Uint8List? imageBytes,
  ) async {
    // Run deep processing in a separate session (fire and forget)
    final bgSession = await session.serverpod.createSession(enableLogging: true);

    try {
      final capture = await Capture.db.findById(bgSession, captureId);
      if (capture == null) return;

      bgSession.log('Starting deep processing for capture $captureId');

      // Deep AI analysis
      final result = await GeminiService.processCapture(
        bgSession,
        capture,
        imageBytes: imageBytes,
      );

      // Update capture with full analysis
      capture.extractedText = result.extractedText;
      capture.aiSummary = result.description;
      capture.tags = jsonEncode(result.tags);
      capture.category = result.category;
      capture.isReminder = result.isReminder;
      capture.processingStatus = 'completed';
      capture.processingProgress = 100;
      capture.processedAt = DateTime.now();

      await Capture.db.updateRow(bgSession, capture);
      bgSession.log('Deep processing completed for capture $captureId');

      // Create actions from structured actions
      List<Map<String, dynamic>>? structuredActions;
      if (result.structuredActionsJson != null) {
        try {
          final decoded = jsonDecode(result.structuredActionsJson!);
          if (decoded is List) {
            structuredActions = decoded.cast<Map<String, dynamic>>();
          }
        } catch (e) {
          bgSession.log('Failed to parse structuredActionsJson: $e');
        }
      }
      await _createActionsFromResult(bgSession, capture, structuredActions);
    } catch (e, stackTrace) {
      bgSession.log('Deep processing failed: $e\n$stackTrace', level: LogLevel.error);

      // Mark as failed
      final capture = await Capture.db.findById(bgSession, captureId);
      if (capture != null) {
        capture.processingStatus = 'failed';
        capture.errorMessage = e.toString();
        await Capture.db.updateRow(bgSession, capture);
      }
    } finally {
      await bgSession.close();
    }
  }

  /// Process capture with Gemini AI synchronously - waits for completion
  /// Returns the updated capture with AI data
  Future<Capture> _processWithAI(
    Session session,
    Capture capture,
    Uint8List? imageBytes,
  ) async {
    try {
      // Pass imageBytes directly - no need to re-fetch from storage
      final result = await GeminiService.processCapture(
        session,
        capture,
        imageBytes: imageBytes,
      );

      capture.extractedText = result.extractedText;
      capture.aiSummary = result.description;
      capture.tags = jsonEncode(result.tags);
      capture.category = result.category;
      capture.isReminder = result.isReminder;
      capture.processingStatus = 'completed';

      capture = await Capture.db.updateRow(session, capture);
      session.log('AI processing completed for capture ${capture.id}');

      // Create actions directly from structuredActions (already extracted by AI)
      List<Map<String, dynamic>>? structuredActions;
      if (result.structuredActionsJson != null) {
        try {
          final decoded = jsonDecode(result.structuredActionsJson!);
          if (decoded is List) {
            structuredActions = decoded.cast<Map<String, dynamic>>();
          }
        } catch (e) {
          session.log('Failed to parse structuredActionsJson: $e');
        }
      }
      await _createActionsFromResult(session, capture, structuredActions);

      return capture;
    } catch (e, stackTrace) {
      session.log('AI processing failed: $e\n$stackTrace', level: LogLevel.error);

      // Update status to failed
      capture.processingStatus = 'failed';
      capture = await Capture.db.updateRow(session, capture);
      return capture;
    }
  }

  /// Process capture with Gemini AI asynchronously (fire and forget) - kept for reference
  /// Takes optional imageBytes to avoid re-fetching from storage
  Future<void> _processWithAIAsync(
    Session session,
    Capture capture,
    Uint8List? imageBytes,
  ) async {
    // Create a new session for background processing
    final bgSession = await session.serverpod.createSession(enableLogging: true);

    try {
      // Pass imageBytes directly - no need to re-fetch from storage
      final result = await GeminiService.processCapture(
        bgSession,
        capture,
        imageBytes: imageBytes,
      );

      capture.extractedText = result.extractedText;
      capture.aiSummary = result.description;
      capture.tags = jsonEncode(result.tags);
      capture.category = result.category;
      capture.isReminder = result.isReminder;
      capture.processingStatus = 'completed';

      capture = await Capture.db.updateRow(bgSession, capture);
      bgSession.log('AI processing completed for capture ${capture.id}');

      // Create actions directly from structuredActions (already extracted by AI)
      // No need for separate AI call - saves ~10+ seconds
      List<Map<String, dynamic>>? structuredActions;
      if (result.structuredActionsJson != null) {
        try {
          final decoded = jsonDecode(result.structuredActionsJson!);
          if (decoded is List) {
            structuredActions = decoded.cast<Map<String, dynamic>>();
          }
        } catch (e) {
          bgSession.log('Failed to parse structuredActionsJson: $e');
        }
      }
      await _createActionsFromResult(bgSession, capture, structuredActions);
    } catch (e, stackTrace) {
      bgSession.log('AI processing failed: $e\n$stackTrace', level: LogLevel.error);

      // Update status to failed
      capture.processingStatus = 'failed';
      await Capture.db.updateRow(bgSession, capture);
    } finally {
      await bgSession.close();
    }
  }

  /// Create actions directly from AI result (no separate API call needed)
  /// Calculates smart reminder times based on AI suggestions
  Future<void> _createActionsFromResult(
    Session session,
    Capture capture,
    List<Map<String, dynamic>>? structuredActions,
  ) async {
    if (structuredActions == null || structuredActions.isEmpty) {
      session.log('No actions extracted from capture ${capture.id}');
      return;
    }

    try {
      final userId = capture.userId;

      for (final item in structuredActions) {
        final title = item['title']?.toString();
        if (title == null || title.isEmpty) continue;

        final dueAtStr = item['dueAt']?.toString();
        final dueAt = dueAtStr != null ? DateTime.tryParse(dueAtStr) : null;

        // Calculate reminder date based on AI suggestion or default rules
        DateTime? reminderAt;
        if (dueAt != null) {
          final reminderDaysBefore = item['reminderDaysBefore'];
          int daysBefore = 0;

          if (reminderDaysBefore != null) {
            // Use AI-suggested reminder timing
            daysBefore = reminderDaysBefore is int
                ? reminderDaysBefore
                : int.tryParse(reminderDaysBefore.toString()) ?? 0;
          } else {
            // Default reminder timing based on type
            final type = item['type']?.toString() ?? 'task';
            daysBefore = _getDefaultReminderDays(type);
          }

          reminderAt = dueAt.subtract(Duration(days: daysBefore));

          // Don't set reminder in the past
          if (reminderAt.isBefore(DateTime.now())) {
            reminderAt = DateTime.now();
          }
        }

        final priority = item['priority']?.toString() ?? 'medium';
        final type = item['type']?.toString() ?? 'task';

        final action = Action(
          userId: userId,
          captureId: capture.id,
          type: type,
          title: title,
          notes: item['notes']?.toString(),
          dueAt: dueAt,
          reminderAt: reminderAt,
          isCompleted: false,
          priority: priority,
          createdAt: DateTime.now(),
        );

        await Action.db.insertRow(session, action);
        session.log(
          'Created action: ${action.title} [${action.type}] priority=$priority '
          'due=${dueAt?.toIso8601String()} remind=${reminderAt?.toIso8601String()}',
        );
      }
    } catch (e) {
      session.log('Failed to create actions: $e', level: LogLevel.warning);
    }
  }

  /// Get default reminder days before event based on type
  int _getDefaultReminderDays(String type) {
    switch (type.toLowerCase()) {
      case 'birthday':
        return 1; // Remind 1 day before to arrange gift/wish
      case 'anniversary':
        return 3; // Remind 3 days before to plan
      case 'deadline':
        return 2; // Remind 2 days before to prepare
      case 'appointment':
        return 1; // Remind 1 day before
      case 'event':
      case 'task':
      case 'reminder':
      default:
        return 0; // Remind on the day
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

import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/gmail_service.dart';
import '../services/calendar_service.dart';
import '../services/email_ai_service.dart';

/// Endpoint for Google integration features (Gmail, Calendar)
class IntegrationEndpoint extends Endpoint {
  // ═══════════════════════════════════════════════════════════════
  // EMAIL OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Get emails with optional filters
  Future<List<EmailSummary>> getEmails(
    Session session, {
    int? limit,
    int? offset,
    String? category,
    int? minImportance,
    bool? requiresAction,
    bool? unreadOnly,
  }) async {
    final userId = await _getUserId(session);

    var whereClause = EmailSummary.t.userId.equals(userId);

    if (category != null) {
      whereClause = whereClause & EmailSummary.t.category.equals(category);
    }
    if (minImportance != null) {
      whereClause = whereClause &
          EmailSummary.t.importanceScore.between(minImportance, 10);
    }
    if (requiresAction == true) {
      whereClause =
          whereClause & EmailSummary.t.requiresAction.equals(true);
    }
    if (unreadOnly == true) {
      whereClause = whereClause & EmailSummary.t.isRead.equals(false);
    }

    return await EmailSummary.db.find(
      session,
      where: (t) => whereClause,
      orderBy: (t) => t.receivedAt,
      orderDescending: true,
      limit: limit ?? 50,
      offset: offset ?? 0,
    );
  }

  /// Get a single email by ID
  Future<EmailSummary?> getEmail(Session session, int emailId) async {
    final userId = await _getUserId(session);

    return await EmailSummary.db.findFirstRow(
      session,
      where: (t) => t.id.equals(emailId) & t.userId.equals(userId),
    );
  }

  /// Get important emails (importance >= 7)
  Future<List<EmailSummary>> getImportantEmails(
    Session session, {
    int? limit,
  }) async {
    final userId = await _getUserId(session);
    return await GmailService.getImportantEmails(
      session,
      userId,
      limit: limit ?? 20,
    );
  }

  /// Get emails requiring action
  Future<List<EmailSummary>> getActionableEmails(
    Session session, {
    int? limit,
  }) async {
    final userId = await _getUserId(session);
    return await GmailService.getActionableEmails(
      session,
      userId,
      limit: limit ?? 20,
    );
  }

  /// Generate AI draft reply for an email
  Future<EmailDraftResult> generateDraft(
    Session session,
    int emailId, {
    String tone = 'professional',
    String? additionalContext,
  }) async {
    final draft = await EmailAIService.generateDraftReply(
      session,
      emailId,
      tone: tone,
      additionalContext: additionalContext,
    );

    if (draft == null) {
      return EmailDraftResult(
        success: false,
        error: 'Failed to generate draft',
      );
    }

    return EmailDraftResult(
      success: true,
      draftReply: draft,
      tone: tone,
    );
  }

  /// Generate email draft with different tones by gmailId
  Future<EmailDraftResult> generateEmailDraft(
    Session session,
    String gmailId,
    String tone,
  ) async {
    try {
      final userId = await _getUserId(session);

      // Fetch the EmailSummary by gmailId
      final email = await EmailSummary.db.findFirstRow(
        session,
        where: (t) => t.gmailId.equals(gmailId) & t.userId.equals(userId),
      );

      if (email == null) {
        return EmailDraftResult(
          success: false,
          error: 'Email not found with gmailId: $gmailId',
        );
      }

      // Validate tone
      const validTones = ['professional', 'casual', 'formal', 'friendly'];
      if (!validTones.contains(tone.toLowerCase())) {
        return EmailDraftResult(
          success: false,
          error: 'Invalid tone. Must be one of: ${validTones.join(', ')}',
        );
      }

      // Generate draft reply using EmailAIService
      final draft = await EmailAIService.generateDraftReply(
        session,
        email.id!,
        tone: tone,
      );

      if (draft == null) {
        return EmailDraftResult(
          success: false,
          error: 'Failed to generate draft reply',
        );
      }

      return EmailDraftResult(
        success: true,
        draftReply: draft,
        tone: tone,
      );
    } catch (e) {
      return EmailDraftResult(
        success: false,
        error: 'Error generating draft: ${e.toString()}',
      );
    }
  }

  /// Create a Gmail draft from generated text
  Future<bool> createGmailDraft(
    Session session,
    int emailId,
    String replyText,
  ) async {
    final userId = await _getUserId(session);
    final email = await EmailSummary.db.findById(session, emailId);

    if (email == null || email.userId != userId) {
      return false;
    }

    final draftId = await GmailService.createDraft(
      session,
      userId,
      email.threadId,
      email.gmailId,
      replyText,
    );

    return draftId != null;
  }

  /// Send email reply via Gmail API
  Future<EmailSendResult> sendEmailReply(
    Session session,
    String gmailId,
    String replyText,
  ) async {
    final userId = await _getUserId(session);

    // Fetch the EmailSummary by gmailId
    final email = await EmailSummary.db.findFirstRow(
      session,
      where: (t) => t.gmailId.equals(gmailId) & t.userId.equals(userId),
    );

    if (email == null) {
      return EmailSendResult(
        success: false,
        error: 'Email not found or access denied',
      );
    }

    // Get user's GoogleToken to verify Gmail access
    final googleToken = await GoogleToken.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );

    if (googleToken == null || !googleToken.gmailEnabled) {
      return EmailSendResult(
        success: false,
        error: 'Gmail not enabled for this user',
      );
    }

    // Use GmailService to send the reply
    final sentMessageId = await GmailService.sendReply(
      session,
      userId,
      gmailId,
      replyText,
    );

    if (sentMessageId == null) {
      return EmailSendResult(
        success: false,
        error: 'Failed to send email reply',
      );
    }

    // Mark the email as replied/archived in the database
    email.isArchived = true;
    email.updatedAt = DateTime.now();
    await EmailSummary.db.updateRow(session, email);

    return EmailSendResult(
      success: true,
      messageId: sentMessageId,
    );
  }

  /// Trigger manual email sync
  Future<SyncResult> syncEmails(Session session, {bool fullSync = false}) async {
    final userId = await _getUserId(session);
    final result = await GmailService.syncEmails(
      session,
      userId,
      fullSync: fullSync,
    );

    return SyncResult(
      success: result.success,
      error: result.error,
      newCount: result.newEmailCount,
      updatedCount: result.updatedEmailCount,
    );
  }

  /// Get daily email digest
  Future<String?> getDailyDigest(Session session) async {
    final userId = await _getUserId(session);
    return await EmailAIService.generateDailyDigest(session, userId);
  }

  // ═══════════════════════════════════════════════════════════════
  // CALENDAR OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Get upcoming calendar events
  Future<List<CalendarEventCache>> getUpcomingEvents(
    Session session, {
    int hoursAhead = 24,
    int? limit,
  }) async {
    final userId = await _getUserId(session);
    return await CalendarService.getUpcomingEvents(
      session,
      userId,
      hoursAhead: hoursAhead,
      limit: limit ?? 10,
    );
  }

  /// Get today's calendar events
  Future<List<CalendarEventCache>> getTodayEvents(Session session) async {
    final userId = await _getUserId(session);
    return await CalendarService.getTodayEvents(session, userId);
  }

  /// Get events for a date range
  Future<List<CalendarEventCache>> getEventsByRange(
    Session session,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final userId = await _getUserId(session);
    return await CalendarService.getEventsByRange(
      session,
      userId,
      startDate,
      endDate,
    );
  }

  /// Get a single event by ID
  Future<CalendarEventCache?> getEvent(Session session, int eventId) async {
    final userId = await _getUserId(session);

    return await CalendarEventCache.db.findFirstRow(
      session,
      where: (t) => t.id.equals(eventId) & t.userId.equals(userId),
    );
  }

  /// Generate meeting preparation brief
  Future<MeetingPrepResult> generateMeetingPrep(
    Session session,
    int eventId,
  ) async {
    final userId = await _getUserId(session);
    final event = await CalendarEventCache.db.findById(session, eventId);

    if (event == null || event.userId != userId) {
      return MeetingPrepResult(
        success: false,
        error: 'Event not found',
      );
    }

    // Check if already has context
    if (event.contextBrief != null) {
      return MeetingPrepResult(
        success: true,
        contextBrief: event.contextBrief,
        relatedEmailCount: event.relatedEmailIds != null
            ? (jsonDecode(event.relatedEmailIds!) as List).length
            : 0,
      );
    }

    final context = await EmailAIService.generateMeetingContext(
      session,
      eventId,
      userId,
    );

    if (context == null) {
      return MeetingPrepResult(
        success: false,
        error: 'Failed to generate meeting context',
      );
    }

    // Reload event to get related emails
    final updatedEvent = await CalendarEventCache.db.findById(session, eventId);

    return MeetingPrepResult(
      success: true,
      contextBrief: context,
      relatedEmailCount: updatedEvent?.relatedEmailIds != null
          ? (jsonDecode(updatedEvent!.relatedEmailIds!) as List).length
          : 0,
    );
  }

  /// Trigger manual calendar sync
  Future<SyncResult> syncCalendar(Session session, {int daysAhead = 30}) async {
    final userId = await _getUserId(session);
    final result = await CalendarService.syncEvents(
      session,
      userId,
      daysAhead: daysAhead,
    );

    return SyncResult(
      success: result.success,
      error: result.error,
      newCount: result.newEventCount,
      updatedCount: result.updatedEventCount,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // COMBINED/DASHBOARD OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Get integrated dashboard data
  Future<IntegrationDashboard> getDashboard(Session session) async {
    final userId = await _getUserId(session);

    // Get unread email count
    final unreadCount = await EmailSummary.db.count(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.isRead.equals(false) &
          t.isArchived.equals(false),
    );

    // Get actionable email count
    final actionableCount = await EmailSummary.db.count(
      session,
      where: (t) =>
          t.userId.equals(userId) & t.requiresAction.equals(true),
    );

    // Get important unread emails
    final importantEmails = await EmailSummary.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.isRead.equals(false) &
          t.importanceScore.between(7, 10),
      orderBy: (t) => t.importanceScore,
      orderDescending: true,
      limit: 5,
    );

    // Get today's events
    final todayEvents = await CalendarService.getTodayEvents(session, userId);

    // Get next upcoming meeting (with attendees)
    final upcomingMeetings = await CalendarService.getUpcomingEvents(
      session,
      userId,
      hoursAhead: 8,
      limit: 3,
    );

    // Get Google auth status
    final googleToken = await GoogleToken.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );

    return IntegrationDashboard(
      unreadEmailCount: unreadCount,
      actionableEmailCount: actionableCount,
      importantEmails: importantEmails,
      todayEvents: todayEvents,
      upcomingMeetings: upcomingMeetings,
      gmailEnabled: googleToken?.gmailEnabled ?? false,
      calendarEnabled: googleToken?.calendarEnabled ?? false,
      lastGmailSync: googleToken?.lastGmailSync,
      lastCalendarSync: googleToken?.lastCalendarSync,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // EMAIL SEND/SCHEDULE OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Schedule email reply to be sent at a specific time
  Future<EmailSendResult> scheduleEmailReply(
    Session session,
    String gmailId,
    String replyText,
    DateTime scheduledTime,
  ) async {
    final userId = await _getUserId(session);

    // Validate that scheduled time is in the future
    if (scheduledTime.isBefore(DateTime.now())) {
      return EmailSendResult(
        success: false,
        error: 'Scheduled time must be in the future',
      );
    }

    // Validate inputs
    if (replyText.trim().isEmpty) {
      return EmailSendResult(
        success: false,
        error: 'Reply text cannot be empty',
      );
    }

    // Verify the email exists and belongs to this user
    final email = await EmailSummary.db.findFirstRow(
      session,
      where: (t) => t.gmailId.equals(gmailId) & t.userId.equals(userId),
    );

    if (email == null) {
      return EmailSendResult(
        success: false,
        error: 'Email not found',
      );
    }

    try {
      // Create task data for the scheduled email
      final task = ScheduledEmailTask(
        userId: userId,
        gmailId: gmailId,
        replyText: replyText,
        scheduledTime: scheduledTime,
      );

      // Calculate delay until scheduled time
      final delay = scheduledTime.difference(DateTime.now());

      // Schedule the future call
      await session.serverpod.futureCallWithDelay(
        'scheduledEmail',
        task,
        delay,
      );

      session.log(
        'Email scheduled for user $userId at $scheduledTime (in ${delay.inMinutes} minutes)',
      );

      return EmailSendResult(
        success: true,
        scheduledTime: scheduledTime,
      );
    } catch (e, stackTrace) {
      session.log(
        'Failed to schedule email: $e\n$stackTrace',
        level: LogLevel.error,
      );
      return EmailSendResult(
        success: false,
        error: 'Failed to schedule email: $e',
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════

  /// Helper to get user ID from session
  Future<int> _getUserId(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      return 1; // Default user for demo
    }
    return authInfo.userId;
  }
}

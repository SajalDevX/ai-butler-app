import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/gmail_service.dart';
import '../services/calendar_service.dart';
import '../services/email_ai_service.dart';

/// Background worker for syncing Gmail and Calendar
/// Runs periodically to keep data fresh
class GoogleSyncFutureCall extends FutureCall<SyncTask> {
  static const String callName = 'googleSync';
  static const Duration syncInterval = Duration(seconds: 30); // TODO: Change back to 15 minutes for production
  static const Duration aiProcessInterval = Duration(seconds: 30); // TODO: Change back to 5 minutes for production

  @override
  Future<void> invoke(Session session, SyncTask? object) async {
    session.log('Starting Google sync job');

    try {
      // Get all users with Google integration enabled
      final tokens = await GoogleToken.db.find(
        session,
        where: (t) => t.gmailEnabled.equals(true) | t.calendarEnabled.equals(true),
      );

      session.log('Found ${tokens.length} users with Google integration');

      for (final token in tokens) {
        await _syncUserData(session, token);
      }

      // Schedule next run
      await session.serverpod.futureCallWithDelay(
        callName,
        SyncTask(taskType: 'googleSync'),
        syncInterval,
      );

      session.log('Google sync job completed, next run in ${syncInterval.inMinutes} minutes');
    } catch (e, stackTrace) {
      session.log('Google sync job failed: $e\n$stackTrace', level: LogLevel.error);

      // Reschedule even on failure
      await session.serverpod.futureCallWithDelay(
        callName,
        SyncTask(taskType: 'googleSync'),
        syncInterval,
      );
    }
  }

  /// Sync data for a single user
  Future<void> _syncUserData(Session session, GoogleToken token) async {
    final userId = token.userId;

    try {
      // Sync Gmail if enabled
      if (token.gmailEnabled) {
        session.log('Syncing Gmail for user $userId');

        final gmailResult = await GmailService.syncEmails(session, userId);

        if (gmailResult.success) {
          session.log(
            'Gmail sync for user $userId: ${gmailResult.newEmailCount} new, '
            '${gmailResult.updatedEmailCount} updated',
          );

          // Process new emails with AI
          if (gmailResult.newEmailCount > 0) {
            final processed = await EmailAIService.analyzeUnprocessedEmails(
              session,
              userId,
              batchSize: 10,
            );
            session.log('AI analyzed $processed emails for user $userId');
          }
        } else {
          session.log(
            'Gmail sync failed for user $userId: ${gmailResult.error}',
            level: LogLevel.warning,
          );
        }
      }

      // Sync Calendar if enabled
      if (token.calendarEnabled) {
        session.log('Syncing Calendar for user $userId');

        final calResult = await CalendarService.syncEvents(session, userId);

        if (calResult.success) {
          session.log(
            'Calendar sync for user $userId: ${calResult.newEventCount} new, '
            '${calResult.updatedEventCount} updated',
          );

          // Generate context for upcoming meetings
          final upcomingMeetings = await CalendarService.getEventsPendingPrep(
            session,
            userId,
            hoursAhead: 4,
          );

          for (final meeting in upcomingMeetings.take(3)) {
            await EmailAIService.generateMeetingContext(
              session,
              meeting.id!,
              userId,
            );
            session.log('Generated context for meeting: ${meeting.title}');
          }
        } else {
          session.log(
            'Calendar sync failed for user $userId: ${calResult.error}',
            level: LogLevel.warning,
          );
        }
      }
    } catch (e) {
      session.log('Error syncing data for user $userId: $e', level: LogLevel.error);
    }
  }
}

/// Future call for processing AI analysis on emails
class EmailAIProcessFutureCall extends FutureCall<SyncTask> {
  static const String callName = 'emailAIProcess';
  static const Duration processInterval = Duration(seconds: 30); // TODO: Change back to 5 minutes for production

  @override
  Future<void> invoke(Session session, SyncTask? object) async {
    session.log('Starting email AI processing job');

    try {
      // Get all users with Gmail enabled
      final tokens = await GoogleToken.db.find(
        session,
        where: (t) => t.gmailEnabled.equals(true),
      );

      for (final token in tokens) {
        final processed = await EmailAIService.analyzeUnprocessedEmails(
          session,
          token.userId,
          batchSize: 5,
        );

        if (processed > 0) {
          session.log('Processed $processed emails for user ${token.userId}');
        }
      }

      // Schedule next run
      await session.serverpod.futureCallWithDelay(
        callName,
        SyncTask(taskType: 'emailAIProcess'),
        processInterval,
      );
    } catch (e, stackTrace) {
      session.log('Email AI processing failed: $e\n$stackTrace', level: LogLevel.error);

      // Reschedule on failure
      await session.serverpod.futureCallWithDelay(
        callName,
        SyncTask(taskType: 'emailAIProcess'),
        processInterval,
      );
    }
  }
}

/// Future call for generating meeting prep briefs
class MeetingPrepFutureCall extends FutureCall<SyncTask> {
  static const String callName = 'meetingPrep';
  static const Duration checkInterval = Duration(hours: 1);

  @override
  Future<void> invoke(Session session, SyncTask? object) async {
    session.log('Starting meeting prep job');

    try {
      // Get all users with Calendar enabled
      final tokens = await GoogleToken.db.find(
        session,
        where: (t) => t.calendarEnabled.equals(true),
      );

      for (final token in tokens) {
        // Get meetings in next 4 hours without context
        final meetings = await CalendarService.getEventsPendingPrep(
          session,
          token.userId,
          hoursAhead: 4,
        );

        for (final meeting in meetings.take(3)) {
          await EmailAIService.generateMeetingContext(
            session,
            meeting.id!,
            token.userId,
          );
          session.log('Generated prep for: ${meeting.title}');
        }
      }

      // Schedule next run
      await session.serverpod.futureCallWithDelay(
        callName,
        SyncTask(taskType: 'meetingPrep'),
        checkInterval,
      );
    } catch (e, stackTrace) {
      session.log('Meeting prep job failed: $e\n$stackTrace', level: LogLevel.error);

      // Reschedule on failure
      await session.serverpod.futureCallWithDelay(
        callName,
        SyncTask(taskType: 'meetingPrep'),
        checkInterval,
      );
    }
  }
}

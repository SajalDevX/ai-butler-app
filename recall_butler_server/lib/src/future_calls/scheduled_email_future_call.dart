import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/gmail_service.dart';

/// Future call for sending scheduled email replies
/// This is invoked when a scheduled email's time arrives
class ScheduledEmailFutureCall extends FutureCall<ScheduledEmailTask> {
  static const String callName = 'scheduledEmail';

  @override
  Future<void> invoke(Session session, ScheduledEmailTask? task) async {
    if (task == null) {
      session.log('ScheduledEmailFutureCall: No task data provided', level: LogLevel.error);
      return;
    }

    session.log('Sending scheduled email for user ${task.userId}, gmailId: ${task.gmailId}');

    try {
      // Validate that the scheduled time has arrived
      final now = DateTime.now();
      if (task.scheduledTime.isAfter(now)) {
        session.log(
          'Scheduled time not yet reached: ${task.scheduledTime} > $now',
          level: LogLevel.warning,
        );
        // Reschedule for the correct time
        final delay = task.scheduledTime.difference(now);
        await session.serverpod.futureCallWithDelay(
          callName,
          task,
          delay,
        );
        return;
      }

      // Send the email using GmailService
      final messageId = await GmailService.sendReply(
        session,
        task.userId,
        task.gmailId,
        task.replyText,
      );

      if (messageId != null) {
        session.log('Scheduled email sent successfully: $messageId');
      } else {
        session.log('Failed to send scheduled email', level: LogLevel.error);
        // TODO: Could implement retry logic here
        // For now, we'll just log the failure
      }
    } catch (e, stackTrace) {
      session.log(
        'Error sending scheduled email: $e\n$stackTrace',
        level: LogLevel.error,
      );
      // TODO: Could implement retry logic or user notification here
    }
  }
}

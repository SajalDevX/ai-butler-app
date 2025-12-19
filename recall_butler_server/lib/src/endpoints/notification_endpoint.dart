import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/push_notification_service.dart';

/// Endpoint for managing push notifications and device tokens
class NotificationEndpoint extends Endpoint {
  /// Register a device token for push notifications
  Future<bool> registerDeviceToken(
    Session session,
    String fcmToken,
    String deviceType,
    String? deviceName,
  ) async {
    final userId = await _getUserId(session);

    // Check if token already exists
    var existingToken = await DeviceToken.db.findFirstRow(
      session,
      where: (t) => t.fcmToken.equals(fcmToken),
    );

    final now = DateTime.now();

    if (existingToken != null) {
      // Update existing token
      existingToken.userId = userId;
      existingToken.deviceType = deviceType;
      existingToken.deviceName = deviceName;
      existingToken.isActive = true;
      existingToken.lastUsedAt = now;
      existingToken.updatedAt = now;

      await DeviceToken.db.updateRow(session, existingToken);
      session.log('Updated device token for user $userId');
    } else {
      // Create new token
      final deviceToken = DeviceToken(
        userId: userId,
        fcmToken: fcmToken,
        deviceType: deviceType,
        deviceName: deviceName,
        isActive: true,
        lastUsedAt: now,
        createdAt: now,
        updatedAt: now,
      );

      await DeviceToken.db.insertRow(session, deviceToken);
      session.log('Registered new device token for user $userId');
    }

    return true;
  }

  /// Unregister a device token (called on logout or when user disables notifications)
  Future<bool> unregisterDeviceToken(
    Session session,
    String fcmToken,
  ) async {
    final token = await DeviceToken.db.findFirstRow(
      session,
      where: (t) => t.fcmToken.equals(fcmToken),
    );

    if (token != null) {
      token.isActive = false;
      token.updatedAt = DateTime.now();
      await DeviceToken.db.updateRow(session, token);
      session.log('Unregistered device token');
    }

    return true;
  }

  /// Get notification history for the user
  Future<List<NotificationLog>> getNotificationHistory(
    Session session, {
    int limit = 50,
  }) async {
    final userId = await _getUserId(session);

    return await NotificationLog.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      orderBy: (t) => t.sentAt,
      orderDescending: true,
      limit: limit,
    );
  }

  /// Mark a notification as read
  Future<bool> markNotificationRead(
    Session session,
    int notificationId,
  ) async {
    final notification = await NotificationLog.db.findById(session, notificationId);

    if (notification != null) {
      notification.readAt = DateTime.now();
      await NotificationLog.db.updateRow(session, notification);
      return true;
    }

    return false;
  }

  /// Get count of unread critical notifications
  Future<int> getUnreadCriticalCount(Session session) async {
    final userId = await _getUserId(session);

    final unread = await NotificationLog.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.readAt.equals(null) &
          (t.priority >= PushNotificationService.criticalPriorityThreshold),
    );

    return unread.length;
  }

  /// Send a test notification (for debugging)
  Future<bool> sendTestNotification(Session session) async {
    final userId = await _getUserId(session);

    session.log('Sending test notification to user $userId');

    final result = await PushNotificationService.sendToUser(
      session,
      userId,
      title: 'Test Notification',
      body: 'This is a test notification from Recall Butler!',
      data: {'type': 'test'},
    );

    session.log('Test notification result: $result');
    return result;
  }

  /// Process and send notifications for unnotified critical emails
  /// Call this to retroactively notify for emails processed before notification was enabled
  Future<int> processUnnotifiedEmails(Session session) async {
    session.log('Processing unnotified critical emails...');

    final count = await PushNotificationService.processUnnotifiedCriticalEmails(
      session,
      limit: 20,
    );

    session.log('Processed $count unnotified critical emails');
    return count;
  }

  /// Helper to get user ID from session
  Future<int> _getUserId(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      return 1; // Default user for demo
    }
    return authInfo.userId;
  }
}

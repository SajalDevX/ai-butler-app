import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recall_butler_client/recall_butler_client.dart';

import 'client_provider.dart';

/// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Background message received: ${message.notification?.title}');
}

/// State for push notifications
class PushNotificationState {
  final bool isInitialized;
  final bool hasPermission;
  final String? fcmToken;
  final String? error;

  const PushNotificationState({
    this.isInitialized = false,
    this.hasPermission = false,
    this.fcmToken,
    this.error,
  });

  PushNotificationState copyWith({
    bool? isInitialized,
    bool? hasPermission,
    String? fcmToken,
    String? error,
  }) {
    return PushNotificationState(
      isInitialized: isInitialized ?? this.isInitialized,
      hasPermission: hasPermission ?? this.hasPermission,
      fcmToken: fcmToken ?? this.fcmToken,
      error: error,
    );
  }
}

/// Provider for push notification management
class PushNotificationNotifier extends StateNotifier<PushNotificationState> {
  final Client _client;
  final FlutterLocalNotificationsPlugin _localNotifications;
  FirebaseMessaging? _messaging;

  PushNotificationNotifier(this._client)
      : _localNotifications = FlutterLocalNotificationsPlugin(),
        super(const PushNotificationState());

  /// Initialize push notifications (Firebase should already be initialized in main.dart)
  Future<void> initialize() async {
    try {
      _messaging = FirebaseMessaging.instance;

      // Request permission
      final settings = await _messaging!.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      final hasPermission = settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;

      state = state.copyWith(
        isInitialized: true,
        hasPermission: hasPermission,
      );

      if (hasPermission) {
        await _setupNotifications();
      }
    } catch (e) {
      state = state.copyWith(
        isInitialized: true,
        error: 'Failed to initialize notifications: $e',
      );
    }
  }

  /// Set up notification handlers and get FCM token
  Future<void> _setupNotifications() async {
    // Initialize local notifications for foreground display
    await _initializeLocalNotifications();

    // Get FCM token
    final token = await _messaging?.getToken();
    if (token != null) {
      state = state.copyWith(fcmToken: token);
      await _registerTokenWithServer(token);
    }

    // Listen for token refresh
    _messaging?.onTokenRefresh.listen((newToken) async {
      state = state.copyWith(fcmToken: newToken);
      await _registerTokenWithServer(newToken);
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Check for initial message (app opened from terminated state via notification)
    final initialMessage = await _messaging?.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        // Handle notification tap
        _handleLocalNotificationTap(response);
      },
    );

    // Create notification channel for Android
    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        'critical_alerts',
        'Critical Alerts',
        description: 'High priority notifications for important emails',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  /// Register FCM token with server
  Future<void> _registerTokenWithServer(String token) async {
    try {
      final deviceType = Platform.isAndroid ? 'android' : 'ios';
      final deviceName = Platform.localHostname;

      await _client.notification.registerDeviceToken(
        token,
        deviceType,
        deviceName,
      );
      debugPrint('FCM token registered with server');
    } catch (e) {
      debugPrint('Failed to register FCM token: $e');
    }
  }

  /// Handle foreground messages - show local notification
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground message: ${message.notification?.title}');

    final notification = message.notification;
    if (notification != null) {
      _showLocalNotification(
        title: notification.title ?? 'New Notification',
        body: notification.body ?? '',
        payload: message.data.toString(),
      );
    }
  }

  /// Show a local notification
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'critical_alerts',
      'Critical Alerts',
      channelDescription: 'High priority notifications',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// Handle notification tap (background/terminated)
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('Notification tapped: ${message.data}');

    final data = message.data;
    final type = data['type'];

    if (type == 'critical_email') {
      // Navigate to email detail
      final emailId = data['emailId'];
      debugPrint('Navigate to email: $emailId');
      // TODO: Use navigation to go to email detail screen
    } else if (type == 'calendar_event') {
      // Navigate to calendar event
      final eventId = data['eventId'];
      debugPrint('Navigate to event: $eventId');
      // TODO: Use navigation to go to calendar event screen
    }
  }

  /// Handle local notification tap
  void _handleLocalNotificationTap(NotificationResponse response) {
    debugPrint('Local notification tapped: ${response.payload}');
    // TODO: Parse payload and navigate
  }

  /// Unregister device token (call on logout)
  Future<void> unregisterToken() async {
    final token = state.fcmToken;
    if (token != null) {
      try {
        await _client.notification.unregisterDeviceToken(token);
        state = state.copyWith(fcmToken: null);
      } catch (e) {
        debugPrint('Failed to unregister token: $e');
      }
    }
  }

  /// Send test notification
  Future<bool> sendTestNotification() async {
    try {
      return await _client.notification.sendTestNotification();
    } catch (e) {
      debugPrint('Failed to send test notification: $e');
      return false;
    }
  }
}

/// Provider for push notifications
final pushNotificationProvider =
    StateNotifierProvider<PushNotificationNotifier, PushNotificationState>((ref) {
  final client = ref.watch(clientProvider);
  return PushNotificationNotifier(client);
});

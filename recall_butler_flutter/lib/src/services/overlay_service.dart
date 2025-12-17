import 'dart:io';

import 'package:flutter/services.dart';

/// Service for managing the floating overlay on Android
class OverlayService {
  static const _channel = MethodChannel('com.recallbutler/overlay');

  /// Check if overlay is supported on this platform (Android only)
  static bool get isSupported => Platform.isAndroid;

  /// Check if overlay permission is granted
  static Future<bool> checkPermission() async {
    if (!isSupported) return false;

    try {
      final result = await _channel.invokeMethod<bool>('checkPermission');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Request overlay permission
  static Future<bool> requestPermission() async {
    if (!isSupported) return false;

    try {
      final result = await _channel.invokeMethod<bool>('requestPermission');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Show the floating overlay
  static Future<bool> showOverlay() async {
    if (!isSupported) return false;

    try {
      final result = await _channel.invokeMethod<bool>('showOverlay');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Hide the floating overlay
  static Future<bool> hideOverlay() async {
    if (!isSupported) return false;

    try {
      final result = await _channel.invokeMethod<bool>('hideOverlay');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Check if overlay is currently visible
  static Future<bool> isOverlayVisible() async {
    if (!isSupported) return false;

    try {
      final result = await _channel.invokeMethod<bool>('isOverlayVisible');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Request screen capture permission (MediaProjection)
  static Future<bool> requestScreenCapturePermission() async {
    if (!isSupported) return false;

    try {
      final result = await _channel.invokeMethod<bool>('requestScreenCapturePermission');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Check if screen capture permission is granted
  static Future<bool> hasScreenCapturePermission() async {
    if (!isSupported) return false;

    try {
      final result = await _channel.invokeMethod<bool>('hasScreenCapturePermission');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Capture the screen and return base64 encoded image
  static Future<String?> captureScreen() async {
    if (!isSupported) return null;

    try {
      final result = await _channel.invokeMethod<String>('captureScreen');
      return result;
    } catch (e) {
      return null;
    }
  }

  /// Set up callback handler for overlay actions
  static void setCallbackHandler({
    required Function(String action) onAction,
    required Function(String base64Image) onScreenshotCaptured,
  }) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onOverlayAction') {
        final action = call.arguments as String;
        onAction(action);
      } else if (call.method == 'onScreenshotCaptured') {
        final base64Image = call.arguments as String;
        onScreenshotCaptured(base64Image);
      }
      return null;
    });
  }
}

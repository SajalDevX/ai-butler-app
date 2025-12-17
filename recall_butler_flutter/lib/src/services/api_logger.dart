import 'dart:convert';

import 'package:flutter/foundation.dart';

/// Pretty API logger for debug mode
/// Logs Serverpod API calls in a formatted, readable way
class ApiLogger {
  static const String _divider = '═══════════════════════════════════════════════════════════';
  static const String _thinDivider = '───────────────────────────────────────────────────────────';

  /// Log a successful API call
  static void logSuccess({
    required String endpoint,
    required String method,
    Map<String, dynamic>? parameters,
    dynamic response,
    Duration? duration,
  }) {
    if (!kDebugMode) return;

    final buffer = StringBuffer();
    buffer.writeln();
    buffer.writeln('[API] ┌$_divider');
    buffer.writeln('[API] │ ✅ API CALL SUCCESS');
    buffer.writeln('[API] ├$_thinDivider');
    buffer.writeln('[API] │ 📍 Endpoint: $endpoint.$method');
    if (duration != null) {
      buffer.writeln('[API] │ ⏱️  Duration: ${duration.inMilliseconds}ms');
    }

    if (parameters != null && parameters.isNotEmpty) {
      buffer.writeln('[API] ├$_thinDivider');
      buffer.writeln('[API] │ 📤 REQUEST PARAMETERS:');
      _formatJson(parameters, buffer);
    }

    if (response != null) {
      buffer.writeln('[API] ├$_thinDivider');
      buffer.writeln('[API] │ 📥 RESPONSE:');
      _formatResponse(response, buffer);
    }

    buffer.writeln('[API] └$_divider');

    debugPrint(buffer.toString());
  }

  /// Log a failed API call
  static void logError({
    required String endpoint,
    required String method,
    Map<String, dynamic>? parameters,
    required Object error,
    StackTrace? stackTrace,
    Duration? duration,
  }) {
    if (!kDebugMode) return;

    final buffer = StringBuffer();
    buffer.writeln();
    buffer.writeln('[API] ┌$_divider');
    buffer.writeln('[API] │ ❌ API CALL FAILED');
    buffer.writeln('[API] ├$_thinDivider');
    buffer.writeln('[API] │ 📍 Endpoint: $endpoint.$method');
    if (duration != null) {
      buffer.writeln('[API] │ ⏱️  Duration: ${duration.inMilliseconds}ms');
    }

    if (parameters != null && parameters.isNotEmpty) {
      buffer.writeln('[API] ├$_thinDivider');
      buffer.writeln('[API] │ 📤 REQUEST PARAMETERS:');
      _formatJson(parameters, buffer);
    }

    buffer.writeln('[API] ├$_thinDivider');
    buffer.writeln('[API] │ 💥 ERROR:');
    buffer.writeln('[API] │    Type: ${error.runtimeType}');
    buffer.writeln('[API] │    Message: $error');

    if (stackTrace != null) {
      buffer.writeln('[API] ├$_thinDivider');
      buffer.writeln('[API] │ 📚 STACK TRACE (first 5 frames):');
      final frames = stackTrace.toString().split('\n').take(5);
      for (final frame in frames) {
        if (frame.trim().isNotEmpty) {
          buffer.writeln('[API] │    $frame');
        }
      }
    }

    buffer.writeln('[API] └$_divider');

    debugPrint(buffer.toString());
  }

  /// Format JSON data for pretty printing
  static void _formatJson(Map<String, dynamic> data, StringBuffer buffer) {
    try {
      final encoder = const JsonEncoder.withIndent('  ');
      final prettyJson = encoder.convert(data);
      for (final line in prettyJson.split('\n')) {
        buffer.writeln('[API] │    $line');
      }
    } catch (e) {
      buffer.writeln('[API] │    ${data.toString()}');
    }
  }

  /// Format response data for pretty printing
  static void _formatResponse(dynamic response, StringBuffer buffer) {
    if (response == null) {
      buffer.writeln('[API] │    null');
      return;
    }

    try {
      if (response is Map) {
        _formatJson(Map<String, dynamic>.from(response), buffer);
      } else if (response is List) {
        buffer.writeln('[API] │    List with ${response.length} items');
        if (response.isNotEmpty && response.length <= 3) {
          final encoder = const JsonEncoder.withIndent('  ');
          final prettyJson = encoder.convert(response);
          for (final line in prettyJson.split('\n')) {
            buffer.writeln('[API] │    $line');
          }
        } else if (response.length > 3) {
          buffer.writeln('[API] │    First item sample:');
          if (response.first is Map) {
            _formatJson(
                Map<String, dynamic>.from(response.first as Map), buffer);
          } else {
            buffer.writeln('[API] │      ${response.first}');
          }
        }
      } else {
        final str = response.toString();
        if (str.length > 200) {
          buffer.writeln('[API] │    ${str.substring(0, 200)}...');
          buffer.writeln('[API] │    (truncated, ${str.length} chars total)');
        } else {
          buffer.writeln('[API] │    $str');
        }
      }
    } catch (e) {
      buffer.writeln('[API] │    ${response.toString()}');
    }
  }

  /// Log a simple info message
  static void logInfo(String message) {
    if (!kDebugMode) return;
    debugPrint('[API] │ ℹ️  $message');
  }

  /// Log the start of an API call (for timing)
  static Stopwatch startCall(String endpoint, String method) {
    if (!kDebugMode) return Stopwatch();
    debugPrint('[API] │ 🚀 Starting: $endpoint.$method');
    return Stopwatch()..start();
  }
}

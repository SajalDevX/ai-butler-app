/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Result of Google OAuth token exchange
abstract class GoogleAuthResult
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  GoogleAuthResult._({
    required this.success,
    this.error,
    this.gmailEnabled,
    this.calendarEnabled,
  });

  factory GoogleAuthResult({
    required bool success,
    String? error,
    bool? gmailEnabled,
    bool? calendarEnabled,
  }) = _GoogleAuthResultImpl;

  factory GoogleAuthResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return GoogleAuthResult(
      success: jsonSerialization['success'] as bool,
      error: jsonSerialization['error'] as String?,
      gmailEnabled: jsonSerialization['gmailEnabled'] as bool?,
      calendarEnabled: jsonSerialization['calendarEnabled'] as bool?,
    );
  }

  bool success;

  String? error;

  bool? gmailEnabled;

  bool? calendarEnabled;

  /// Returns a shallow copy of this [GoogleAuthResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  GoogleAuthResult copyWith({
    bool? success,
    String? error,
    bool? gmailEnabled,
    bool? calendarEnabled,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (error != null) 'error': error,
      if (gmailEnabled != null) 'gmailEnabled': gmailEnabled,
      if (calendarEnabled != null) 'calendarEnabled': calendarEnabled,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'success': success,
      if (error != null) 'error': error,
      if (gmailEnabled != null) 'gmailEnabled': gmailEnabled,
      if (calendarEnabled != null) 'calendarEnabled': calendarEnabled,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GoogleAuthResultImpl extends GoogleAuthResult {
  _GoogleAuthResultImpl({
    required bool success,
    String? error,
    bool? gmailEnabled,
    bool? calendarEnabled,
  }) : super._(
          success: success,
          error: error,
          gmailEnabled: gmailEnabled,
          calendarEnabled: calendarEnabled,
        );

  /// Returns a shallow copy of this [GoogleAuthResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  GoogleAuthResult copyWith({
    bool? success,
    Object? error = _Undefined,
    Object? gmailEnabled = _Undefined,
    Object? calendarEnabled = _Undefined,
  }) {
    return GoogleAuthResult(
      success: success ?? this.success,
      error: error is String? ? error : this.error,
      gmailEnabled: gmailEnabled is bool? ? gmailEnabled : this.gmailEnabled,
      calendarEnabled:
          calendarEnabled is bool? ? calendarEnabled : this.calendarEnabled,
    );
  }
}

/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Result of email send/schedule operation
abstract class EmailSendResult implements _i1.SerializableModel {
  EmailSendResult._({
    required this.success,
    this.error,
    this.scheduledTime,
    this.messageId,
  });

  factory EmailSendResult({
    required bool success,
    String? error,
    DateTime? scheduledTime,
    String? messageId,
  }) = _EmailSendResultImpl;

  factory EmailSendResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmailSendResult(
      success: jsonSerialization['success'] as bool,
      error: jsonSerialization['error'] as String?,
      scheduledTime: jsonSerialization['scheduledTime'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['scheduledTime']),
      messageId: jsonSerialization['messageId'] as String?,
    );
  }

  bool success;

  String? error;

  DateTime? scheduledTime;

  String? messageId;

  /// Returns a shallow copy of this [EmailSendResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailSendResult copyWith({
    bool? success,
    String? error,
    DateTime? scheduledTime,
    String? messageId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (error != null) 'error': error,
      if (scheduledTime != null) 'scheduledTime': scheduledTime?.toJson(),
      if (messageId != null) 'messageId': messageId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailSendResultImpl extends EmailSendResult {
  _EmailSendResultImpl({
    required bool success,
    String? error,
    DateTime? scheduledTime,
    String? messageId,
  }) : super._(
          success: success,
          error: error,
          scheduledTime: scheduledTime,
          messageId: messageId,
        );

  /// Returns a shallow copy of this [EmailSendResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailSendResult copyWith({
    bool? success,
    Object? error = _Undefined,
    Object? scheduledTime = _Undefined,
    Object? messageId = _Undefined,
  }) {
    return EmailSendResult(
      success: success ?? this.success,
      error: error is String? ? error : this.error,
      scheduledTime:
          scheduledTime is DateTime? ? scheduledTime : this.scheduledTime,
      messageId: messageId is String? ? messageId : this.messageId,
    );
  }
}

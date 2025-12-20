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

/// Task data for scheduled email sending
abstract class ScheduledEmailTask implements _i1.SerializableModel {
  ScheduledEmailTask._({
    required this.userId,
    required this.gmailId,
    required this.replyText,
    required this.scheduledTime,
  });

  factory ScheduledEmailTask({
    required int userId,
    required String gmailId,
    required String replyText,
    required DateTime scheduledTime,
  }) = _ScheduledEmailTaskImpl;

  factory ScheduledEmailTask.fromJson(Map<String, dynamic> jsonSerialization) {
    return ScheduledEmailTask(
      userId: jsonSerialization['userId'] as int,
      gmailId: jsonSerialization['gmailId'] as String,
      replyText: jsonSerialization['replyText'] as String,
      scheduledTime: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['scheduledTime']),
    );
  }

  int userId;

  String gmailId;

  String replyText;

  DateTime scheduledTime;

  /// Returns a shallow copy of this [ScheduledEmailTask]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ScheduledEmailTask copyWith({
    int? userId,
    String? gmailId,
    String? replyText,
    DateTime? scheduledTime,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'gmailId': gmailId,
      'replyText': replyText,
      'scheduledTime': scheduledTime.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ScheduledEmailTaskImpl extends ScheduledEmailTask {
  _ScheduledEmailTaskImpl({
    required int userId,
    required String gmailId,
    required String replyText,
    required DateTime scheduledTime,
  }) : super._(
          userId: userId,
          gmailId: gmailId,
          replyText: replyText,
          scheduledTime: scheduledTime,
        );

  /// Returns a shallow copy of this [ScheduledEmailTask]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ScheduledEmailTask copyWith({
    int? userId,
    String? gmailId,
    String? replyText,
    DateTime? scheduledTime,
  }) {
    return ScheduledEmailTask(
      userId: userId ?? this.userId,
      gmailId: gmailId ?? this.gmailId,
      replyText: replyText ?? this.replyText,
      scheduledTime: scheduledTime ?? this.scheduledTime,
    );
  }
}

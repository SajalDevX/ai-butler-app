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

/// Reminder - proactive reminder notifications for captures
abstract class Reminder implements _i1.SerializableModel {
  Reminder._({
    this.id,
    required this.userId,
    required this.captureId,
    this.message,
    required this.triggerAt,
    required this.isSent,
    required this.isDismissed,
    required this.createdAt,
  });

  factory Reminder({
    int? id,
    required int userId,
    required int captureId,
    String? message,
    required DateTime triggerAt,
    required bool isSent,
    required bool isDismissed,
    required DateTime createdAt,
  }) = _ReminderImpl;

  factory Reminder.fromJson(Map<String, dynamic> jsonSerialization) {
    return Reminder(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      captureId: jsonSerialization['captureId'] as int,
      message: jsonSerialization['message'] as String?,
      triggerAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['triggerAt']),
      isSent: jsonSerialization['isSent'] as bool,
      isDismissed: jsonSerialization['isDismissed'] as bool,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Foreign key to user
  int userId;

  /// Foreign key to capture
  int captureId;

  /// Reminder message
  String? message;

  /// When to trigger the reminder
  DateTime triggerAt;

  /// Whether the reminder has been sent
  bool isSent;

  /// Whether the user has dismissed the reminder
  bool isDismissed;

  /// Creation timestamp
  DateTime createdAt;

  /// Returns a shallow copy of this [Reminder]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Reminder copyWith({
    int? id,
    int? userId,
    int? captureId,
    String? message,
    DateTime? triggerAt,
    bool? isSent,
    bool? isDismissed,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'captureId': captureId,
      if (message != null) 'message': message,
      'triggerAt': triggerAt.toJson(),
      'isSent': isSent,
      'isDismissed': isDismissed,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReminderImpl extends Reminder {
  _ReminderImpl({
    int? id,
    required int userId,
    required int captureId,
    String? message,
    required DateTime triggerAt,
    required bool isSent,
    required bool isDismissed,
    required DateTime createdAt,
  }) : super._(
          id: id,
          userId: userId,
          captureId: captureId,
          message: message,
          triggerAt: triggerAt,
          isSent: isSent,
          isDismissed: isDismissed,
          createdAt: createdAt,
        );

  /// Returns a shallow copy of this [Reminder]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Reminder copyWith({
    Object? id = _Undefined,
    int? userId,
    int? captureId,
    Object? message = _Undefined,
    DateTime? triggerAt,
    bool? isSent,
    bool? isDismissed,
    DateTime? createdAt,
  }) {
    return Reminder(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      captureId: captureId ?? this.captureId,
      message: message is String? ? message : this.message,
      triggerAt: triggerAt ?? this.triggerAt,
      isSent: isSent ?? this.isSent,
      isDismissed: isDismissed ?? this.isDismissed,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

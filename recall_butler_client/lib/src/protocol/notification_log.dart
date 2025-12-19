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

/// Notification Log for tracking sent push notifications
/// Prevents duplicate notifications and provides history
abstract class NotificationLog implements _i1.SerializableModel {
  NotificationLog._({
    this.id,
    required this.userId,
    required this.sourceType,
    required this.sourceId,
    required this.title,
    required this.body,
    required this.priority,
    required this.sentAt,
    this.deliveredAt,
    this.readAt,
    this.fcmMessageId,
    this.error,
  });

  factory NotificationLog({
    int? id,
    required int userId,
    required String sourceType,
    required String sourceId,
    required String title,
    required String body,
    required int priority,
    required DateTime sentAt,
    DateTime? deliveredAt,
    DateTime? readAt,
    String? fcmMessageId,
    String? error,
  }) = _NotificationLogImpl;

  factory NotificationLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return NotificationLog(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      sourceType: jsonSerialization['sourceType'] as String,
      sourceId: jsonSerialization['sourceId'] as String,
      title: jsonSerialization['title'] as String,
      body: jsonSerialization['body'] as String,
      priority: jsonSerialization['priority'] as int,
      sentAt: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['sentAt']),
      deliveredAt: jsonSerialization['deliveredAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['deliveredAt']),
      readAt: jsonSerialization['readAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['readAt']),
      fcmMessageId: jsonSerialization['fcmMessageId'] as String?,
      error: jsonSerialization['error'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  String sourceType;

  String sourceId;

  String title;

  String body;

  int priority;

  DateTime sentAt;

  DateTime? deliveredAt;

  DateTime? readAt;

  String? fcmMessageId;

  String? error;

  /// Returns a shallow copy of this [NotificationLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NotificationLog copyWith({
    int? id,
    int? userId,
    String? sourceType,
    String? sourceId,
    String? title,
    String? body,
    int? priority,
    DateTime? sentAt,
    DateTime? deliveredAt,
    DateTime? readAt,
    String? fcmMessageId,
    String? error,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'sourceType': sourceType,
      'sourceId': sourceId,
      'title': title,
      'body': body,
      'priority': priority,
      'sentAt': sentAt.toJson(),
      if (deliveredAt != null) 'deliveredAt': deliveredAt?.toJson(),
      if (readAt != null) 'readAt': readAt?.toJson(),
      if (fcmMessageId != null) 'fcmMessageId': fcmMessageId,
      if (error != null) 'error': error,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationLogImpl extends NotificationLog {
  _NotificationLogImpl({
    int? id,
    required int userId,
    required String sourceType,
    required String sourceId,
    required String title,
    required String body,
    required int priority,
    required DateTime sentAt,
    DateTime? deliveredAt,
    DateTime? readAt,
    String? fcmMessageId,
    String? error,
  }) : super._(
          id: id,
          userId: userId,
          sourceType: sourceType,
          sourceId: sourceId,
          title: title,
          body: body,
          priority: priority,
          sentAt: sentAt,
          deliveredAt: deliveredAt,
          readAt: readAt,
          fcmMessageId: fcmMessageId,
          error: error,
        );

  /// Returns a shallow copy of this [NotificationLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NotificationLog copyWith({
    Object? id = _Undefined,
    int? userId,
    String? sourceType,
    String? sourceId,
    String? title,
    String? body,
    int? priority,
    DateTime? sentAt,
    Object? deliveredAt = _Undefined,
    Object? readAt = _Undefined,
    Object? fcmMessageId = _Undefined,
    Object? error = _Undefined,
  }) {
    return NotificationLog(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      sourceType: sourceType ?? this.sourceType,
      sourceId: sourceId ?? this.sourceId,
      title: title ?? this.title,
      body: body ?? this.body,
      priority: priority ?? this.priority,
      sentAt: sentAt ?? this.sentAt,
      deliveredAt: deliveredAt is DateTime? ? deliveredAt : this.deliveredAt,
      readAt: readAt is DateTime? ? readAt : this.readAt,
      fcmMessageId: fcmMessageId is String? ? fcmMessageId : this.fcmMessageId,
      error: error is String? ? error : this.error,
    );
  }
}

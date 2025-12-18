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

/// Action - AI-extracted tasks, reminders, and events from captures
abstract class Action implements _i1.SerializableModel {
  Action._({
    this.id,
    required this.userId,
    this.captureId,
    required this.type,
    required this.title,
    this.notes,
    this.dueAt,
    this.reminderAt,
    required this.isCompleted,
    required this.priority,
    required this.createdAt,
    this.completedAt,
  });

  factory Action({
    int? id,
    required int userId,
    int? captureId,
    required String type,
    required String title,
    String? notes,
    DateTime? dueAt,
    DateTime? reminderAt,
    required bool isCompleted,
    required String priority,
    required DateTime createdAt,
    DateTime? completedAt,
  }) = _ActionImpl;

  factory Action.fromJson(Map<String, dynamic> jsonSerialization) {
    return Action(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      captureId: jsonSerialization['captureId'] as int?,
      type: jsonSerialization['type'] as String,
      title: jsonSerialization['title'] as String,
      notes: jsonSerialization['notes'] as String?,
      dueAt: jsonSerialization['dueAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['dueAt']),
      reminderAt: jsonSerialization['reminderAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['reminderAt']),
      isCompleted: jsonSerialization['isCompleted'] as bool,
      priority: jsonSerialization['priority'] as String,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Foreign key to user
  int userId;

  /// Foreign key to source capture (optional - actions can be standalone)
  int? captureId;

  /// Type: task, reminder, event, shopping, birthday, anniversary, deadline, appointment
  String type;

  /// Action title/description
  String title;

  /// Detailed notes (optional)
  String? notes;

  /// Due date/time - when the event occurs
  DateTime? dueAt;

  /// Reminder date/time - when to remind the user (calculated from dueAt - reminderDaysBefore)
  DateTime? reminderAt;

  /// Whether the action is completed
  bool isCompleted;

  /// Priority: low, medium, high (AI-determined based on event importance)
  String priority;

  /// Creation timestamp
  DateTime createdAt;

  /// Completion timestamp (optional)
  DateTime? completedAt;

  /// Returns a shallow copy of this [Action]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Action copyWith({
    int? id,
    int? userId,
    int? captureId,
    String? type,
    String? title,
    String? notes,
    DateTime? dueAt,
    DateTime? reminderAt,
    bool? isCompleted,
    String? priority,
    DateTime? createdAt,
    DateTime? completedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      if (captureId != null) 'captureId': captureId,
      'type': type,
      'title': title,
      if (notes != null) 'notes': notes,
      if (dueAt != null) 'dueAt': dueAt?.toJson(),
      if (reminderAt != null) 'reminderAt': reminderAt?.toJson(),
      'isCompleted': isCompleted,
      'priority': priority,
      'createdAt': createdAt.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ActionImpl extends Action {
  _ActionImpl({
    int? id,
    required int userId,
    int? captureId,
    required String type,
    required String title,
    String? notes,
    DateTime? dueAt,
    DateTime? reminderAt,
    required bool isCompleted,
    required String priority,
    required DateTime createdAt,
    DateTime? completedAt,
  }) : super._(
          id: id,
          userId: userId,
          captureId: captureId,
          type: type,
          title: title,
          notes: notes,
          dueAt: dueAt,
          reminderAt: reminderAt,
          isCompleted: isCompleted,
          priority: priority,
          createdAt: createdAt,
          completedAt: completedAt,
        );

  /// Returns a shallow copy of this [Action]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Action copyWith({
    Object? id = _Undefined,
    int? userId,
    Object? captureId = _Undefined,
    String? type,
    String? title,
    Object? notes = _Undefined,
    Object? dueAt = _Undefined,
    Object? reminderAt = _Undefined,
    bool? isCompleted,
    String? priority,
    DateTime? createdAt,
    Object? completedAt = _Undefined,
  }) {
    return Action(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      captureId: captureId is int? ? captureId : this.captureId,
      type: type ?? this.type,
      title: title ?? this.title,
      notes: notes is String? ? notes : this.notes,
      dueAt: dueAt is DateTime? ? dueAt : this.dueAt,
      reminderAt: reminderAt is DateTime? ? reminderAt : this.reminderAt,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
    );
  }
}

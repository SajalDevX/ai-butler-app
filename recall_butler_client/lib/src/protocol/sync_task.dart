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

/// Simple model for sync task future calls
abstract class SyncTask implements _i1.SerializableModel {
  SyncTask._({
    this.taskType,
    this.userId,
  });

  factory SyncTask({
    String? taskType,
    int? userId,
  }) = _SyncTaskImpl;

  factory SyncTask.fromJson(Map<String, dynamic> jsonSerialization) {
    return SyncTask(
      taskType: jsonSerialization['taskType'] as String?,
      userId: jsonSerialization['userId'] as int?,
    );
  }

  String? taskType;

  int? userId;

  /// Returns a shallow copy of this [SyncTask]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SyncTask copyWith({
    String? taskType,
    int? userId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (taskType != null) 'taskType': taskType,
      if (userId != null) 'userId': userId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SyncTaskImpl extends SyncTask {
  _SyncTaskImpl({
    String? taskType,
    int? userId,
  }) : super._(
          taskType: taskType,
          userId: userId,
        );

  /// Returns a shallow copy of this [SyncTask]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SyncTask copyWith({
    Object? taskType = _Undefined,
    Object? userId = _Undefined,
  }) {
    return SyncTask(
      taskType: taskType is String? ? taskType : this.taskType,
      userId: userId is int? ? userId : this.userId,
    );
  }
}

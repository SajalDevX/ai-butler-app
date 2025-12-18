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

/// Result of sync operation (Gmail or Calendar)
abstract class SyncResult implements _i1.SerializableModel {
  SyncResult._({
    required this.success,
    this.error,
    required this.newCount,
    required this.updatedCount,
  });

  factory SyncResult({
    required bool success,
    String? error,
    required int newCount,
    required int updatedCount,
  }) = _SyncResultImpl;

  factory SyncResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return SyncResult(
      success: jsonSerialization['success'] as bool,
      error: jsonSerialization['error'] as String?,
      newCount: jsonSerialization['newCount'] as int,
      updatedCount: jsonSerialization['updatedCount'] as int,
    );
  }

  bool success;

  String? error;

  int newCount;

  int updatedCount;

  /// Returns a shallow copy of this [SyncResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SyncResult copyWith({
    bool? success,
    String? error,
    int? newCount,
    int? updatedCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (error != null) 'error': error,
      'newCount': newCount,
      'updatedCount': updatedCount,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SyncResultImpl extends SyncResult {
  _SyncResultImpl({
    required bool success,
    String? error,
    required int newCount,
    required int updatedCount,
  }) : super._(
          success: success,
          error: error,
          newCount: newCount,
          updatedCount: updatedCount,
        );

  /// Returns a shallow copy of this [SyncResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SyncResult copyWith({
    bool? success,
    Object? error = _Undefined,
    int? newCount,
    int? updatedCount,
  }) {
    return SyncResult(
      success: success ?? this.success,
      error: error is String? ? error : this.error,
      newCount: newCount ?? this.newCount,
      updatedCount: updatedCount ?? this.updatedCount,
    );
  }
}

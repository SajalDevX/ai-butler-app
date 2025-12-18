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

/// Result of meeting preparation generation
abstract class MeetingPrepResult implements _i1.SerializableModel {
  MeetingPrepResult._({
    required this.success,
    this.error,
    this.contextBrief,
    this.relatedEmailCount,
  });

  factory MeetingPrepResult({
    required bool success,
    String? error,
    String? contextBrief,
    int? relatedEmailCount,
  }) = _MeetingPrepResultImpl;

  factory MeetingPrepResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return MeetingPrepResult(
      success: jsonSerialization['success'] as bool,
      error: jsonSerialization['error'] as String?,
      contextBrief: jsonSerialization['contextBrief'] as String?,
      relatedEmailCount: jsonSerialization['relatedEmailCount'] as int?,
    );
  }

  bool success;

  String? error;

  String? contextBrief;

  int? relatedEmailCount;

  /// Returns a shallow copy of this [MeetingPrepResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MeetingPrepResult copyWith({
    bool? success,
    String? error,
    String? contextBrief,
    int? relatedEmailCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (error != null) 'error': error,
      if (contextBrief != null) 'contextBrief': contextBrief,
      if (relatedEmailCount != null) 'relatedEmailCount': relatedEmailCount,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MeetingPrepResultImpl extends MeetingPrepResult {
  _MeetingPrepResultImpl({
    required bool success,
    String? error,
    String? contextBrief,
    int? relatedEmailCount,
  }) : super._(
          success: success,
          error: error,
          contextBrief: contextBrief,
          relatedEmailCount: relatedEmailCount,
        );

  /// Returns a shallow copy of this [MeetingPrepResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MeetingPrepResult copyWith({
    bool? success,
    Object? error = _Undefined,
    Object? contextBrief = _Undefined,
    Object? relatedEmailCount = _Undefined,
  }) {
    return MeetingPrepResult(
      success: success ?? this.success,
      error: error is String? ? error : this.error,
      contextBrief: contextBrief is String? ? contextBrief : this.contextBrief,
      relatedEmailCount: relatedEmailCount is int?
          ? relatedEmailCount
          : this.relatedEmailCount,
    );
  }
}

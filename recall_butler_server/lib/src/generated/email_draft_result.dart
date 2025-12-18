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

/// Result of AI draft generation
abstract class EmailDraftResult
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  EmailDraftResult._({
    required this.success,
    this.error,
    this.draftText,
  });

  factory EmailDraftResult({
    required bool success,
    String? error,
    String? draftText,
  }) = _EmailDraftResultImpl;

  factory EmailDraftResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmailDraftResult(
      success: jsonSerialization['success'] as bool,
      error: jsonSerialization['error'] as String?,
      draftText: jsonSerialization['draftText'] as String?,
    );
  }

  bool success;

  String? error;

  String? draftText;

  /// Returns a shallow copy of this [EmailDraftResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailDraftResult copyWith({
    bool? success,
    String? error,
    String? draftText,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (error != null) 'error': error,
      if (draftText != null) 'draftText': draftText,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'success': success,
      if (error != null) 'error': error,
      if (draftText != null) 'draftText': draftText,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailDraftResultImpl extends EmailDraftResult {
  _EmailDraftResultImpl({
    required bool success,
    String? error,
    String? draftText,
  }) : super._(
          success: success,
          error: error,
          draftText: draftText,
        );

  /// Returns a shallow copy of this [EmailDraftResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailDraftResult copyWith({
    bool? success,
    Object? error = _Undefined,
    Object? draftText = _Undefined,
  }) {
    return EmailDraftResult(
      success: success ?? this.success,
      error: error is String? ? error : this.error,
      draftText: draftText is String? ? draftText : this.draftText,
    );
  }
}

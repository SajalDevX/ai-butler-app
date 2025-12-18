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

/// QuickAnalysisResult - fast initial analysis result
abstract class QuickAnalysisResult
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  QuickAnalysisResult._({
    required this.description,
    required this.detectedType,
    required this.confidence,
  });

  factory QuickAnalysisResult({
    required String description,
    required String detectedType,
    required double confidence,
  }) = _QuickAnalysisResultImpl;

  factory QuickAnalysisResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return QuickAnalysisResult(
      description: jsonSerialization['description'] as String,
      detectedType: jsonSerialization['detectedType'] as String,
      confidence: (jsonSerialization['confidence'] as num).toDouble(),
    );
  }

  /// Brief description of the content
  String description;

  /// Detected type: recipe, task, reminder, event, note, shopping, calendar, other
  String detectedType;

  /// Confidence score 0.0-1.0
  double confidence;

  /// Returns a shallow copy of this [QuickAnalysisResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  QuickAnalysisResult copyWith({
    String? description,
    String? detectedType,
    double? confidence,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'detectedType': detectedType,
      'confidence': confidence,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _QuickAnalysisResultImpl extends QuickAnalysisResult {
  _QuickAnalysisResultImpl({
    required String description,
    required String detectedType,
    required double confidence,
  }) : super._(
          description: description,
          detectedType: detectedType,
          confidence: confidence,
        );

  /// Returns a shallow copy of this [QuickAnalysisResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  QuickAnalysisResult copyWith({
    String? description,
    String? detectedType,
    double? confidence,
  }) {
    return QuickAnalysisResult(
      description: description ?? this.description,
      detectedType: detectedType ?? this.detectedType,
      confidence: confidence ?? this.confidence,
    );
  }
}

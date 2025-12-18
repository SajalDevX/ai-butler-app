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

/// TokenUsageHistory - Tracks token usage for adaptive learning
abstract class TokenUsageHistory implements _i1.SerializableModel {
  TokenUsageHistory._({
    this.id,
    required this.contentType,
    required this.complexityBucket,
    this.complexityScore,
    required this.tokensAllocated,
    required this.tokensUsed,
    required this.wasComplete,
    required this.isQuickAnalysis,
    required this.createdAt,
  });

  factory TokenUsageHistory({
    int? id,
    required String contentType,
    required String complexityBucket,
    double? complexityScore,
    required int tokensAllocated,
    required int tokensUsed,
    required bool wasComplete,
    required bool isQuickAnalysis,
    required DateTime createdAt,
  }) = _TokenUsageHistoryImpl;

  factory TokenUsageHistory.fromJson(Map<String, dynamic> jsonSerialization) {
    return TokenUsageHistory(
      id: jsonSerialization['id'] as int?,
      contentType: jsonSerialization['contentType'] as String,
      complexityBucket: jsonSerialization['complexityBucket'] as String,
      complexityScore:
          (jsonSerialization['complexityScore'] as num?)?.toDouble(),
      tokensAllocated: jsonSerialization['tokensAllocated'] as int,
      tokensUsed: jsonSerialization['tokensUsed'] as int,
      wasComplete: jsonSerialization['wasComplete'] as bool,
      isQuickAnalysis: jsonSerialization['isQuickAnalysis'] as bool,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Content type detected (document, photo, recipe, etc.)
  String contentType;

  /// Complexity bucket (simple, medium, complex)
  String complexityBucket;

  /// Exact complexity score 0.0-1.0
  double? complexityScore;

  /// Tokens allocated for this request
  int tokensAllocated;

  /// Actual tokens used in response
  int tokensUsed;

  /// Whether the response was complete (not truncated)
  bool wasComplete;

  /// Whether this was quick analysis (sync) or deep analysis (async)
  bool isQuickAnalysis;

  /// Timestamp for tracking
  DateTime createdAt;

  /// Returns a shallow copy of this [TokenUsageHistory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TokenUsageHistory copyWith({
    int? id,
    String? contentType,
    String? complexityBucket,
    double? complexityScore,
    int? tokensAllocated,
    int? tokensUsed,
    bool? wasComplete,
    bool? isQuickAnalysis,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'contentType': contentType,
      'complexityBucket': complexityBucket,
      if (complexityScore != null) 'complexityScore': complexityScore,
      'tokensAllocated': tokensAllocated,
      'tokensUsed': tokensUsed,
      'wasComplete': wasComplete,
      'isQuickAnalysis': isQuickAnalysis,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TokenUsageHistoryImpl extends TokenUsageHistory {
  _TokenUsageHistoryImpl({
    int? id,
    required String contentType,
    required String complexityBucket,
    double? complexityScore,
    required int tokensAllocated,
    required int tokensUsed,
    required bool wasComplete,
    required bool isQuickAnalysis,
    required DateTime createdAt,
  }) : super._(
          id: id,
          contentType: contentType,
          complexityBucket: complexityBucket,
          complexityScore: complexityScore,
          tokensAllocated: tokensAllocated,
          tokensUsed: tokensUsed,
          wasComplete: wasComplete,
          isQuickAnalysis: isQuickAnalysis,
          createdAt: createdAt,
        );

  /// Returns a shallow copy of this [TokenUsageHistory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TokenUsageHistory copyWith({
    Object? id = _Undefined,
    String? contentType,
    String? complexityBucket,
    Object? complexityScore = _Undefined,
    int? tokensAllocated,
    int? tokensUsed,
    bool? wasComplete,
    bool? isQuickAnalysis,
    DateTime? createdAt,
  }) {
    return TokenUsageHistory(
      id: id is int? ? id : this.id,
      contentType: contentType ?? this.contentType,
      complexityBucket: complexityBucket ?? this.complexityBucket,
      complexityScore:
          complexityScore is double? ? complexityScore : this.complexityScore,
      tokensAllocated: tokensAllocated ?? this.tokensAllocated,
      tokensUsed: tokensUsed ?? this.tokensUsed,
      wasComplete: wasComplete ?? this.wasComplete,
      isQuickAnalysis: isQuickAnalysis ?? this.isQuickAnalysis,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

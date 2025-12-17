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
import 'capture.dart' as _i2;

/// SearchResult - DTO for search results
abstract class SearchResult implements _i1.SerializableModel {
  SearchResult._({
    required this.captures,
    required this.totalCount,
    this.aiSummary,
    this.suggestions,
  });

  factory SearchResult({
    required List<_i2.Capture> captures,
    required int totalCount,
    String? aiSummary,
    List<String>? suggestions,
  }) = _SearchResultImpl;

  factory SearchResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return SearchResult(
      captures: (jsonSerialization['captures'] as List)
          .map((e) => _i2.Capture.fromJson((e as Map<String, dynamic>)))
          .toList(),
      totalCount: jsonSerialization['totalCount'] as int,
      aiSummary: jsonSerialization['aiSummary'] as String?,
      suggestions: (jsonSerialization['suggestions'] as List?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  /// List of matching captures
  List<_i2.Capture> captures;

  /// Total number of matching results
  int totalCount;

  /// AI-generated summary of results (if applicable)
  String? aiSummary;

  /// Related search suggestions
  List<String>? suggestions;

  /// Returns a shallow copy of this [SearchResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SearchResult copyWith({
    List<_i2.Capture>? captures,
    int? totalCount,
    String? aiSummary,
    List<String>? suggestions,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'captures': captures.toJson(valueToJson: (v) => v.toJson()),
      'totalCount': totalCount,
      if (aiSummary != null) 'aiSummary': aiSummary,
      if (suggestions != null) 'suggestions': suggestions?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SearchResultImpl extends SearchResult {
  _SearchResultImpl({
    required List<_i2.Capture> captures,
    required int totalCount,
    String? aiSummary,
    List<String>? suggestions,
  }) : super._(
          captures: captures,
          totalCount: totalCount,
          aiSummary: aiSummary,
          suggestions: suggestions,
        );

  /// Returns a shallow copy of this [SearchResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SearchResult copyWith({
    List<_i2.Capture>? captures,
    int? totalCount,
    Object? aiSummary = _Undefined,
    Object? suggestions = _Undefined,
  }) {
    return SearchResult(
      captures: captures ?? this.captures.map((e0) => e0.copyWith()).toList(),
      totalCount: totalCount ?? this.totalCount,
      aiSummary: aiSummary is String? ? aiSummary : this.aiSummary,
      suggestions: suggestions is List<String>?
          ? suggestions
          : this.suggestions?.map((e0) => e0).toList(),
    );
  }
}

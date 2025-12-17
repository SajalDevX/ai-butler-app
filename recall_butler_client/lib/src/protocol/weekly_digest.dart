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

/// WeeklyDigest - AI-generated weekly summary
abstract class WeeklyDigest implements _i1.SerializableModel {
  WeeklyDigest._({
    required this.userId,
    required this.weekStart,
    required this.weekEnd,
    required this.totalCaptures,
    required this.capturesByCategory,
    required this.summary,
    required this.topTags,
    required this.generatedAt,
  });

  factory WeeklyDigest({
    required int userId,
    required DateTime weekStart,
    required DateTime weekEnd,
    required int totalCaptures,
    required String capturesByCategory,
    required String summary,
    required List<String> topTags,
    required DateTime generatedAt,
  }) = _WeeklyDigestImpl;

  factory WeeklyDigest.fromJson(Map<String, dynamic> jsonSerialization) {
    return WeeklyDigest(
      userId: jsonSerialization['userId'] as int,
      weekStart:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['weekStart']),
      weekEnd: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['weekEnd']),
      totalCaptures: jsonSerialization['totalCaptures'] as int,
      capturesByCategory: jsonSerialization['capturesByCategory'] as String,
      summary: jsonSerialization['summary'] as String,
      topTags: (jsonSerialization['topTags'] as List)
          .map((e) => e as String)
          .toList(),
      generatedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['generatedAt']),
    );
  }

  /// User ID
  int userId;

  /// Start of the week
  DateTime weekStart;

  /// End of the week
  DateTime weekEnd;

  /// Total captures this week
  int totalCaptures;

  /// Captures by category
  String capturesByCategory;

  /// AI-generated summary of the week
  String summary;

  /// Top tags of the week
  List<String> topTags;

  /// Generated timestamp
  DateTime generatedAt;

  /// Returns a shallow copy of this [WeeklyDigest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WeeklyDigest copyWith({
    int? userId,
    DateTime? weekStart,
    DateTime? weekEnd,
    int? totalCaptures,
    String? capturesByCategory,
    String? summary,
    List<String>? topTags,
    DateTime? generatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'weekStart': weekStart.toJson(),
      'weekEnd': weekEnd.toJson(),
      'totalCaptures': totalCaptures,
      'capturesByCategory': capturesByCategory,
      'summary': summary,
      'topTags': topTags.toJson(),
      'generatedAt': generatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _WeeklyDigestImpl extends WeeklyDigest {
  _WeeklyDigestImpl({
    required int userId,
    required DateTime weekStart,
    required DateTime weekEnd,
    required int totalCaptures,
    required String capturesByCategory,
    required String summary,
    required List<String> topTags,
    required DateTime generatedAt,
  }) : super._(
          userId: userId,
          weekStart: weekStart,
          weekEnd: weekEnd,
          totalCaptures: totalCaptures,
          capturesByCategory: capturesByCategory,
          summary: summary,
          topTags: topTags,
          generatedAt: generatedAt,
        );

  /// Returns a shallow copy of this [WeeklyDigest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  WeeklyDigest copyWith({
    int? userId,
    DateTime? weekStart,
    DateTime? weekEnd,
    int? totalCaptures,
    String? capturesByCategory,
    String? summary,
    List<String>? topTags,
    DateTime? generatedAt,
  }) {
    return WeeklyDigest(
      userId: userId ?? this.userId,
      weekStart: weekStart ?? this.weekStart,
      weekEnd: weekEnd ?? this.weekEnd,
      totalCaptures: totalCaptures ?? this.totalCaptures,
      capturesByCategory: capturesByCategory ?? this.capturesByCategory,
      summary: summary ?? this.summary,
      topTags: topTags ?? this.topTags.map((e0) => e0).toList(),
      generatedAt: generatedAt ?? this.generatedAt,
    );
  }
}

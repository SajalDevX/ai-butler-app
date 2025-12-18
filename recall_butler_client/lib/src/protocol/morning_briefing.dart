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

/// Morning briefing response model
abstract class MorningBriefing implements _i1.SerializableModel {
  MorningBriefing._({
    required this.greeting,
    required this.date,
    required this.todayActionCount,
    required this.overdueActionCount,
    required this.recentCaptureCount,
    this.aiSummary,
    required this.todayActionTitles,
    required this.overdueActionTitles,
  });

  factory MorningBriefing({
    required String greeting,
    required DateTime date,
    required int todayActionCount,
    required int overdueActionCount,
    required int recentCaptureCount,
    String? aiSummary,
    required List<String> todayActionTitles,
    required List<String> overdueActionTitles,
  }) = _MorningBriefingImpl;

  factory MorningBriefing.fromJson(Map<String, dynamic> jsonSerialization) {
    return MorningBriefing(
      greeting: jsonSerialization['greeting'] as String,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      todayActionCount: jsonSerialization['todayActionCount'] as int,
      overdueActionCount: jsonSerialization['overdueActionCount'] as int,
      recentCaptureCount: jsonSerialization['recentCaptureCount'] as int,
      aiSummary: jsonSerialization['aiSummary'] as String?,
      todayActionTitles: (jsonSerialization['todayActionTitles'] as List)
          .map((e) => e as String)
          .toList(),
      overdueActionTitles: (jsonSerialization['overdueActionTitles'] as List)
          .map((e) => e as String)
          .toList(),
    );
  }

  String greeting;

  DateTime date;

  int todayActionCount;

  int overdueActionCount;

  int recentCaptureCount;

  String? aiSummary;

  List<String> todayActionTitles;

  List<String> overdueActionTitles;

  /// Returns a shallow copy of this [MorningBriefing]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MorningBriefing copyWith({
    String? greeting,
    DateTime? date,
    int? todayActionCount,
    int? overdueActionCount,
    int? recentCaptureCount,
    String? aiSummary,
    List<String>? todayActionTitles,
    List<String>? overdueActionTitles,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'greeting': greeting,
      'date': date.toJson(),
      'todayActionCount': todayActionCount,
      'overdueActionCount': overdueActionCount,
      'recentCaptureCount': recentCaptureCount,
      if (aiSummary != null) 'aiSummary': aiSummary,
      'todayActionTitles': todayActionTitles.toJson(),
      'overdueActionTitles': overdueActionTitles.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MorningBriefingImpl extends MorningBriefing {
  _MorningBriefingImpl({
    required String greeting,
    required DateTime date,
    required int todayActionCount,
    required int overdueActionCount,
    required int recentCaptureCount,
    String? aiSummary,
    required List<String> todayActionTitles,
    required List<String> overdueActionTitles,
  }) : super._(
          greeting: greeting,
          date: date,
          todayActionCount: todayActionCount,
          overdueActionCount: overdueActionCount,
          recentCaptureCount: recentCaptureCount,
          aiSummary: aiSummary,
          todayActionTitles: todayActionTitles,
          overdueActionTitles: overdueActionTitles,
        );

  /// Returns a shallow copy of this [MorningBriefing]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MorningBriefing copyWith({
    String? greeting,
    DateTime? date,
    int? todayActionCount,
    int? overdueActionCount,
    int? recentCaptureCount,
    Object? aiSummary = _Undefined,
    List<String>? todayActionTitles,
    List<String>? overdueActionTitles,
  }) {
    return MorningBriefing(
      greeting: greeting ?? this.greeting,
      date: date ?? this.date,
      todayActionCount: todayActionCount ?? this.todayActionCount,
      overdueActionCount: overdueActionCount ?? this.overdueActionCount,
      recentCaptureCount: recentCaptureCount ?? this.recentCaptureCount,
      aiSummary: aiSummary is String? ? aiSummary : this.aiSummary,
      todayActionTitles:
          todayActionTitles ?? this.todayActionTitles.map((e0) => e0).toList(),
      overdueActionTitles: overdueActionTitles ??
          this.overdueActionTitles.map((e0) => e0).toList(),
    );
  }
}

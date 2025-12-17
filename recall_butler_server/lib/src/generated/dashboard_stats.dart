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

/// DashboardStats - Statistics for the smart dashboard
abstract class DashboardStats
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  DashboardStats._({
    required this.weeklyCaptures,
    required this.totalCaptures,
    required this.pendingActions,
    required this.completedActionsThisWeek,
    required this.capturesByCategory,
    required this.capturesByType,
    required this.topTags,
    required this.suggestions,
    required this.dailyCounts,
    required this.captureStreak,
  });

  factory DashboardStats({
    required int weeklyCaptures,
    required int totalCaptures,
    required int pendingActions,
    required int completedActionsThisWeek,
    required String capturesByCategory,
    required String capturesByType,
    required String topTags,
    required String suggestions,
    required String dailyCounts,
    required int captureStreak,
  }) = _DashboardStatsImpl;

  factory DashboardStats.fromJson(Map<String, dynamic> jsonSerialization) {
    return DashboardStats(
      weeklyCaptures: jsonSerialization['weeklyCaptures'] as int,
      totalCaptures: jsonSerialization['totalCaptures'] as int,
      pendingActions: jsonSerialization['pendingActions'] as int,
      completedActionsThisWeek:
          jsonSerialization['completedActionsThisWeek'] as int,
      capturesByCategory: jsonSerialization['capturesByCategory'] as String,
      capturesByType: jsonSerialization['capturesByType'] as String,
      topTags: jsonSerialization['topTags'] as String,
      suggestions: jsonSerialization['suggestions'] as String,
      dailyCounts: jsonSerialization['dailyCounts'] as String,
      captureStreak: jsonSerialization['captureStreak'] as int,
    );
  }

  /// Total captures this week
  int weeklyCaptures;

  /// Total captures all time
  int totalCaptures;

  /// Pending actions count
  int pendingActions;

  /// Completed actions this week
  int completedActionsThisWeek;

  /// Captures by category (JSON map)
  String capturesByCategory;

  /// Captures by type (JSON map)
  String capturesByType;

  /// Top tags this week (JSON array)
  String topTags;

  /// Butler suggestions (JSON array of suggestion objects)
  String suggestions;

  /// Daily capture counts for the week (JSON array)
  String dailyCounts;

  /// Current streak (consecutive days with captures)
  int captureStreak;

  /// Returns a shallow copy of this [DashboardStats]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DashboardStats copyWith({
    int? weeklyCaptures,
    int? totalCaptures,
    int? pendingActions,
    int? completedActionsThisWeek,
    String? capturesByCategory,
    String? capturesByType,
    String? topTags,
    String? suggestions,
    String? dailyCounts,
    int? captureStreak,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'weeklyCaptures': weeklyCaptures,
      'totalCaptures': totalCaptures,
      'pendingActions': pendingActions,
      'completedActionsThisWeek': completedActionsThisWeek,
      'capturesByCategory': capturesByCategory,
      'capturesByType': capturesByType,
      'topTags': topTags,
      'suggestions': suggestions,
      'dailyCounts': dailyCounts,
      'captureStreak': captureStreak,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'weeklyCaptures': weeklyCaptures,
      'totalCaptures': totalCaptures,
      'pendingActions': pendingActions,
      'completedActionsThisWeek': completedActionsThisWeek,
      'capturesByCategory': capturesByCategory,
      'capturesByType': capturesByType,
      'topTags': topTags,
      'suggestions': suggestions,
      'dailyCounts': dailyCounts,
      'captureStreak': captureStreak,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _DashboardStatsImpl extends DashboardStats {
  _DashboardStatsImpl({
    required int weeklyCaptures,
    required int totalCaptures,
    required int pendingActions,
    required int completedActionsThisWeek,
    required String capturesByCategory,
    required String capturesByType,
    required String topTags,
    required String suggestions,
    required String dailyCounts,
    required int captureStreak,
  }) : super._(
          weeklyCaptures: weeklyCaptures,
          totalCaptures: totalCaptures,
          pendingActions: pendingActions,
          completedActionsThisWeek: completedActionsThisWeek,
          capturesByCategory: capturesByCategory,
          capturesByType: capturesByType,
          topTags: topTags,
          suggestions: suggestions,
          dailyCounts: dailyCounts,
          captureStreak: captureStreak,
        );

  /// Returns a shallow copy of this [DashboardStats]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DashboardStats copyWith({
    int? weeklyCaptures,
    int? totalCaptures,
    int? pendingActions,
    int? completedActionsThisWeek,
    String? capturesByCategory,
    String? capturesByType,
    String? topTags,
    String? suggestions,
    String? dailyCounts,
    int? captureStreak,
  }) {
    return DashboardStats(
      weeklyCaptures: weeklyCaptures ?? this.weeklyCaptures,
      totalCaptures: totalCaptures ?? this.totalCaptures,
      pendingActions: pendingActions ?? this.pendingActions,
      completedActionsThisWeek:
          completedActionsThisWeek ?? this.completedActionsThisWeek,
      capturesByCategory: capturesByCategory ?? this.capturesByCategory,
      capturesByType: capturesByType ?? this.capturesByType,
      topTags: topTags ?? this.topTags,
      suggestions: suggestions ?? this.suggestions,
      dailyCounts: dailyCounts ?? this.dailyCounts,
      captureStreak: captureStreak ?? this.captureStreak,
    );
  }
}

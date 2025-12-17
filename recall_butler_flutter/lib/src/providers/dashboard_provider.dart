import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recall_butler_client/recall_butler_client.dart';
import 'client_provider.dart';

/// Parsed dashboard statistics
class ParsedDashboardStats {
  final int weeklyCaptures;
  final int totalCaptures;
  final int pendingActions;
  final int completedActionsThisWeek;
  final Map<String, int> capturesByCategory;
  final Map<String, int> capturesByType;
  final List<String> topTags;
  final List<Map<String, dynamic>> suggestions;
  final List<int> dailyCounts;
  final int captureStreak;

  const ParsedDashboardStats({
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

  factory ParsedDashboardStats.fromDashboardStats(DashboardStats stats) {
    return ParsedDashboardStats(
      weeklyCaptures: stats.weeklyCaptures,
      totalCaptures: stats.totalCaptures,
      pendingActions: stats.pendingActions,
      completedActionsThisWeek: stats.completedActionsThisWeek,
      capturesByCategory: _parseMap(stats.capturesByCategory),
      capturesByType: _parseMap(stats.capturesByType),
      topTags: _parseList(stats.topTags),
      suggestions: _parseSuggestions(stats.suggestions),
      dailyCounts: _parseDailyCounts(stats.dailyCounts),
      captureStreak: stats.captureStreak,
    );
  }

  static Map<String, int> _parseMap(String json) {
    try {
      final decoded = jsonDecode(json);
      return Map<String, int>.from(decoded.map((k, v) => MapEntry(k, v as int)));
    } catch (_) {
      return {};
    }
  }

  static List<String> _parseList(String json) {
    try {
      return List<String>.from(jsonDecode(json));
    } catch (_) {
      return [];
    }
  }

  static List<Map<String, dynamic>> _parseSuggestions(String json) {
    try {
      final decoded = jsonDecode(json);
      return List<Map<String, dynamic>>.from(decoded);
    } catch (_) {
      return [];
    }
  }

  static List<int> _parseDailyCounts(String json) {
    try {
      return List<int>.from(jsonDecode(json));
    } catch (_) {
      return List.filled(7, 0);
    }
  }
}

/// State for dashboard
class DashboardState {
  final ParsedDashboardStats? stats;
  final MorningBriefing? morningBriefing;
  final bool isLoading;
  final String? error;

  const DashboardState({
    this.stats,
    this.morningBriefing,
    this.isLoading = false,
    this.error,
  });

  DashboardState copyWith({
    ParsedDashboardStats? stats,
    MorningBriefing? morningBriefing,
    bool? isLoading,
    String? error,
  }) {
    return DashboardState(
      stats: stats ?? this.stats,
      morningBriefing: morningBriefing ?? this.morningBriefing,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier for dashboard state
class DashboardNotifier extends StateNotifier<DashboardState> {
  final Client _client;

  DashboardNotifier(this._client) : super(const DashboardState());

  /// Load dashboard stats
  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true);

    try {
      final stats = await _client.dashboard.getDashboardStats();
      final parsedStats = ParsedDashboardStats.fromDashboardStats(stats);

      state = state.copyWith(
        stats: parsedStats,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Load morning briefing
  Future<void> loadMorningBriefing() async {
    try {
      final briefing = await _client.dashboard.getMorningBriefing();
      state = state.copyWith(morningBriefing: briefing);
    } catch (e) {
      // Don't update error state for briefing failures
    }
  }

  /// Refresh all dashboard data
  Future<void> refresh() async {
    await Future.wait([
      loadDashboard(),
      loadMorningBriefing(),
    ]);
  }
}

/// Provider for dashboard
final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final client = ref.watch(clientProvider);
  return DashboardNotifier(client);
});

/// Provider for weekly digest
final weeklyDigestProvider = FutureProvider<WeeklyDigest>((ref) async {
  final client = ref.watch(clientProvider);
  return client.insight.getWeeklyDigest();
});

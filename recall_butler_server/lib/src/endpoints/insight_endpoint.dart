import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/gemini_service.dart';

class InsightEndpoint extends Endpoint {
  /// Get proactive insights for the user
  Future<List<Capture>> getProactiveInsights(Session session) async {
    final userId = await _getUserId(session);
    final now = DateTime.now();

    final insights = <Capture>[];

    // 1. Get stale reminders (captures marked as reminders, older than 3 days)
    final staleReminders = await Capture.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.isReminder.equals(true) &
          t.createdAt.between(
            now.subtract(const Duration(days: 30)),
            now.subtract(const Duration(days: 3)),
          ),
      limit: 5,
    );
    insights.addAll(staleReminders);

    // 2. Get recent captures that might need follow-up
    final recentCaptures = await Capture.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.category.inSet({'Work', 'Shopping', 'Health'}) &
          t.createdAt.between(
            now.subtract(const Duration(days: 7)),
            now.subtract(const Duration(days: 1)),
          ),
      limit: 5,
    );

    for (final capture in recentCaptures) {
      if (!insights.any((i) => i.id == capture.id)) {
        insights.add(capture);
      }
    }

    return insights.take(10).toList();
  }

  /// Get related captures for a given capture
  Future<List<Capture>> getRelatedCaptures(
    Session session,
    int captureId,
  ) async {
    final userId = await _getUserId(session);

    // Get the source capture
    final capture = await Capture.db.findFirstRow(
      session,
      where: (t) => t.id.equals(captureId) & t.userId.equals(userId),
    );

    if (capture == null) {
      return [];
    }

    // Get captures with same category
    final sameCategory = await Capture.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.category.equals(capture.category) &
          t.id.notEquals(captureId),
      limit: 5,
    );

    // Get captures with overlapping tags
    final relatedByTags = <Capture>[];
    if (capture.tags != null) {
      try {
        final tags = List<String>.from(jsonDecode(capture.tags!));
        for (final tag in tags.take(3)) {
          final tagged = await Capture.db.find(
            session,
            where: (t) =>
                t.userId.equals(userId) &
                t.tags.ilike('%$tag%') &
                t.id.notEquals(captureId),
            limit: 3,
          );
          relatedByTags.addAll(tagged);
        }
      } catch (_) {}
    }

    // Combine and deduplicate
    final related = <Capture>[];
    for (final c in [...sameCategory, ...relatedByTags]) {
      if (!related.any((r) => r.id == c.id)) {
        related.add(c);
      }
    }

    return related.take(10).toList();
  }

  /// Generate weekly digest
  Future<WeeklyDigest> getWeeklyDigest(Session session) async {
    final userId = await _getUserId(session);
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));

    // Get all captures from this week
    final captures = await Capture.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.createdAt.between(weekStart, weekEnd),
    );

    // Count by category
    final categoryCount = <String, int>{};
    for (final capture in captures) {
      categoryCount[capture.category] =
          (categoryCount[capture.category] ?? 0) + 1;
    }

    // Get top tags
    final allTags = <String>[];
    for (final capture in captures) {
      if (capture.tags != null) {
        try {
          allTags.addAll(List<String>.from(jsonDecode(capture.tags!)));
        } catch (_) {}
      }
    }

    final tagCount = <String, int>{};
    for (final tag in allTags) {
      tagCount[tag] = (tagCount[tag] ?? 0) + 1;
    }

    final topTags = tagCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Generate AI summary
    final summary = await GeminiService.generateWeeklyDigest(session, captures);

    return WeeklyDigest(
      userId: userId,
      weekStart: weekStart,
      weekEnd: weekEnd,
      totalCaptures: captures.length,
      capturesByCategory: jsonEncode(categoryCount),
      summary: summary,
      topTags: topTags.take(5).map((e) => e.key).toList(),
      generatedAt: now,
    );
  }

  /// Get capture statistics
  Future<Map<String, dynamic>> getStatistics(Session session) async {
    final userId = await _getUserId(session);
    final now = DateTime.now();

    // Total captures
    final allCaptures = await Capture.db.find(
      session,
      where: (t) => t.userId.equals(userId),
    );

    // This week's captures
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekCaptures = allCaptures
        .where((c) => c.createdAt.isAfter(weekStart))
        .length;

    // By type
    final byType = <String, int>{};
    for (final c in allCaptures) {
      byType[c.type] = (byType[c.type] ?? 0) + 1;
    }

    // By category
    final byCategory = <String, int>{};
    for (final c in allCaptures) {
      byCategory[c.category] = (byCategory[c.category] ?? 0) + 1;
    }

    return {
      'totalCaptures': allCaptures.length,
      'weekCaptures': weekCaptures,
      'byType': byType,
      'byCategory': byCategory,
      'remindersCount': allCaptures.where((c) => c.isReminder).length,
    };
  }

  /// Dismiss a proactive insight
  Future<void> dismissInsight(Session session, int captureId) async {
    final userId = await _getUserId(session);

    final capture = await Capture.db.findFirstRow(
      session,
      where: (t) => t.id.equals(captureId) & t.userId.equals(userId),
    );

    if (capture != null && capture.isReminder) {
      capture.isReminder = false;
      await Capture.db.updateRow(session, capture);
    }
  }

  /// Helper to get user ID from session
  Future<int> _getUserId(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      return 1; // Demo mode
    }
    return authInfo.userId;
  }
}

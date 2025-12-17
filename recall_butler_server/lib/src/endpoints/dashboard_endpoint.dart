import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/gemini_service.dart';

class DashboardEndpoint extends Endpoint {
  /// Get comprehensive dashboard statistics
  Future<DashboardStats> getDashboardStats(Session session) async {
    final userId = await _getUserId(session);
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeek = DateTime(weekStart.year, weekStart.month, weekStart.day);

    // Get captures
    final allCaptures = await Capture.db.find(
      session,
      where: (t) => t.userId.equals(userId),
    );

    final weeklyCaptures = allCaptures
        .where((c) => c.createdAt.isAfter(startOfWeek))
        .toList();

    // Get actions
    final allActions = await Action.db.find(
      session,
      where: (t) => t.userId.equals(userId),
    );

    final pendingActions = allActions.where((a) => !a.isCompleted).length;
    final completedThisWeek = allActions
        .where((a) =>
            a.isCompleted &&
            a.completedAt != null &&
            a.completedAt!.isAfter(startOfWeek))
        .length;

    // Count captures by category
    final categoryCount = <String, int>{};
    for (final c in allCaptures) {
      categoryCount[c.category] = (categoryCount[c.category] ?? 0) + 1;
    }

    // Count captures by type
    final typeCount = <String, int>{};
    for (final c in allCaptures) {
      typeCount[c.type] = (typeCount[c.type] ?? 0) + 1;
    }

    // Get top tags from this week
    final allTags = <String>[];
    for (final c in weeklyCaptures) {
      if (c.tags != null) {
        try {
          allTags.addAll(List<String>.from(jsonDecode(c.tags!)));
        } catch (_) {}
      }
    }
    final tagCount = <String, int>{};
    for (final tag in allTags) {
      tagCount[tag] = (tagCount[tag] ?? 0) + 1;
    }
    final topTags = tagCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Calculate daily counts for the week (for chart)
    final dailyCounts = <int>[];
    for (int i = 0; i < 7; i++) {
      final day = startOfWeek.add(Duration(days: i));
      final dayEnd = day.add(const Duration(days: 1));
      final count = allCaptures
          .where((c) => c.createdAt.isAfter(day) && c.createdAt.isBefore(dayEnd))
          .length;
      dailyCounts.add(count);
    }

    // Calculate capture streak
    int streak = 0;
    var checkDate = DateTime(now.year, now.month, now.day);
    while (true) {
      final dayStart = checkDate;
      final dayEnd = checkDate.add(const Duration(days: 1));
      final hasCapture = allCaptures.any(
          (c) => c.createdAt.isAfter(dayStart) && c.createdAt.isBefore(dayEnd));
      if (hasCapture) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    // Generate butler suggestions
    final suggestions = await _generateSuggestions(
      session,
      allCaptures,
      allActions,
      weeklyCaptures,
    );

    return DashboardStats(
      weeklyCaptures: weeklyCaptures.length,
      totalCaptures: allCaptures.length,
      pendingActions: pendingActions,
      completedActionsThisWeek: completedThisWeek,
      capturesByCategory: jsonEncode(categoryCount),
      capturesByType: jsonEncode(typeCount),
      topTags: jsonEncode(topTags.take(10).map((e) => e.key).toList()),
      suggestions: jsonEncode(suggestions),
      dailyCounts: jsonEncode(dailyCounts),
      captureStreak: streak,
    );
  }

  /// Generate AI-powered butler suggestions
  Future<List<Map<String, dynamic>>> _generateSuggestions(
    Session session,
    List<Capture> allCaptures,
    List<Action> allActions,
    List<Capture> weeklyCaptures,
  ) async {
    final suggestions = <Map<String, dynamic>>[];
    final now = DateTime.now();

    // Check for overdue actions
    final overdueActions = allActions.where((a) =>
        !a.isCompleted && a.dueAt != null && a.dueAt!.isBefore(now)).toList();
    if (overdueActions.isNotEmpty) {
      suggestions.add({
        'type': 'warning',
        'icon': 'warning',
        'title': 'Overdue Tasks',
        'message': 'You have ${overdueActions.length} overdue task${overdueActions.length > 1 ? 's' : ''}. Would you like to review them?',
        'action': 'view_overdue',
      });
    }

    // Check for stale captures (reminders not actioned)
    final staleReminders = allCaptures.where((c) =>
        c.isReminder &&
        c.createdAt.isBefore(now.subtract(const Duration(days: 3)))).toList();
    if (staleReminders.isNotEmpty) {
      suggestions.add({
        'type': 'reminder',
        'icon': 'schedule',
        'title': 'Stale Reminders',
        'message': '${staleReminders.length} reminder${staleReminders.length > 1 ? 's' : ''} from over 3 days ago need attention.',
        'action': 'view_reminders',
      });
    }

    // Suggest capture if no captures today
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayCaptures = allCaptures.where(
        (c) => c.createdAt.isAfter(todayStart)).toList();
    if (todayCaptures.isEmpty && allCaptures.isNotEmpty) {
      suggestions.add({
        'type': 'tip',
        'icon': 'add_a_photo',
        'title': 'Daily Capture',
        'message': 'No captures yet today. Keep your streak going!',
        'action': 'new_capture',
      });
    }

    // Check for high-priority pending actions
    final highPriorityActions = allActions.where((a) =>
        !a.isCompleted && a.priority == 'high').toList();
    if (highPriorityActions.isNotEmpty) {
      suggestions.add({
        'type': 'urgent',
        'icon': 'priority_high',
        'title': 'High Priority',
        'message': '${highPriorityActions.length} high-priority task${highPriorityActions.length > 1 ? 's' : ''} need your attention.',
        'action': 'view_high_priority',
      });
    }

    // Suggest weekly review if it's Sunday/Monday
    if (now.weekday == DateTime.sunday || now.weekday == DateTime.monday) {
      if (weeklyCaptures.length > 5) {
        suggestions.add({
          'type': 'insight',
          'icon': 'insights',
          'title': 'Weekly Review',
          'message': 'You captured ${weeklyCaptures.length} items this week. Check your weekly digest!',
          'action': 'view_digest',
        });
      }
    }

    // Productivity tip based on patterns
    if (allCaptures.length > 10) {
      final workCaptures = allCaptures.where((c) => c.category == 'Work').length;
      final personalCaptures = allCaptures.where((c) => c.category == 'Personal').length;

      if (workCaptures > personalCaptures * 2) {
        suggestions.add({
          'type': 'balance',
          'icon': 'balance',
          'title': 'Work-Life Balance',
          'message': 'Your captures are mostly work-related. Remember to capture personal moments too!',
          'action': null,
        });
      }
    }

    return suggestions.take(5).toList();
  }

  /// Get morning briefing content
  Future<MorningBriefing> getMorningBriefing(Session session) async {
    final userId = await _getUserId(session);
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    // Get today's actions
    final todayActions = await Action.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.isCompleted.equals(false) &
          t.dueAt.notEquals(null) &
          t.dueAt.between(todayStart, todayEnd),
    );

    // Get overdue actions
    final longAgo = DateTime(2000, 1, 1);
    final overdueActions = await Action.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.isCompleted.equals(false) &
          t.dueAt.notEquals(null) &
          t.dueAt.between(longAgo, todayStart),
    );

    // Get recent captures (last 24 hours)
    final recentCaptures = await Capture.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.createdAt.between(now.subtract(const Duration(hours: 24)), now),
      limit: 5,
    );

    // Generate greeting based on time
    String greeting;
    final hour = now.hour;
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    // Generate AI summary if there's enough content
    String? aiSummary;
    if (todayActions.isNotEmpty || recentCaptures.isNotEmpty) {
      try {
        aiSummary = await GeminiService.generateMorningBriefing(
          session,
          todayActions,
          recentCaptures,
        );
      } catch (e) {
        session.log('Failed to generate morning briefing: $e');
      }
    }

    return MorningBriefing(
      greeting: greeting,
      date: now,
      todayActionCount: todayActions.length,
      overdueActionCount: overdueActions.length,
      recentCaptureCount: recentCaptures.length,
      aiSummary: aiSummary,
      todayActionTitles: todayActions.map((a) => a.title).toList(),
      overdueActionTitles: overdueActions.map((a) => a.title).toList(),
    );
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

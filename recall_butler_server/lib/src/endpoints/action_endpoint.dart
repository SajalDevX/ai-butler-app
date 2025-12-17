import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ActionEndpoint extends Endpoint {
  /// Create a new action
  Future<Action> createAction(
    Session session,
    String type,
    String title, {
    String? notes,
    DateTime? dueAt,
    String? priority,
    int? captureId,
  }) async {
    final userId = await _getUserId(session);

    final action = Action(
      userId: userId,
      captureId: captureId,
      type: type,
      title: title,
      notes: notes,
      dueAt: dueAt,
      isCompleted: false,
      priority: priority ?? 'medium',
      createdAt: DateTime.now(),
    );

    return await Action.db.insertRow(session, action);
  }

  /// Create multiple actions from AI extraction (used when processing captures)
  Future<List<Action>> createActionsFromCapture(
    Session session,
    int captureId,
    List<Map<String, dynamic>> actionItems,
  ) async {
    final userId = await _getUserId(session);
    final actions = <Action>[];

    for (final item in actionItems) {
      final action = Action(
        userId: userId,
        captureId: captureId,
        type: item['type'] ?? 'task',
        title: item['title'] ?? '',
        notes: item['notes'],
        dueAt: item['dueAt'] != null ? DateTime.tryParse(item['dueAt']) : null,
        isCompleted: false,
        priority: item['priority'] ?? 'medium',
        createdAt: DateTime.now(),
      );

      if (action.title.isNotEmpty) {
        final inserted = await Action.db.insertRow(session, action);
        actions.add(inserted);
      }
    }

    return actions;
  }

  /// Get all actions for the current user
  Future<List<Action>> getActions(
    Session session, {
    int? limit,
    int? offset,
    String? type,
    bool? isCompleted,
    bool? dueSoon,
  }) async {
    final userId = await _getUserId(session);

    var whereClause = Action.t.userId.equals(userId);

    if (type != null) {
      whereClause = whereClause & Action.t.type.equals(type);
    }

    if (isCompleted != null) {
      whereClause = whereClause & Action.t.isCompleted.equals(isCompleted);
    }

    // Get actions due within the next 24 hours
    if (dueSoon == true) {
      final now = DateTime.now();
      final tomorrow = now.add(const Duration(hours: 24));
      whereClause = whereClause &
          Action.t.dueAt.notEquals(null) &
          Action.t.dueAt.between(now, tomorrow);
    }

    return await Action.db.find(
      session,
      where: (t) => whereClause,
      orderBy: (t) => t.createdAt,
      limit: limit ?? 50,
      offset: offset ?? 0,
    );
  }

  /// Get pending actions (not completed)
  Future<List<Action>> getPendingActions(Session session) async {
    final userId = await _getUserId(session);

    return await Action.db.find(
      session,
      where: (t) => t.userId.equals(userId) & t.isCompleted.equals(false),
      orderBy: (t) => t.createdAt,
    );
  }

  /// Get actions due today
  Future<List<Action>> getTodayActions(Session session) async {
    final userId = await _getUserId(session);
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return await Action.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.isCompleted.equals(false) &
          t.dueAt.notEquals(null) &
          t.dueAt.between(startOfDay, endOfDay),
      orderBy: (t) => t.dueAt,
    );
  }

  /// Get overdue actions
  Future<List<Action>> getOverdueActions(Session session) async {
    final userId = await _getUserId(session);
    final now = DateTime.now();
    final longAgo = DateTime(2000, 1, 1); // Far past date for range

    return await Action.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.isCompleted.equals(false) &
          t.dueAt.notEquals(null) &
          t.dueAt.between(longAgo, now),
      orderBy: (t) => t.dueAt,
    );
  }

  /// Get a single action by ID
  Future<Action?> getAction(Session session, int actionId) async {
    final userId = await _getUserId(session);

    return await Action.db.findFirstRow(
      session,
      where: (t) => t.id.equals(actionId) & t.userId.equals(userId),
    );
  }

  /// Update an action
  Future<Action?> updateAction(
    Session session,
    int actionId, {
    String? title,
    String? notes,
    DateTime? dueAt,
    String? priority,
    String? type,
  }) async {
    final action = await getAction(session, actionId);
    if (action == null) return null;

    if (title != null) action.title = title;
    if (notes != null) action.notes = notes;
    if (dueAt != null) action.dueAt = dueAt;
    if (priority != null) action.priority = priority;
    if (type != null) action.type = type;

    return await Action.db.updateRow(session, action);
  }

  /// Mark an action as completed
  Future<Action?> completeAction(Session session, int actionId) async {
    final action = await getAction(session, actionId);
    if (action == null) return null;

    action.isCompleted = true;
    action.completedAt = DateTime.now();

    return await Action.db.updateRow(session, action);
  }

  /// Mark an action as not completed (undo)
  Future<Action?> uncompleteAction(Session session, int actionId) async {
    final action = await getAction(session, actionId);
    if (action == null) return null;

    action.isCompleted = false;
    action.completedAt = null;

    return await Action.db.updateRow(session, action);
  }

  /// Delete an action
  Future<bool> deleteAction(Session session, int actionId) async {
    final action = await getAction(session, actionId);
    if (action == null) return false;

    await Action.db.deleteRow(session, action);
    return true;
  }

  /// Get action statistics for dashboard
  Future<Map<String, dynamic>> getActionStats(Session session) async {
    final userId = await _getUserId(session);
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeek = DateTime(weekStart.year, weekStart.month, weekStart.day);

    // Get all actions for the user
    final allActions = await Action.db.find(
      session,
      where: (t) => t.userId.equals(userId),
    );

    final pendingCount =
        allActions.where((a) => !a.isCompleted).length;
    final completedThisWeek = allActions
        .where((a) =>
            a.isCompleted &&
            a.completedAt != null &&
            a.completedAt!.isAfter(startOfWeek))
        .length;
    final overdueCount = allActions
        .where((a) =>
            !a.isCompleted && a.dueAt != null && a.dueAt!.isBefore(now))
        .length;
    final dueTodayCount = allActions
        .where((a) {
          if (a.isCompleted || a.dueAt == null) return false;
          final dueDate = a.dueAt!;
          return dueDate.year == now.year &&
              dueDate.month == now.month &&
              dueDate.day == now.day;
        })
        .length;

    // Count by type
    final byType = <String, int>{};
    for (final action in allActions.where((a) => !a.isCompleted)) {
      byType[action.type] = (byType[action.type] ?? 0) + 1;
    }

    return {
      'pendingCount': pendingCount,
      'completedThisWeek': completedThisWeek,
      'overdueCount': overdueCount,
      'dueTodayCount': dueTodayCount,
      'byType': byType,
    };
  }

  /// Get actions for a specific capture
  Future<List<Action>> getActionsForCapture(
    Session session,
    int captureId,
  ) async {
    final userId = await _getUserId(session);

    return await Action.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) & t.captureId.equals(captureId),
      orderBy: (t) => t.createdAt,
    );
  }

  /// Helper to get user ID from session
  Future<int> _getUserId(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      return 1; // Default user ID for demo
    }
    return authInfo.userId;
  }
}

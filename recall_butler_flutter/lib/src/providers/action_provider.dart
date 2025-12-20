import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recall_butler_client/recall_butler_client.dart';
import 'client_provider.dart';

/// State for actions
class ActionsState {
  final List<Action> actions;
  final List<Action> todayActions;
  final List<Action> overdueActions;
  final bool isLoading;
  final String? error;
  final String? selectedType;

  const ActionsState({
    this.actions = const [],
    this.todayActions = const [],
    this.overdueActions = const [],
    this.isLoading = false,
    this.error,
    this.selectedType,
  });

  /// Get high priority actions
  List<Action> get highPriorityActions {
    return actions.where((action) => action.priority == 'high').toList();
  }

  /// Get upcoming actions (not today, not overdue)
  List<Action> get upcomingActions {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    return actions.where((action) {
      if (action.dueAt == null) return true;
      // Not overdue and not today
      return action.dueAt!.isAfter(tomorrow);
    }).toList();
  }

  ActionsState copyWith({
    List<Action>? actions,
    List<Action>? todayActions,
    List<Action>? overdueActions,
    bool? isLoading,
    String? error,
    String? selectedType,
  }) {
    return ActionsState(
      actions: actions ?? this.actions,
      todayActions: todayActions ?? this.todayActions,
      overdueActions: overdueActions ?? this.overdueActions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedType: selectedType ?? this.selectedType,
    );
  }
}

/// Notifier for actions state
class ActionsNotifier extends StateNotifier<ActionsState> {
  final Client _client;

  ActionsNotifier(this._client) : super(const ActionsState());

  /// Load all pending actions
  Future<void> loadActions() async {
    state = state.copyWith(isLoading: true);

    try {
      final actions = await _client.action.getPendingActions();
      final todayActions = await _client.action.getTodayActions();
      final overdueActions = await _client.action.getOverdueActions();

      state = state.copyWith(
        actions: actions,
        todayActions: todayActions,
        overdueActions: overdueActions,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Create a new action
  Future<Action?> createAction({
    required String type,
    required String title,
    String? notes,
    DateTime? dueAt,
    String? priority,
    int? captureId,
  }) async {
    try {
      final action = await _client.action.createAction(
        type,
        title,
        notes: notes,
        dueAt: dueAt,
        priority: priority,
        captureId: captureId,
      );

      // Add to the list
      state = state.copyWith(
        actions: [action, ...state.actions],
      );

      return action;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  /// Complete an action
  Future<bool> completeAction(int actionId) async {
    try {
      await _client.action.completeAction(actionId);

      // Remove from pending lists
      state = state.copyWith(
        actions: state.actions.where((a) => a.id != actionId).toList(),
        todayActions: state.todayActions.where((a) => a.id != actionId).toList(),
        overdueActions: state.overdueActions.where((a) => a.id != actionId).toList(),
      );

      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Uncomplete an action (undo)
  Future<bool> uncompleteAction(int actionId) async {
    try {
      final action = await _client.action.uncompleteAction(actionId);
      if (action != null) {
        state = state.copyWith(
          actions: [action, ...state.actions],
        );
      }
      return action != null;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Delete an action
  Future<bool> deleteAction(int actionId) async {
    try {
      final success = await _client.action.deleteAction(actionId);
      if (success) {
        state = state.copyWith(
          actions: state.actions.where((a) => a.id != actionId).toList(),
          todayActions: state.todayActions.where((a) => a.id != actionId).toList(),
          overdueActions: state.overdueActions.where((a) => a.id != actionId).toList(),
        );
      }
      return success;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Update filter
  void setType(String? type) {
    state = state.copyWith(selectedType: type);
  }
}

/// Provider for actions
final actionsProvider =
    StateNotifierProvider<ActionsNotifier, ActionsState>((ref) {
  final client = ref.watch(clientProvider);
  return ActionsNotifier(client);
});

/// Provider for action statistics
final actionStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final client = ref.watch(clientProvider);
  return client.action.getActionStats();
});

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../providers/action_provider.dart';
import '../../theme/colors.dart';

class ActionsScreen extends ConsumerStatefulWidget {
  const ActionsScreen({super.key});

  @override
  ConsumerState<ActionsScreen> createState() => _ActionsScreenState();
}

class _ActionsScreenState extends ConsumerState<ActionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    Future.microtask(() {
      ref.read(actionsProvider.notifier).loadActions();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final actionsState = ref.watch(actionsProvider);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Iconsax.task_square,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Actions & Reminders',
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Manage your tasks and reminders',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              title: const Text('Actions'),
              centerTitle: false,
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                color: AppColors.background,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 3,
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Iconsax.danger, size: 18),
                          const SizedBox(width: 6),
                          const Text('High Priority'),
                          if (actionsState.highPriorityActions.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${actionsState.highPriorityActions.length}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Iconsax.warning_2, size: 18),
                          const SizedBox(width: 6),
                          const Text('Overdue'),
                          if (actionsState.overdueActions.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.warning,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${actionsState.overdueActions.length}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Iconsax.calendar, size: 18),
                          const SizedBox(width: 6),
                          const Text('Today'),
                          if (actionsState.todayActions.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${actionsState.todayActions.length}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Iconsax.archive_book, size: 18),
                          const SizedBox(width: 6),
                          const Text('All'),
                          if (actionsState.upcomingActions.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Text(
                              '${actionsState.upcomingActions.length}',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _ActionsList(
              actions: actionsState.highPriorityActions,
              emptyMessage: 'No high priority actions',
              emptyIcon: Iconsax.tick_circle,
              isLoading: actionsState.isLoading,
              onComplete: _completeAction,
            ),
            _ActionsList(
              actions: actionsState.overdueActions,
              emptyMessage: 'No overdue actions',
              emptyIcon: Iconsax.tick_circle,
              isLoading: actionsState.isLoading,
              onComplete: _completeAction,
              isOverdue: true,
            ),
            _ActionsList(
              actions: actionsState.todayActions,
              emptyMessage: 'No actions for today',
              emptyIcon: Iconsax.calendar_tick,
              isLoading: actionsState.isLoading,
              onComplete: _completeAction,
            ),
            _ActionsList(
              actions: actionsState.upcomingActions,
              emptyMessage: 'No upcoming actions',
              emptyIcon: Iconsax.tick_circle,
              isLoading: actionsState.isLoading,
              onComplete: _completeAction,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _completeAction(int actionId) async {
    final success = await ref.read(actionsProvider.notifier).completeAction(actionId);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Action completed!'),
          backgroundColor: AppColors.success,
          action: SnackBarAction(
            label: 'Undo',
            textColor: Colors.white,
            onPressed: () {
              ref.read(actionsProvider.notifier).uncompleteAction(actionId);
            },
          ),
        ),
      );
    }
  }
}

class _ActionsList extends StatelessWidget {
  final List<dynamic> actions;
  final String emptyMessage;
  final IconData emptyIcon;
  final bool isLoading;
  final Function(int) onComplete;
  final bool isOverdue;

  const _ActionsList({
    required this.actions,
    required this.emptyMessage,
    required this.emptyIcon,
    required this.isLoading,
    required this.onComplete,
    this.isOverdue = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && actions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (actions.isEmpty) {
      return _EmptyState(
        message: emptyMessage,
        icon: emptyIcon,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Refresh will be handled by provider
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          return _ActionCard(
            action: action,
            isOverdue: isOverdue || _isOverdue(action),
            onComplete: () => onComplete(action.id!),
            onTap: () => _showActionDetail(context, action),
          ).animate().fadeIn(duration: 300.ms, delay: (index * 50).ms);
        },
      ),
    );
  }

  bool _isOverdue(dynamic action) {
    if (action.dueAt == null) return false;
    return action.dueAt!.isBefore(DateTime.now());
  }

  void _showActionDetail(BuildContext context, dynamic action) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ActionDetailSheet(action: action),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final dynamic action;
  final bool isOverdue;
  final VoidCallback onComplete;
  final VoidCallback onTap;

  const _ActionCard({
    required this.action,
    required this.isOverdue,
    required this.onComplete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isHighPriority = action.priority == 'high';
    final borderColor = isOverdue
        ? AppColors.error
        : isHighPriority
            ? AppColors.warning
            : Colors.transparent;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isOverdue
          ? AppColors.error.withOpacity(0.05)
          : isHighPriority
              ? AppColors.warning.withOpacity(0.05)
              : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: borderColor.withOpacity(0.3),
          width: borderColor == Colors.transparent ? 0 : 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Priority indicator
              Container(
                width: 4,
                height: 60,
                decoration: BoxDecoration(
                  color: _getPriorityColor(),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      action.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: isOverdue ? AppColors.error : null,
                      ),
                    ),
                    if (action.notes != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        action.notes!,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),

                    // Tags
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        if (action.dueAt != null)
                          _Tag(
                            icon: Iconsax.clock,
                            label: _formatDueDate(action.dueAt!),
                            color: isOverdue ? AppColors.error : AppColors.primary,
                          ),
                        _Tag(
                          icon: Iconsax.category,
                          label: action.type,
                          color: AppColors.secondary,
                        ),
                        _Tag(
                          icon: _getPriorityIcon(),
                          label: action.priority.toUpperCase(),
                          color: _getPriorityColor(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Complete button
              IconButton(
                icon: Icon(
                  Iconsax.tick_circle,
                  color: AppColors.success,
                  size: 28,
                ),
                onPressed: onComplete,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor() {
    switch (action.priority) {
      case 'high':
        return AppColors.error;
      case 'medium':
        return AppColors.warning;
      default:
        return AppColors.success;
    }
  }

  IconData _getPriorityIcon() {
    switch (action.priority) {
      case 'high':
        return Iconsax.danger;
      case 'medium':
        return Iconsax.warning_2;
      default:
        return Iconsax.flag;
    }
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now);

    if (diff.isNegative) return 'Overdue';
    if (diff.inDays == 0) {
      if (diff.inHours == 0) return '${diff.inMinutes}m';
      return '${diff.inHours}h';
    }
    if (diff.inDays == 1) return 'Tomorrow';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return timeago.format(date);
  }
}

class _Tag extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _Tag({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const _EmptyState({
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: AppColors.success.withOpacity(0.5),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: 2.seconds,
                ),
            const SizedBox(height: 24),
            Text(
              'All Clear!',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionDetailSheet extends StatelessWidget {
  final dynamic action;

  const _ActionDetailSheet({required this.action});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Iconsax.task_square, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Action Details',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Iconsax.close_circle),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Title
                    Text(
                      action.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Details
                    if (action.notes != null) ...[
                      _DetailSection(
                        title: 'Notes',
                        child: Text(
                          action.notes!,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    _DetailSection(
                      title: 'Priority',
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _getPriorityColor(action.priority).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _getPriorityIcon(action.priority),
                              color: _getPriorityColor(action.priority),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              action.priority.toUpperCase(),
                              style: TextStyle(
                                color: _getPriorityColor(action.priority),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (action.dueAt != null) ...[
                      _DetailSection(
                        title: 'Due Date',
                        child: Text(
                          timeago.format(action.dueAt!),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    _DetailSection(
                      title: 'Type',
                      child: Text(
                        action.type,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _DetailSection(
                      title: 'Created',
                      child: Text(
                        timeago.format(action.createdAt),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return AppColors.error;
      case 'medium':
        return AppColors.warning;
      default:
        return AppColors.success;
    }
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority) {
      case 'high':
        return Iconsax.danger;
      case 'medium':
        return Iconsax.warning_2;
      default:
        return Iconsax.flag;
    }
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _DetailSection({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

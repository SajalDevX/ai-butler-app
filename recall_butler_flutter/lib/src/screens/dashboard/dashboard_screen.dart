import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../providers/dashboard_provider.dart';
import '../../providers/action_provider.dart';
import '../../providers/google_auth_provider.dart';
import '../../theme/colors.dart';
import '../actions/actions_screen.dart';
import '../alerts/critical_alerts_screen.dart';
import '../emails/pending_replies_screen.dart';
import '../reminders/reminders_screen.dart';
import '../daily_alerts/daily_alerts_screen.dart';
import '../high_priority/high_priority_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(dashboardProvider.notifier).refresh();
      ref.read(actionsProvider.notifier).loadActions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardProvider);
    final actionsState = ref.watch(actionsProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(dashboardProvider.notifier).refresh();
          await ref.read(actionsProvider.notifier).loadActions();
        },
        child: CustomScrollView(
          slivers: [
            // App Bar with greeting
            SliverAppBar(
              expandedHeight: 160,
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
                          Text(
                            _getGreeting(),
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            dashboardState.morningBriefing?.aiSummary ??
                                'Your AI butler is ready to help.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                title: const Text('Dashboard'),
                centerTitle: false,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Iconsax.danger),
                  onPressed: _openCriticalAlerts,
                  tooltip: 'Critical Alerts',
                ),
              ],
            ),

            // Stats Grid
            if (dashboardState.stats != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'This Week',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _StatsGrid(stats: dashboardState.stats!),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
              ),

            // Weekly Activity Chart
            if (dashboardState.stats != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _WeeklyChart(dailyCounts: dashboardState.stats!.dailyCounts),
                ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
              ),

            // Pending Replies Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _PendingRepliesWidget(
                  onTap: _openPendingReplies,
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 150.ms),
            ),

            // Butler Suggestions
            if (dashboardState.stats != null &&
                dashboardState.stats!.suggestions.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Iconsax.magic_star, size: 20, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Butler Suggestions',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...dashboardState.stats!.suggestions.map(
                        (suggestion) => _SuggestionCard(
                          suggestion: suggestion,
                          onTap: () => _handleSuggestionTap(suggestion),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
              ),

            // Today's Actions
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Iconsax.task_square, size: 20, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(
                              'Today\'s Actions',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        if (actionsState.todayActions.isNotEmpty)
                          TextButton(
                            onPressed: () => _showAllActions(),
                            child: const Text('See All'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (actionsState.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (actionsState.todayActions.isEmpty &&
                        actionsState.overdueActions.isEmpty)
                      _EmptyActionsCard()
                    else
                      Column(
                        children: [
                          // Overdue actions first
                          if (actionsState.overdueActions.isNotEmpty) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Iconsax.warning_2, size: 16, color: AppColors.error),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${actionsState.overdueActions.length} Overdue',
                                    style: TextStyle(
                                      color: AppColors.error,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...actionsState.overdueActions.take(3).map(
                              (action) => _ActionCard(
                                action: action,
                                isOverdue: true,
                                onComplete: () => _completeAction(action.id!),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                          // Today's actions
                          ...actionsState.todayActions.take(5).map(
                            (action) => _ActionCard(
                              action: action,
                              onComplete: () => _completeAction(action.id!),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
            ),

            // Top Tags
            if (dashboardState.stats != null &&
                dashboardState.stats!.topTags.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Iconsax.hashtag, size: 20, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Top Tags This Week',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: dashboardState.stats!.topTags.map((tag) {
                          return Chip(
                            label: Text('#$tag'),
                            backgroundColor: AppColors.surface,
                            labelStyle: TextStyle(color: AppColors.primary),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
              ),

            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  void _openCriticalAlerts() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CriticalAlertsScreen(),
      ),
    );
  }

  void _openPendingReplies() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PendingRepliesScreen(),
      ),
    );
  }

  void _handleSuggestionTap(Map<String, dynamic> suggestion) {
    final action = suggestion['action'];
    if (action == null) return;

    switch (action) {
      case 'view_overdue':
        _showAllActions();
        break;
      case 'view_high_priority':
        _showHighPriority();
        break;
      case 'view_reminders':
        _showReminders();
        break;
      case 'new_capture':
        // Trigger capture
        break;
      case 'view_digest':
        _showWeeklyDigest();
        break;
      case 'view_daily_alerts':
        _showDailyAlerts();
        break;
    }
  }

  void _showAllActions() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ActionsScreen(),
      ),
    );
  }

  void _showReminders() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RemindersScreen(),
      ),
    );
  }

  void _showDailyAlerts() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const DailyAlertsScreen(),
      ),
    );
  }

  void _showHighPriority() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const HighPriorityScreen(),
      ),
    );
  }

  void _showWeeklyDigest() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _WeeklyDigestSheet(),
    );
  }

  Future<void> _completeAction(int actionId) async {
    final success = await ref.read(actionsProvider.notifier).completeAction(actionId);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Action completed!'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              ref.read(actionsProvider.notifier).uncompleteAction(actionId);
            },
          ),
        ),
      );
    }
  }
}

class _StatsGrid extends StatelessWidget {
  final ParsedDashboardStats stats;

  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _StatCard(
          icon: Iconsax.camera,
          label: 'Captures',
          value: stats.weeklyCaptures.toString(),
          subtitle: '${stats.totalCaptures} total',
          color: AppColors.primary,
        ),
        _StatCard(
          icon: Iconsax.task_square,
          label: 'Pending',
          value: stats.pendingActions.toString(),
          subtitle: '${stats.completedActionsThisWeek} done this week',
          color: AppColors.warning,
        ),
        _StatCard(
          icon: Iconsax.chart,
          label: 'Streak',
          value: '${stats.captureStreak}',
          subtitle: stats.captureStreak > 0 ? 'days' : 'Start today!',
          color: AppColors.success,
        ),
        _StatCard(
          icon: Iconsax.category,
          label: 'Top Category',
          value: _getTopCategory(),
          subtitle: '${_getTopCategoryCount()} captures',
          color: AppColors.secondary,
        ),
      ],
    );
  }

  String _getTopCategory() {
    if (stats.capturesByCategory.isEmpty) return 'None';
    final sorted = stats.capturesByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }

  int _getTopCategoryCount() {
    if (stats.capturesByCategory.isEmpty) return 0;
    final sorted = stats.capturesByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.value;
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String subtitle;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  final List<int> dailyCounts;

  const _WeeklyChart({required this.dailyCounts});

  @override
  Widget build(BuildContext context) {
    final maxCount = dailyCounts.isEmpty
        ? 1
        : dailyCounts.reduce((a, b) => a > b ? a : b);
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Activity',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final count = index < dailyCounts.length ? dailyCounts[index] : 0;
                final height = maxCount > 0 ? (count / maxCount) * 60 : 0.0;
                final isToday = index == DateTime.now().weekday - 1;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      count.toString(),
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 28,
                      height: height.clamp(4, 60).toDouble(),
                      decoration: BoxDecoration(
                        gradient: isToday ? AppColors.primaryGradient : null,
                        color: isToday ? null : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      days[index],
                      style: TextStyle(
                        fontSize: 10,
                        color: isToday ? AppColors.primary : AppColors.textSecondary,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final Map<String, dynamic> suggestion;
  final VoidCallback onTap;

  const _SuggestionCard({
    required this.suggestion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final type = suggestion['type'] ?? 'tip';
    final color = _getTypeColor(type);
    final icon = _getIcon(suggestion['icon'] ?? 'info');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: AppColors.surface,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          suggestion['title'] ?? '',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          suggestion['message'] ?? '',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        trailing: suggestion['action'] != null
            ? const Icon(Iconsax.arrow_right_3, size: 16)
            : null,
        onTap: suggestion['action'] != null ? onTap : null,
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'warning':
        return AppColors.warning;
      case 'urgent':
        return AppColors.error;
      case 'reminder':
        return AppColors.primary;
      case 'insight':
        return AppColors.secondary;
      case 'balance':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'warning':
        return Iconsax.warning_2;
      case 'schedule':
        return Iconsax.clock;
      case 'add_a_photo':
        return Iconsax.camera;
      case 'priority_high':
        return Iconsax.danger;
      case 'insights':
        return Iconsax.chart;
      case 'balance':
        return Iconsax.weight;
      default:
        return Iconsax.info_circle;
    }
  }
}

class _ActionCard extends StatelessWidget {
  final dynamic action;
  final bool isOverdue;
  final VoidCallback onComplete;

  const _ActionCard({
    required this.action,
    this.isOverdue = false,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isOverdue ? AppColors.error.withOpacity(0.05) : AppColors.surface,
      child: ListTile(
        leading: _getPriorityIndicator(),
        title: Text(
          action.title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isOverdue ? AppColors.error : null,
          ),
        ),
        subtitle: action.notes != null
            ? Text(
                action.notes!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              )
            : null,
        trailing: IconButton(
          icon: Icon(
            Iconsax.tick_circle,
            color: AppColors.success,
          ),
          onPressed: onComplete,
        ),
      ),
    );
  }

  Widget _getPriorityIndicator() {
    Color color;
    switch (action.priority) {
      case 'high':
        color = AppColors.error;
        break;
      case 'medium':
        color = AppColors.warning;
        break;
      default:
        color = AppColors.success;
    }

    return Container(
      width: 4,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _EmptyActionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Iconsax.tick_circle,
            size: 48,
            color: AppColors.success.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'All caught up!',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'No tasks for today. Enjoy your day!',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyDigestSheet extends ConsumerWidget {
  const _WeeklyDigestSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final digestAsync = ref.watch(weeklyDigestProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Iconsax.document_text, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Text(
                      'Weekly Digest',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: digestAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error loading digest: $e')),
                  data: (digest) => ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Summary
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          digest.summary,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Stats
                      Row(
                        children: [
                          Expanded(
                            child: _DigestStatCard(
                              label: 'Total Captures',
                              value: digest.totalCaptures.toString(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _DigestStatCard(
                              label: 'Top Tags',
                              value: digest.topTags.take(3).join(', '),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DigestStatCard extends StatelessWidget {
  final String label;
  final String value;

  const _DigestStatCard({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingRepliesWidget extends ConsumerWidget {
  final VoidCallback onTap;

  const _PendingRepliesWidget({required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(googleAuthProvider);
    final pendingRepliesAsync = ref.watch(pendingRepliesProvider);

    if (!authState.isAuthenticated || !authState.gmailEnabled) {
      return const SizedBox.shrink();
    }

    return pendingRepliesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (emails) {
        if (emails.isEmpty) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Card(
            color: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: AppColors.primary.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Iconsax.message_edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pending Replies',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${emails.length} ${emails.length == 1 ? 'email needs' : 'emails need'} your response',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${emails.length}',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.cpu,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'AI has drafted replies ready for your review',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Icon(
                            Iconsax.arrow_right_3,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

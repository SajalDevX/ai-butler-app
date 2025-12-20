import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../providers/google_auth_provider.dart';
import '../../providers/client_provider.dart';
import '../../theme/colors.dart';
import '../../widgets/loading_shimmer.dart';
import 'reply_editor_screen.dart';

/// Provider for emails that need replies (importance >= 5)
final pendingRepliesProvider = FutureProvider<List<dynamic>>((ref) async {
  final client = ref.watch(clientProvider);
  final authState = ref.watch(googleAuthProvider);

  if (!authState.isAuthenticated || !authState.gmailEnabled) {
    return [];
  }

  try {
    final allEmails = await client.integration.getImportantEmails();
    // Filter for emails with importance >= 5 that require action and have draft replies
    return allEmails.where((email) {
      return email.importanceScore >= 5 &&
             email.requiresAction &&
             email.draftReply != null;
    }).toList();
  } catch (e) {
    return [];
  }
});

class PendingRepliesScreen extends ConsumerStatefulWidget {
  const PendingRepliesScreen({super.key});

  @override
  ConsumerState<PendingRepliesScreen> createState() => _PendingRepliesScreenState();
}

class _PendingRepliesScreenState extends ConsumerState<PendingRepliesScreen> {
  String _filterMode = 'all'; // all, urgent, today

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.invalidate(pendingRepliesProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(googleAuthProvider);
    final pendingRepliesAsync = ref.watch(pendingRepliesProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(60, 12, 20, 16),
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
                                Iconsax.message_edit,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pending Replies',
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'AI-powered email responses',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              title: const Text('Pending Replies'),
              centerTitle: false,
            ),
          ),

          // Filter chips
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected: _filterMode == 'all',
                    onTap: () => setState(() => _filterMode = 'all'),
                  ),
                  _FilterChip(
                    label: 'Urgent (8+)',
                    icon: Iconsax.danger,
                    isSelected: _filterMode == 'urgent',
                    onTap: () => setState(() => _filterMode = 'urgent'),
                  ),
                  _FilterChip(
                    label: 'Today',
                    icon: Iconsax.clock,
                    isSelected: _filterMode == 'today',
                    onTap: () => setState(() => _filterMode = 'today'),
                  ),
                ],
              ),
            ),
          ),

          // Content
          if (!authState.isAuthenticated || !authState.gmailEnabled)
            SliverFillRemaining(
              child: _NotConnectedState(
                onConnect: () => _connectGmail(),
              ),
            )
          else
            pendingRepliesAsync.when(
              loading: () => SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => LoadingShimmers.emailCard()
                        .animate()
                        .fadeIn(duration: 300.ms, delay: (index * 100).ms),
                    childCount: 5,
                  ),
                ),
              ),
              error: (error, stack) => SliverFillRemaining(
                child: _ErrorState(
                  error: error.toString(),
                  onRetry: () => ref.invalidate(pendingRepliesProvider),
                ),
              ),
              data: (emails) {
                if (emails.isEmpty) {
                  return SliverFillRemaining(
                    child: _EmptyState(),
                  );
                }

                // Apply filters
                var filteredEmails = emails;
                if (_filterMode == 'urgent') {
                  filteredEmails = emails.where((e) => e.importanceScore >= 8).toList();
                } else if (_filterMode == 'today') {
                  final today = DateTime.now();
                  filteredEmails = emails.where((e) {
                    final receivedDate = e.receivedAt as DateTime;
                    return receivedDate.year == today.year &&
                           receivedDate.month == today.month &&
                           receivedDate.day == today.day;
                  }).toList();
                }

                if (filteredEmails.isEmpty) {
                  return SliverFillRemaining(
                    child: _EmptyState(message: 'No emails match this filter'),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final email = filteredEmails[index];
                        return _PendingReplyCard(
                          email: email,
                          onTap: () => _openReplyEditor(email),
                        ).animate().fadeIn(duration: 300.ms, delay: (index * 50).ms);
                      },
                      childCount: filteredEmails.length,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      floatingActionButton: authState.isAuthenticated && authState.gmailEnabled
          ? FloatingActionButton.extended(
              onPressed: () => _syncEmails(),
              icon: const Icon(Iconsax.refresh),
              label: const Text('Sync'),
              backgroundColor: AppColors.primary,
            )
          : null,
    );
  }

  Future<void> _connectGmail() async {
    final success = await ref.read(googleAuthProvider.notifier).signIn(
          enableGmail: true,
          enableCalendar: false,
        );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gmail connected successfully!')),
      );
    }
  }

  Future<void> _syncEmails() async {
    try {
      await ref.read(googleAuthProvider.notifier).syncNow();
      ref.invalidate(pendingRepliesProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Emails synced successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sync failed: $e')),
        );
      }
    }
  }

  void _openReplyEditor(dynamic email) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ReplyEditorScreen(email: email),
      ),
    ).then((_) {
      // Refresh list after returning from editor
      ref.invalidate(pendingRepliesProvider);
    });
  }
}

class _PendingReplyCard extends StatefulWidget {
  final dynamic email;
  final VoidCallback onTap;

  const _PendingReplyCard({
    required this.email,
    required this.onTap,
  });

  @override
  State<_PendingReplyCard> createState() => _PendingReplyCardState();
}

class _PendingReplyCardState extends State<_PendingReplyCard> with SingleTickerProviderStateMixin {
  double _dragExtent = 0;
  late AnimationController _moveController;

  @override
  void initState() {
    super.initState();
    _moveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _moveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isUrgent = widget.email.importanceScore >= 8;
    final urgencyLevel = _getUrgencyLevel(widget.email.importanceScore);

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragExtent += details.delta.dx;
          _dragExtent = _dragExtent.clamp(-100.0, 100.0);
        });
      },
      onHorizontalDragEnd: (details) {
        if (_dragExtent > 60) {
          _handleSwipeRight();
        } else if (_dragExtent < -60) {
          _handleSwipeLeft();
        }
        setState(() => _dragExtent = 0);
      },
      child: Stack(
        children: [
          // Background swipe actions
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: _dragExtent > 0
                    ? LinearGradient(
                        colors: [AppColors.success.withOpacity(0.8), AppColors.success],
                      )
                    : LinearGradient(
                        colors: [AppColors.error.withOpacity(0.8), AppColors.error],
                      ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: _dragExtent > 0 ? MainAxisAlignment.start : MainAxisAlignment.end,
                  children: [
                    Icon(
                      _dragExtent > 0 ? Iconsax.tick_circle : Iconsax.archive_minus,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _dragExtent > 0 ? 'Quick Reply' : 'Archive',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Main card
          Transform.translate(
            offset: Offset(_dragExtent, 0),
            child: Hero(
              tag: 'email-${widget.email.gmailId}',
              child: Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isUrgent ? AppColors.error.withOpacity(0.3) : AppColors.surfaceLight,
                    width: isUrgent ? 2 : 1,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    widget.onTap();
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
              // Header
              Row(
                children: [
                  // Urgency indicator
                  Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(
                      color: urgencyLevel.color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Avatar
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _getInitial(widget.email.fromName ?? widget.email.fromEmail),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // From info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.email.fromName ?? widget.email.fromEmail,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          timeago.format(widget.email.receivedAt),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Urgency badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: urgencyLevel.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          urgencyLevel.icon,
                          size: 12,
                          color: urgencyLevel.color,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          urgencyLevel.label,
                          style: TextStyle(
                            color: urgencyLevel.color,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Subject
              Text(
                widget.email.subject,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // AI Summary
              if (widget.email.aiSummary != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.email.aiSummary!,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Action button
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.edit_2,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'AI Draft Ready • Tap to Review & Send',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      Iconsax.arrow_right_3,
                      size: 16,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),

              // Deadline if present
              if (widget.email.deadlineDetected != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Iconsax.clock,
                      size: 14,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Deadline: ${_formatDeadline(widget.email.deadlineDetected!)}',
                      style: TextStyle(
                        color: AppColors.error,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSwipeRight() {
    HapticFeedback.heavyImpact();
    // Quick send with AI draft
    widget.onTap();
  }

  void _handleSwipeLeft() {
    HapticFeedback.mediumImpact();
    // Archive email - show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Iconsax.archive_tick, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Text('${widget.email.subject} archived'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _getInitial(String text) {
    if (text.isEmpty) return '?';
    return text[0].toUpperCase();
  }

  ({Color color, IconData icon, String label}) _getUrgencyLevel(int score) {
    if (score >= 9) {
      return (color: AppColors.error, icon: Iconsax.danger, label: 'URGENT');
    } else if (score >= 7) {
      return (color: AppColors.warning, icon: Iconsax.warning_2, label: 'HIGH');
    } else {
      return (color: AppColors.primary, icon: Iconsax.info_circle, label: 'MEDIUM');
    }
  }

  String _formatDeadline(DateTime deadline) {
    final now = DateTime.now();
    final diff = deadline.difference(now);

    if (diff.isNegative) return 'Overdue!';
    if (diff.inHours < 24) return '${diff.inHours}h remaining';
    if (diff.inDays < 7) return '${diff.inDays}d remaining';
    return '${(diff.inDays / 7).floor()}w remaining';
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
            ],
            Text(label),
          ],
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary.withOpacity(0.2),
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          fontSize: 13,
        ),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.transparent,
        ),
      ),
    );
  }
}

class _NotConnectedState extends StatelessWidget {
  final VoidCallback onConnect;

  const _NotConnectedState({required this.onConnect});

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
                Iconsax.message_edit,
                size: 64,
                color: AppColors.primary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Connect Gmail',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Connect your Gmail account to get AI-powered reply suggestions.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onConnect,
              icon: const Icon(Iconsax.login),
              label: const Text('Connect Gmail'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String? message;

  const _EmptyState({this.message});

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
                Iconsax.tick_circle,
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
              'All Caught Up!',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message ?? 'No emails need replies right now. Great job!',
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

class _ErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.warning_2,
              size: 64,
              color: AppColors.error.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Error Loading Emails',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Iconsax.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmailCardShimmer extends StatelessWidget {
  const _EmailCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.surfaceLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                LoadingShimmer(
                  width: 40,
                  height: 40,
                  borderRadius: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LoadingShimmer(width: 150, height: 14),
                      const SizedBox(height: 6),
                      LoadingShimmer(width: 100, height: 12),
                    ],
                  ),
                ),
                LoadingShimmer(width: 60, height: 24, borderRadius: 8),
              ],
            ),
            const SizedBox(height: 12),
            LoadingShimmer(width: double.infinity, height: 16),
            const SizedBox(height: 8),
            LoadingShimmer(width: double.infinity, height: 14),
            const SizedBox(height: 12),
            LoadingShimmer(
              width: double.infinity,
              height: 60,
              borderRadius: 12,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconsax/iconsax.dart';

import '../../providers/capture_provider.dart';
import '../../theme/colors.dart';
import '../../widgets/capture_card.dart';
import '../capture/capture_detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scrollController = ScrollController();
  String? _selectedFilter;

  @override
  void initState() {
    super.initState();
    // Load captures on init
    Future.microtask(() {
      ref.read(capturesProvider.notifier).loadCaptures();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final capturesState = ref.watch(capturesProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(capturesProvider.notifier).loadCaptures();
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              snap: true,
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Iconsax.cpu, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text('Recall Butler'),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Iconsax.notification),
                  onPressed: _showInsights,
                ),
              ],
            ),

            // Filter chips
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      isSelected: _selectedFilter == null,
                      onSelected: () => _setFilter(null),
                    ),
                    _FilterChip(
                      label: 'Screenshots',
                      icon: Iconsax.mobile,
                      isSelected: _selectedFilter == 'screenshot',
                      onSelected: () => _setFilter('screenshot'),
                    ),
                    _FilterChip(
                      label: 'Photos',
                      icon: Iconsax.camera,
                      isSelected: _selectedFilter == 'photo',
                      onSelected: () => _setFilter('photo'),
                    ),
                    _FilterChip(
                      label: 'Voice',
                      icon: Iconsax.microphone,
                      isSelected: _selectedFilter == 'voice',
                      onSelected: () => _setFilter('voice'),
                    ),
                    _FilterChip(
                      label: 'Links',
                      icon: Iconsax.link,
                      isSelected: _selectedFilter == 'link',
                      onSelected: () => _setFilter('link'),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            if (capturesState.isLoading && capturesState.captures.isEmpty)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (capturesState.captures.isEmpty)
              SliverFillRemaining(
                child: _EmptyState(onCapture: () {}),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childCount: capturesState.captures.length,
                  itemBuilder: (context, index) {
                    final capture = capturesState.captures[index];
                    return CaptureCard(
                      capture: capture,
                      onTap: () => _openCapture(capture),
                      onLongPress: () => _showCaptureOptions(capture),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _setFilter(String? filter) {
    setState(() {
      _selectedFilter = filter;
    });
    ref.read(capturesProvider.notifier).setType(filter);
  }

  void _openCapture(capture) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CaptureDetailScreen(capture: capture),
      ),
    );
  }

  void _showCaptureOptions(capture) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _CaptureOptionsSheet(
        capture: capture,
        onDelete: () {
          ref.read(capturesProvider.notifier).deleteCapture(capture.id!);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showInsights() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Insights coming soon!')),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onSelected,
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
                size: 16,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
            ],
            Text(label),
          ],
        ),
        selected: isSelected,
        onSelected: (_) => onSelected(),
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary.withOpacity(0.2),
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.transparent,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onCapture;

  const _EmptyState({required this.onCapture});

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
              child: const Icon(
                Iconsax.cpu,
                size: 64,
                color: AppColors.primary,
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: 2.seconds,
                )
                .shimmer(duration: 2.seconds),
            const SizedBox(height: 24),
            Text(
              'Your Second Brain Awaits',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Capture screenshots, photos, voice notes, and links. '
              'I\'ll remember everything for you.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onCapture,
              icon: const Icon(Iconsax.add),
              label: const Text('Start Capturing'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CaptureOptionsSheet extends StatelessWidget {
  final dynamic capture;
  final VoidCallback onDelete;

  const _CaptureOptionsSheet({
    required this.capture,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Iconsax.share),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement share
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.folder_add),
              title: const Text('Add to Collection'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement add to collection
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.edit),
              title: const Text('Edit Category'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement edit category
              },
            ),
            ListTile(
              leading: Icon(Iconsax.trash, color: AppColors.error),
              title: Text('Delete', style: TextStyle(color: AppColors.error)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Capture'),
                    content: const Text(
                        'Are you sure you want to delete this capture?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onDelete();
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

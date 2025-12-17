import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconsax/iconsax.dart';

import '../../providers/search_provider.dart';
import '../../theme/colors.dart';
import '../../widgets/capture_card.dart';
import '../capture/capture_detail_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _showSuggestions = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Search input
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _focusNode.hasFocus
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: 'Search your captures...',
                        prefixIcon: const Icon(Iconsax.search_normal),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Iconsax.close_circle),
                                onPressed: () {
                                  _searchController.clear();
                                  ref.read(searchProvider.notifier).clearSearch();
                                },
                              )
                            : IconButton(
                                icon: const Icon(Iconsax.microphone),
                                onPressed: _startVoiceSearch,
                              ),
                        border: InputBorder.none,
                        filled: false,
                      ),
                      onChanged: (value) {
                        ref.read(searchProvider.notifier).quickSearch(value);
                      },
                      onSubmitted: (value) {
                        _performSearch(value);
                      },
                      textInputAction: TextInputAction.search,
                    ),
                  ),

                  // Suggestions dropdown
                  if (_showSuggestions && searchState.suggestions.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: searchState.suggestions.map((suggestion) {
                          return ListTile(
                            dense: true,
                            leading: const Icon(
                              Iconsax.search_normal,
                              size: 18,
                              color: AppColors.textSecondary,
                            ),
                            title: Text(suggestion),
                            onTap: () {
                              _searchController.text = suggestion;
                              _performSearch(suggestion);
                            },
                          );
                        }).toList(),
                      ),
                    ).animate().fadeIn(duration: 200.ms).slideY(
                          begin: -0.1,
                          end: 0,
                          duration: 200.ms,
                        ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _buildContent(searchState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(SearchState searchState) {
    // Loading state
    if (searchState.isSearching) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Searching your memories...',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    // Search results
    if (searchState.result != null) {
      if (searchState.result!.captures.isEmpty) {
        return _NoResults(query: searchState.query);
      }

      return CustomScrollView(
        slivers: [
          // Results header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    '${searchState.result!.totalCount} results',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    icon: const Icon(Iconsax.filter, size: 18),
                    label: const Text('Filter'),
                    onPressed: _showFilters,
                  ),
                ],
              ),
            ),
          ),

          // Results grid
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverMasonryGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childCount: searchState.result!.captures.length,
              itemBuilder: (context, index) {
                final capture = searchState.result!.captures[index];
                return CaptureCard(
                  capture: capture,
                  onTap: () => _openCapture(capture),
                );
              },
            ),
          ),

          // Related suggestions
          if (searchState.result!.suggestions != null &&
              searchState.result!.suggestions!.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Related searches',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: searchState.result!.suggestions!.map((s) {
                        return ActionChip(
                          label: Text(s),
                          onPressed: () {
                            _searchController.text = s;
                            _performSearch(s);
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    }

    // Initial state - show recent searches
    return _InitialState(
      recentSearches: searchState.recentSearches,
      onSearchTap: (query) {
        _searchController.text = query;
        _performSearch(query);
      },
    );
  }

  void _performSearch(String query) {
    _focusNode.unfocus();
    ref.read(searchProvider.notifier).search(query);
  }

  void _startVoiceSearch() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voice search coming soon!')),
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _FiltersSheet(
        onApply: (category, type, dateRange) {
          Navigator.pop(context);
          ref.read(searchProvider.notifier).search(
                _searchController.text,
                category: category,
                type: type,
                fromDate: dateRange?.start,
                toDate: dateRange?.end,
              );
        },
      ),
    );
  }

  void _openCapture(capture) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CaptureDetailScreen(capture: capture),
      ),
    );
  }
}

class _InitialState extends StatelessWidget {
  final List<String> recentSearches;
  final Function(String) onSearchTap;

  const _InitialState({
    required this.recentSearches,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search tips
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.secondary.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Iconsax.magic_star, color: AppColors.primary),
                    const SizedBox(width: 8),
                    const Text(
                      'Smart Search Tips',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _SearchTip(
                  example: '"that pasta recipe"',
                  description: 'Find by description',
                ),
                _SearchTip(
                  example: '"meeting notes from last week"',
                  description: 'Search by time',
                ),
                _SearchTip(
                  example: '"John\'s phone number"',
                  description: 'Find specific info',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Recent searches
          if (recentSearches.isNotEmpty) ...[
            Row(
              children: [
                const Icon(Iconsax.clock, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                const Text(
                  'Recent Searches',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: recentSearches.map((search) {
                return ActionChip(
                  avatar: const Icon(Iconsax.clock, size: 16),
                  label: Text(search),
                  onPressed: () => onSearchTap(search),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _SearchTip extends StatelessWidget {
  final String example;
  final String description;

  const _SearchTip({required this.example, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          const Text('•  ', style: TextStyle(color: AppColors.primary)),
          Text(
            example,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '- $description',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  final String query;

  const _NoResults({required this.query});

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
                Iconsax.search_status,
                size: 48,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No results for "$query"',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Try different keywords or check the spelling',
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

class _FiltersSheet extends StatefulWidget {
  final Function(String?, String?, DateTimeRange?) onApply;

  const _FiltersSheet({required this.onApply});

  @override
  State<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<_FiltersSheet> {
  String? _selectedCategory;
  String? _selectedType;
  DateTimeRange? _dateRange;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategory = null;
                      _selectedType = null;
                      _dateRange = null;
                    });
                  },
                  child: const Text('Clear all'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Type filter
            const Text('Type', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['screenshot', 'photo', 'voice', 'link'].map((type) {
                return ChoiceChip(
                  label: Text(type),
                  selected: _selectedType == type,
                  onSelected: (selected) {
                    setState(() {
                      _selectedType = selected ? type : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Category filter
            const Text('Category',
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AppColors.categoryColors.keys.map((category) {
                return ChoiceChip(
                  label: Text(category),
                  selected: _selectedCategory == category,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = selected ? category : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Apply button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(_selectedCategory, _selectedType, _dateRange);
                },
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

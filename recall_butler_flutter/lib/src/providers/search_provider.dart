import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recall_butler_client/recall_butler_client.dart';
import 'client_provider.dart';

/// State for search
class SearchState {
  final String query;
  final SearchResult? result;
  final List<String> recentSearches;
  final List<String> suggestions;
  final bool isSearching;
  final String? error;

  const SearchState({
    this.query = '',
    this.result,
    this.recentSearches = const [],
    this.suggestions = const [],
    this.isSearching = false,
    this.error,
  });

  SearchState copyWith({
    String? query,
    SearchResult? result,
    List<String>? recentSearches,
    List<String>? suggestions,
    bool? isSearching,
    String? error,
  }) {
    return SearchState(
      query: query ?? this.query,
      result: result ?? this.result,
      recentSearches: recentSearches ?? this.recentSearches,
      suggestions: suggestions ?? this.suggestions,
      isSearching: isSearching ?? this.isSearching,
      error: error,
    );
  }
}

/// Notifier for search state
class SearchNotifier extends StateNotifier<SearchState> {
  final Client _client;

  SearchNotifier(this._client) : super(const SearchState());

  /// Initialize with recent searches
  Future<void> initialize() async {
    try {
      final recentSearches = await _client.search.getRecentSearches();
      state = state.copyWith(recentSearches: recentSearches);
    } catch (e) {
      // Ignore errors loading recent searches
    }
  }

  /// Perform a search
  Future<void> search(
    String query, {
    String? category,
    String? type,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    if (query.trim().isEmpty) {
      state = state.copyWith(result: null, query: '');
      return;
    }

    state = state.copyWith(query: query, isSearching: true);

    try {
      final request = SearchRequest(
        query: query,
        category: category,
        type: type,
        fromDate: fromDate,
        toDate: toDate,
      );

      final result = await _client.search.search(request);

      // Update recent searches
      final recentSearches = [
        query,
        ...state.recentSearches.where((s) => s != query),
      ].take(10).toList();

      state = state.copyWith(
        result: result,
        recentSearches: recentSearches,
        suggestions: result.suggestions ?? [],
        isSearching: false,
      );
    } catch (e) {
      state = state.copyWith(isSearching: false, error: e.toString());
    }
  }

  /// Quick search for autocomplete
  Future<void> quickSearch(String query) async {
    if (query.length < 2) {
      state = state.copyWith(suggestions: []);
      return;
    }

    try {
      final suggestions = await _client.search.quickSearch(query);
      state = state.copyWith(suggestions: suggestions);
    } catch (e) {
      // Ignore errors in quick search
    }
  }

  /// Clear search
  void clearSearch() {
    state = state.copyWith(query: '', result: null, suggestions: []);
  }

  /// Record a click on a search result
  Future<void> recordClick(int searchQueryId, int captureId) async {
    try {
      await _client.search.recordSearchClick(searchQueryId, captureId);
    } catch (e) {
      // Ignore errors
    }
  }
}

/// Provider for search
final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  final client = ref.watch(clientProvider);
  final notifier = SearchNotifier(client);
  notifier.initialize();
  return notifier;
});

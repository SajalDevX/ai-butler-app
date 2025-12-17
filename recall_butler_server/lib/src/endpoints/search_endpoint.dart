import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/gemini_service.dart';

class SearchEndpoint extends Endpoint {
  /// Perform semantic search across captures
  Future<SearchResult> search(
    Session session,
    SearchRequest request,
  ) async {
    final userId = await _getUserId(session);
    final startTime = DateTime.now();

    // Expand query with AI-generated related terms
    final expandedTerms = await GeminiService.expandSearchQuery(
      session,
      request.query,
    );

    // Build search query
    var whereClause = Capture.t.userId.equals(userId) &
        Capture.t.processingStatus.equals('completed');

    // Apply filters
    if (request.category != null) {
      whereClause = whereClause & Capture.t.category.equals(request.category);
    }
    if (request.type != null) {
      whereClause = whereClause & Capture.t.type.equals(request.type);
    }
    if (request.fromDate != null) {
      whereClause =
          whereClause & Capture.t.createdAt.between(request.fromDate!, request.toDate ?? DateTime.now());
    }

    // Get all matching captures
    var captures = await Capture.db.find(
      session,
      where: (t) => whereClause,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: 100, // Get more than needed for reranking
    );

    // Filter by text search
    captures = _filterByTextSearch(captures, expandedTerms);

    // Get total count before pagination
    final totalCount = captures.length;

    // Rerank results using AI
    if (captures.length > 1) {
      final rankedIndices = await GeminiService.rerankResults(
        session,
        request.query,
        captures.take(20).toList(),
      );

      // Reorder captures based on AI ranking
      final reranked = <Capture>[];
      for (final idx in rankedIndices) {
        if (idx >= 0 && idx < captures.length) {
          reranked.add(captures[idx]);
        }
      }
      // Add any remaining captures
      for (final c in captures) {
        if (!reranked.contains(c)) {
          reranked.add(c);
        }
      }
      captures = reranked;
    }

    // Apply pagination
    final limit = request.limit ?? 10;
    final offset = request.offset ?? 0;
    captures = captures.skip(offset).take(limit).toList();

    // Log search query for analytics
    await _logSearchQuery(session, userId, request.query, totalCount, captures);

    // Generate suggestions based on results
    final suggestions = _generateSuggestions(captures, request.query);

    return SearchResult(
      captures: captures,
      totalCount: totalCount,
      aiSummary: captures.isNotEmpty
          ? 'Found ${captures.length} captures matching "${request.query}"'
          : null,
      suggestions: suggestions,
    );
  }

  /// Quick search for autocomplete
  Future<List<String>> quickSearch(
    Session session,
    String query,
  ) async {
    final userId = await _getUserId(session);

    // Get recent searches matching the query
    final recentSearches = await SearchQuery.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.query.ilike('%$query%'),
      orderBy: (t) => t.searchedAt,
      orderDescending: true,
      limit: 5,
    );

    final suggestions = recentSearches.map((s) => s.query).toSet().toList();

    // Also search capture summaries
    final captures = await Capture.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          (t.aiSummary.ilike('%$query%') | t.extractedText.ilike('%$query%')),
      limit: 5,
    );

    for (final c in captures) {
      if (c.aiSummary != null && c.aiSummary!.length < 50) {
        suggestions.add(c.aiSummary!);
      }
    }

    return suggestions.take(8).toList();
  }

  /// Get recent searches for the user
  Future<List<String>> getRecentSearches(Session session) async {
    final userId = await _getUserId(session);

    final searches = await SearchQuery.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      orderBy: (t) => t.searchedAt,
      orderDescending: true,
      limit: 10,
    );

    return searches.map((s) => s.query).toSet().toList();
  }

  /// Record when user clicks on a search result
  Future<void> recordSearchClick(
    Session session,
    int searchQueryId,
    int captureId,
  ) async {
    final search = await SearchQuery.db.findById(session, searchQueryId);
    if (search != null) {
      search.clickedCaptureId = captureId;
      await SearchQuery.db.updateRow(session, search);
    }
  }

  /// Filter captures by text search
  List<Capture> _filterByTextSearch(
    List<Capture> captures,
    List<String> searchTerms,
  ) {
    return captures.where((capture) {
      final searchableText = [
        capture.extractedText,
        capture.aiSummary,
        capture.tags,
        capture.category,
        capture.sourceApp,
      ].whereType<String>().join(' ').toLowerCase();

      // Check if any search term matches
      return searchTerms.any((term) =>
          searchableText.contains(term.toLowerCase()));
    }).toList();
  }

  /// Generate search suggestions based on results
  List<String> _generateSuggestions(List<Capture> captures, String query) {
    final suggestions = <String>{};

    for (final capture in captures) {
      // Add categories as suggestions
      if (capture.category != query) {
        suggestions.add(capture.category);
      }

      // Add tags as suggestions
      if (capture.tags != null) {
        try {
          final tags = List<String>.from(jsonDecode(capture.tags!));
          for (final tag in tags) {
            if (!tag.toLowerCase().contains(query.toLowerCase())) {
              suggestions.add(tag);
            }
          }
        } catch (_) {}
      }
    }

    return suggestions.take(5).toList();
  }

  /// Log search query for analytics
  Future<void> _logSearchQuery(
    Session session,
    int userId,
    String query,
    int resultsCount,
    List<Capture> captures,
  ) async {
    final searchQuery = SearchQuery(
      userId: userId,
      query: query,
      resultsCount: resultsCount,
      searchedAt: DateTime.now(),
    );

    await SearchQuery.db.insertRow(session, searchQuery);
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

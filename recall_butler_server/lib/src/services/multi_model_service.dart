import 'dart:typed_data';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'gemini_service.dart';
import 'groq_service.dart';

/// Exception thrown when a model provider is rate limited
class RateLimitException implements Exception {
  final String provider;
  final String message;

  RateLimitException(this.provider, this.message);

  @override
  String toString() => 'RateLimitException($provider): $message';
}

/// Enum for available model providers
enum ModelProvider {
  gemini,
  groq,
}

/// Service that orchestrates between multiple AI model providers
/// Automatically falls back to alternative providers when rate limits are hit
class MultiModelService {
  // Track rate limit status for each provider with cooldown period
  static final Map<ModelProvider, DateTime?> _rateLimitedUntil = {};

  // Default cooldown period after rate limit (5 minutes)
  static const Duration _rateLimitCooldown = Duration(minutes: 5);

  /// Check if a provider is currently rate limited
  static bool isProviderRateLimited(ModelProvider provider) {
    final limitedUntil = _rateLimitedUntil[provider];
    if (limitedUntil == null) return false;

    if (DateTime.now().isAfter(limitedUntil)) {
      // Cooldown expired, clear the rate limit
      _rateLimitedUntil[provider] = null;
      return false;
    }
    return true;
  }

  /// Mark a provider as rate limited
  static void markProviderRateLimited(ModelProvider provider) {
    _rateLimitedUntil[provider] = DateTime.now().add(_rateLimitCooldown);
  }

  /// Clear rate limit for a provider (e.g., after successful call)
  static void clearProviderRateLimit(ModelProvider provider) {
    _rateLimitedUntil[provider] = null;
  }

  /// Get the preferred provider order based on current rate limit status
  static List<ModelProvider> getProviderOrder({bool preferGroq = false}) {
    final providers = preferGroq
        ? [ModelProvider.groq, ModelProvider.gemini]
        : [ModelProvider.gemini, ModelProvider.groq];

    // Move rate-limited providers to the end
    final available = <ModelProvider>[];
    final limited = <ModelProvider>[];

    for (final provider in providers) {
      if (isProviderRateLimited(provider)) {
        limited.add(provider);
      } else {
        available.add(provider);
      }
    }

    return [...available, ...limited];
  }

  /// Quick analysis with automatic fallback
  /// Note: Falls back to Groq only if Gemini is rate-limited and content is text-based
  /// (Groq doesn't support vision)
  static Future<QuickAnalysisResult> quickAnalysis(
    Session session,
    String type,
    Uint8List imageBytes,
  ) async {
    final providers = getProviderOrder();

    for (final provider in providers) {
      if (isProviderRateLimited(provider)) {
        session.log('Skipping ${provider.name} - rate limited', level: LogLevel.debug);
        continue;
      }

      try {
        switch (provider) {
          case ModelProvider.gemini:
            final result = await GeminiService.quickAnalysis(session, type, imageBytes);
            clearProviderRateLimit(ModelProvider.gemini);
            return result;

          case ModelProvider.groq:
            // Groq doesn't support vision, return null to try next
            final result = await GroqService.quickAnalysis(session, type, imageBytes);
            if (result != null) {
              clearProviderRateLimit(ModelProvider.groq);
              return result;
            }
            // If Groq returns null (no vision support), continue to next
            continue;
        }
      } on RateLimitException catch (e) {
        session.log('${provider.name} rate limited: ${e.message}', level: LogLevel.warning);
        markProviderRateLimited(provider);
        continue;
      } catch (e) {
        if (e.toString().contains('rate limit') ||
            e.toString().contains('429') ||
            e.toString().contains('quota')) {
          session.log('${provider.name} rate limited (from error): $e', level: LogLevel.warning);
          markProviderRateLimited(provider);
          continue;
        }
        // For other errors, still try fallback
        session.log('${provider.name} error: $e', level: LogLevel.warning);
        continue;
      }
    }

    // All providers failed, return safe fallback
    return QuickAnalysisResult(
      description: 'Image captured - analyzing...',
      detectedType: 'other',
      confidence: 0.0,
    );
  }

  /// Expand search query with automatic fallback
  static Future<List<String>> expandSearchQuery(
    Session session,
    String query,
  ) async {
    final providers = getProviderOrder();

    for (final provider in providers) {
      if (isProviderRateLimited(provider)) {
        continue;
      }

      try {
        List<String> result;
        switch (provider) {
          case ModelProvider.gemini:
            result = await GeminiService.expandSearchQuery(session, query);
            break;
          case ModelProvider.groq:
            result = await GroqService.expandSearchQuery(session, query);
            break;
        }

        if (result.length > 1) {
          clearProviderRateLimit(provider);
          return result;
        }
      } catch (e) {
        if (_isRateLimitError(e)) {
          markProviderRateLimited(provider);
        }
        continue;
      }
    }

    return [query];
  }

  /// Rerank results with automatic fallback
  static Future<List<int>> rerankResults(
    Session session,
    String query,
    List<Capture> captures,
  ) async {
    if (captures.isEmpty) {
      return [];
    }

    final providers = getProviderOrder();

    for (final provider in providers) {
      if (isProviderRateLimited(provider)) {
        continue;
      }

      try {
        List<int> result;
        switch (provider) {
          case ModelProvider.gemini:
            result = await GeminiService.rerankResults(session, query, captures);
            break;
          case ModelProvider.groq:
            result = await GroqService.rerankResults(session, query, captures);
            break;
        }

        if (result.isNotEmpty) {
          clearProviderRateLimit(provider);
          return result;
        }
      } catch (e) {
        if (_isRateLimitError(e)) {
          markProviderRateLimited(provider);
        }
        continue;
      }
    }

    return List.generate(captures.length, (i) => i);
  }

  /// Generate morning briefing with automatic fallback
  static Future<String> generateMorningBriefing(
    Session session,
    List<Action> todayActions,
    List<Capture> recentCaptures,
  ) async {
    final providers = getProviderOrder();

    for (final provider in providers) {
      if (isProviderRateLimited(provider)) {
        continue;
      }

      try {
        String result;
        switch (provider) {
          case ModelProvider.gemini:
            result = await GeminiService.generateMorningBriefing(
                session, todayActions, recentCaptures);
            break;
          case ModelProvider.groq:
            result = await GroqService.generateMorningBriefing(
                session, todayActions, recentCaptures);
            break;
        }

        if (result.isNotEmpty && !result.startsWith('Good morning! You have')) {
          clearProviderRateLimit(provider);
          return result;
        }
      } catch (e) {
        if (_isRateLimitError(e)) {
          markProviderRateLimited(provider);
        }
        continue;
      }
    }

    return 'Good morning! You have ${todayActions.length} tasks today and ${recentCaptures.length} recent captures.';
  }

  /// Extract actions with automatic fallback
  static Future<List<Map<String, dynamic>>> extractActions(
    Session session,
    Capture capture,
  ) async {
    final providers = getProviderOrder();

    for (final provider in providers) {
      if (isProviderRateLimited(provider)) {
        continue;
      }

      try {
        List<Map<String, dynamic>> result;
        switch (provider) {
          case ModelProvider.gemini:
            result = await GeminiService.extractActions(session, capture);
            break;
          case ModelProvider.groq:
            result = await GroqService.extractActions(session, capture);
            break;
        }

        clearProviderRateLimit(provider);
        return result;
      } catch (e) {
        if (_isRateLimitError(e)) {
          markProviderRateLimited(provider);
        }
        continue;
      }
    }

    return [];
  }

  /// Generate weekly digest with automatic fallback
  static Future<String> generateWeeklyDigest(
    Session session,
    List<Capture> captures,
  ) async {
    if (captures.isEmpty) {
      return 'No captures this week.';
    }

    final providers = getProviderOrder();

    for (final provider in providers) {
      if (isProviderRateLimited(provider)) {
        continue;
      }

      try {
        String result;
        switch (provider) {
          case ModelProvider.gemini:
            result = await GeminiService.generateWeeklyDigest(session, captures);
            break;
          case ModelProvider.groq:
            result = await GroqService.generateWeeklyDigest(session, captures);
            break;
        }

        if (result.isNotEmpty && !result.startsWith('You captured')) {
          clearProviderRateLimit(provider);
          return result;
        }
      } catch (e) {
        if (_isRateLimitError(e)) {
          markProviderRateLimited(provider);
        }
        continue;
      }
    }

    return 'You captured ${captures.length} items this week.';
  }

  /// Get status of all providers
  static Map<String, dynamic> getProviderStatus() {
    return {
      'gemini': {
        'rateLimited': isProviderRateLimited(ModelProvider.gemini),
        'rateLimitedUntil': _rateLimitedUntil[ModelProvider.gemini]?.toIso8601String(),
      },
      'groq': {
        'rateLimited': isProviderRateLimited(ModelProvider.groq),
        'rateLimitedUntil': _rateLimitedUntil[ModelProvider.groq]?.toIso8601String(),
      },
    };
  }

  /// Check if an error indicates rate limiting
  static bool _isRateLimitError(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    return errorStr.contains('rate limit') ||
        errorStr.contains('429') ||
        errorStr.contains('quota') ||
        errorStr.contains('too many requests');
  }
}

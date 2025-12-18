import 'dart:math';
import 'dart:typed_data';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Intelligent Adaptive Token Management System
/// Optimizes token allocation based on content complexity and historical learning
class TokenOptimizerService {
  // ═══════════════════════════════════════════════════════════════════════════
  // TOKEN PROFILES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Quick analysis profiles (sync path - must be fast)
  static const Map<String, TokenProfile> _quickProfiles = {
    'simple': TokenProfile(base: 80, min: 50, max: 150),
    'medium': TokenProfile(base: 120, min: 80, max: 250),
    'complex': TokenProfile(base: 180, min: 120, max: 350),
  };

  /// Deep analysis profiles (async path - can take time)
  static const Map<String, TokenProfile> _deepProfiles = {
    'simple': TokenProfile(base: 300, min: 200, max: 600),
    'medium': TokenProfile(base: 600, min: 400, max: 1200),
    'complex': TokenProfile(base: 1000, min: 700, max: 2000),
    'document': TokenProfile(base: 1500, min: 1000, max: 3000),
  };

  /// Content type multipliers
  static const Map<String, double> _contentMultipliers = {
    'document': 1.5,
    'recipe_or_instructions': 1.4,
    'calendar': 1.4,
    'article': 1.3,
    'diagram': 1.2,
    'photo': 1.0,
    'simple_graphic': 0.8,
    'short_note': 0.7,
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MAIN API
  // ═══════════════════════════════════════════════════════════════════════════

  /// Calculate optimal tokens for quick analysis (sync path)
  static Future<TokenAllocation> calculateQuickTokens(
    Session session,
    Uint8List imageBytes,
  ) async {
    final analysis = await analyzeImageComplexity(imageBytes);
    final profile = _selectProfile(_quickProfiles, analysis.complexityScore);

    final baseTokens = profile.base * _getMultiplier(analysis.contentType);
    final buffer = baseTokens * 0.2 * (2 - analysis.confidence);
    final tokens = (baseTokens + buffer).round().clamp(profile.min, profile.max);

    // Apply historical adjustment
    final adjusted = await _applyHistoricalAdjustment(
      session,
      tokens,
      analysis.contentType,
      analysis.complexityBucket,
      isQuick: true,
    );

    return TokenAllocation(
      tokens: adjusted,
      complexityScore: analysis.complexityScore,
      contentType: analysis.contentType,
      complexityBucket: analysis.complexityBucket,
      confidence: analysis.confidence,
    );
  }

  /// Calculate optimal tokens for deep analysis (async path)
  static Future<TokenAllocation> calculateDeepTokens(
    Session session,
    Uint8List imageBytes,
  ) async {
    final analysis = await analyzeImageComplexity(imageBytes);

    // Use document profile for high complexity or text-heavy content
    String profileKey;
    if (analysis.complexityScore > 0.8 || analysis.contentType == 'document') {
      profileKey = 'document';
    } else if (analysis.complexityScore > 0.66) {
      profileKey = 'complex';
    } else if (analysis.complexityScore > 0.33) {
      profileKey = 'medium';
    } else {
      profileKey = 'simple';
    }

    final profile = _deepProfiles[profileKey]!;
    final baseTokens = profile.base * _getMultiplier(analysis.contentType);
    final buffer = baseTokens * 0.15 * (2 - analysis.confidence);
    final tokens = (baseTokens + buffer).round().clamp(profile.min, profile.max);

    // Apply historical adjustment
    final adjusted = await _applyHistoricalAdjustment(
      session,
      tokens,
      analysis.contentType,
      analysis.complexityBucket,
      isQuick: false,
    );

    return TokenAllocation(
      tokens: adjusted,
      complexityScore: analysis.complexityScore,
      contentType: analysis.contentType,
      complexityBucket: analysis.complexityBucket,
      confidence: analysis.confidence,
    );
  }

  /// Calculate optimal tokens for text content
  static Future<TokenAllocation> calculateTextTokens(
    Session session,
    String text, {
    bool isQuick = false,
  }) async {
    final analysis = analyzeTextComplexity(text);
    final profiles = isQuick ? _quickProfiles : _deepProfiles;
    final profile = _selectProfile(profiles, analysis.complexityScore);

    final baseTokens = profile.base * _getMultiplier(analysis.contentType);
    final buffer = baseTokens * 0.15 * (2 - analysis.confidence);
    final tokens = (baseTokens + buffer).round().clamp(profile.min, profile.max);

    final adjusted = await _applyHistoricalAdjustment(
      session,
      tokens,
      analysis.contentType,
      analysis.complexityBucket,
      isQuick: isQuick,
    );

    return TokenAllocation(
      tokens: adjusted,
      complexityScore: analysis.complexityScore,
      contentType: analysis.contentType,
      complexityBucket: analysis.complexityBucket,
      confidence: analysis.confidence,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // IMAGE COMPLEXITY ANALYSIS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Analyze image complexity without external libraries
  static Future<ComplexityAnalysis> analyzeImageComplexity(
    Uint8List imageBytes,
  ) async {
    final factors = <String, double>{};

    // Factor 1: File size analysis (15% weight)
    // Larger files often indicate more detail
    final sizeScore = _normalizeScore(imageBytes.length.toDouble(), 50000, 2000000);
    factors['size'] = sizeScore;

    // Factor 2: Compression analysis (10% weight)
    // Low bytes-per-estimated-pixel indicates high compression (simple image)
    // Assuming average image ~1-4MP, calculate bytes per estimated pixel
    final estimatedPixels = imageBytes.length * 10; // rough estimate
    final compressionScore = _normalizeScore(
      imageBytes.length / max(estimatedPixels, 1) * 1000000,
      0.05,
      0.5,
    );
    factors['compression'] = compressionScore;

    // Factor 3: Byte variance analysis (20% weight)
    // High variance in byte values indicates complex/varied content
    final varianceScore = _analyzeByteVariance(imageBytes);
    factors['variance'] = varianceScore;

    // Factor 4: Pattern detection for text (30% weight) - MOST IMPORTANT
    // Text images have specific byte patterns (high contrast, repetitive structures)
    final textScore = _analyzeTextLikelihood(imageBytes);
    factors['text'] = textScore;

    // Factor 5: Entropy analysis (25% weight)
    // Higher entropy = more random/complex data
    final entropyScore = _analyzeEntropy(imageBytes);
    factors['entropy'] = entropyScore;

    // Calculate weighted complexity score
    final complexityScore = (
      factors['size']! * 0.15 +
      factors['compression']! * 0.10 +
      factors['variance']! * 0.20 +
      factors['text']! * 0.30 +
      factors['entropy']! * 0.25
    ).clamp(0.0, 1.0);

    // Determine content type based on analysis
    final contentType = _inferContentType(factors, imageBytes.length);

    // Determine complexity bucket
    final complexityBucket = complexityScore < 0.33
        ? 'simple'
        : complexityScore < 0.66
            ? 'medium'
            : 'complex';

    // Confidence based on how clear the signals are
    final confidence = _calculateConfidence(factors);

    return ComplexityAnalysis(
      complexityScore: complexityScore,
      contentType: contentType,
      complexityBucket: complexityBucket,
      confidence: confidence,
      factors: factors,
    );
  }

  /// Analyze byte variance to detect image complexity
  static double _analyzeByteVariance(Uint8List bytes) {
    if (bytes.length < 100) return 0.5;

    // Sample bytes for efficiency (every 100th byte)
    final sampleSize = min(1000, bytes.length ~/ 100);
    final step = bytes.length ~/ sampleSize;

    double sum = 0;
    double sumSquares = 0;
    int count = 0;

    for (int i = 0; i < bytes.length && count < sampleSize; i += step) {
      final value = bytes[i].toDouble();
      sum += value;
      sumSquares += value * value;
      count++;
    }

    if (count == 0) return 0.5;

    final mean = sum / count;
    final variance = (sumSquares / count) - (mean * mean);
    final stdDev = sqrt(variance);

    // Normalize: stdDev of 0-128 maps to 0-1
    return (stdDev / 128).clamp(0.0, 1.0);
  }

  /// Analyze patterns that indicate text content
  static double _analyzeTextLikelihood(Uint8List bytes) {
    if (bytes.length < 500) return 0.3;

    // Text images characteristics:
    // 1. High contrast (lots of very dark and very light values)
    // 2. Bimodal distribution (peaks at both ends)
    // 3. Repetitive horizontal patterns

    int darkCount = 0;
    int lightCount = 0;
    int midCount = 0;
    int transitions = 0;
    int lastValue = bytes[0];

    final sampleSize = min(5000, bytes.length);
    final step = max(1, bytes.length ~/ sampleSize);

    for (int i = 0; i < bytes.length; i += step) {
      final value = bytes[i];

      if (value < 50) {
        darkCount++;
      } else if (value > 200) {
        lightCount++;
      } else {
        midCount++;
      }

      // Count significant transitions (contrast changes)
      if ((value - lastValue).abs() > 100) {
        transitions++;
      }
      lastValue = value;
    }

    final total = darkCount + lightCount + midCount;
    if (total == 0) return 0.3;

    // Text characteristics scoring
    final bimodalScore = (darkCount + lightCount) / total; // High = text-like
    final contrastScore = transitions / (total / 10); // High = many edges

    // Combine scores
    final textScore = (bimodalScore * 0.6 + contrastScore.clamp(0, 1) * 0.4);

    return textScore.clamp(0.0, 1.0);
  }

  /// Analyze entropy (randomness/complexity)
  static double _analyzeEntropy(Uint8List bytes) {
    if (bytes.length < 100) return 0.5;

    // Build histogram of byte values
    final histogram = List<int>.filled(256, 0);
    final sampleSize = min(10000, bytes.length);
    final step = max(1, bytes.length ~/ sampleSize);
    int total = 0;

    for (int i = 0; i < bytes.length; i += step) {
      histogram[bytes[i]]++;
      total++;
    }

    // Calculate Shannon entropy
    double entropy = 0;
    for (int i = 0; i < 256; i++) {
      if (histogram[i] > 0) {
        final p = histogram[i] / total;
        entropy -= p * log(p) / ln2;
      }
    }

    // Normalize: max entropy is 8 bits
    return (entropy / 8).clamp(0.0, 1.0);
  }

  /// Infer content type from analysis factors
  static String _inferContentType(Map<String, double> factors, int fileSize) {
    final textScore = factors['text'] ?? 0;
    final entropyScore = factors['entropy'] ?? 0;
    final varianceScore = factors['variance'] ?? 0;

    // High text likelihood = document/screenshot
    if (textScore > 0.7) {
      return 'document';
    }

    // Medium-high text with structure = could be recipe/calendar
    if (textScore > 0.5 && entropyScore > 0.6) {
      return 'recipe_or_instructions';
    }

    // Low variance, low entropy = simple graphic
    if (varianceScore < 0.3 && entropyScore < 0.4) {
      return 'simple_graphic';
    }

    // High entropy, medium text = diagram
    if (entropyScore > 0.7 && textScore > 0.3 && textScore < 0.6) {
      return 'diagram';
    }

    // Small file with low complexity = short note
    if (fileSize < 100000 && textScore < 0.4) {
      return 'short_note';
    }

    // Default to photo
    return 'photo';
  }

  /// Calculate confidence in the analysis
  static double _calculateConfidence(Map<String, double> factors) {
    // High confidence when factors are clearly high or low (not middle)
    double clarity = 0;
    int count = 0;

    for (final value in factors.values) {
      // Distance from 0.5 (middle) indicates clearer signal
      clarity += (value - 0.5).abs() * 2;
      count++;
    }

    return count > 0 ? (clarity / count).clamp(0.5, 1.0) : 0.7;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TEXT COMPLEXITY ANALYSIS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Analyze text complexity
  static ComplexityAnalysis analyzeTextComplexity(String text) {
    final factors = <String, double>{};

    // Factor 1: Length (30% weight)
    final lengthScore = _normalizeScore(text.length.toDouble(), 50, 5000);
    factors['length'] = lengthScore;

    // Factor 2: Vocabulary diversity (15% weight)
    final words = text.toLowerCase().split(RegExp(r'\s+'));
    final uniqueWords = words.toSet().length;
    final vocabScore = words.isNotEmpty
        ? (uniqueWords / words.length).clamp(0.0, 1.0)
        : 0.5;
    factors['vocabulary'] = vocabScore;

    // Factor 3: Sentence complexity (15% weight)
    final sentences = text.split(RegExp(r'[.!?]+'));
    final avgWordsPerSentence = sentences.isNotEmpty
        ? words.length / sentences.length
        : 10;
    final sentenceScore = _normalizeScore(avgWordsPerSentence.toDouble(), 5, 30);
    factors['sentences'] = sentenceScore;

    // Factor 4: Special content - dates, numbers, lists (25% weight)
    final datePattern = RegExp(r'\d{1,4}[-/]\d{1,2}[-/]\d{1,4}|\b\d{1,2}(?:st|nd|rd|th)?\b');
    final numberPattern = RegExp(r'\b\d+(?:\.\d+)?\b');
    final listPattern = RegExp(r'^\s*[-•*]\s|^\s*\d+\.\s', multiLine: true);

    final dateMatches = datePattern.allMatches(text).length;
    final numberMatches = numberPattern.allMatches(text).length;
    final listMatches = listPattern.allMatches(text).length;

    final specialScore = _normalizeScore(
      (dateMatches * 3 + numberMatches + listMatches * 2).toDouble(),
      0,
      20,
    );
    factors['special'] = specialScore;

    // Factor 5: Structure - headers, paragraphs (15% weight)
    final paragraphs = text.split(RegExp(r'\n\s*\n'));
    final structureScore = _normalizeScore(paragraphs.length.toDouble(), 1, 10);
    factors['structure'] = structureScore;

    // Calculate weighted complexity
    final complexityScore = (
      factors['length']! * 0.30 +
      factors['vocabulary']! * 0.15 +
      factors['sentences']! * 0.15 +
      factors['special']! * 0.25 +
      factors['structure']! * 0.15
    ).clamp(0.0, 1.0);

    // Determine content type
    String contentType;
    if (text.length < 100) {
      contentType = 'short_note';
    } else if (specialScore > 0.6) {
      contentType = 'recipe_or_instructions';
    } else if (structureScore > 0.6) {
      contentType = 'article';
    } else {
      contentType = 'document';
    }

    final complexityBucket = complexityScore < 0.33
        ? 'simple'
        : complexityScore < 0.66
            ? 'medium'
            : 'complex';

    return ComplexityAnalysis(
      complexityScore: complexityScore,
      contentType: contentType,
      complexityBucket: complexityBucket,
      confidence: _calculateConfidence(factors),
      factors: factors,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HISTORICAL LEARNING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Apply historical adjustment based on past performance
  static Future<int> _applyHistoricalAdjustment(
    Session session,
    int baseTokens,
    String contentType,
    String complexityBucket, {
    required bool isQuick,
  }) async {
    try {
      // Query recent history for this content type + complexity
      final history = await TokenUsageHistory.db.find(
        session,
        where: (t) =>
            t.contentType.equals(contentType) &
            t.complexityBucket.equals(complexityBucket) &
            t.isQuickAnalysis.equals(isQuick),
        orderBy: (t) => t.createdAt,
        orderDescending: true,
        limit: 50,
      );

      if (history.length < 5) {
        // Not enough data, return base tokens
        return baseTokens;
      }

      // Calculate efficiency and incomplete rate
      double totalEfficiency = 0;
      int incompleteCount = 0;

      for (final record in history) {
        if (record.tokensAllocated > 0) {
          totalEfficiency += record.tokensUsed / record.tokensAllocated;
        }
        if (!record.wasComplete) {
          incompleteCount++;
        }
      }

      final avgEfficiency = totalEfficiency / history.length;
      final incompleteRate = incompleteCount / history.length;

      // Apply adjustment rules
      double adjustment = 1.0;

      if (incompleteRate > 0.10) {
        // Too many truncations - increase by 25%
        adjustment = 1.25;
        session.log('Token adjustment: +25% (incomplete rate: ${(incompleteRate * 100).toStringAsFixed(1)}%)');
      } else if (avgEfficiency < 0.70 && incompleteRate < 0.05) {
        // Over-allocating - reduce by 15%
        adjustment = 0.85;
        session.log('Token adjustment: -15% (efficiency: ${(avgEfficiency * 100).toStringAsFixed(1)}%)');
      }

      return (baseTokens * adjustment).round();
    } catch (e) {
      // If history lookup fails, return base tokens
      session.log('Historical adjustment skipped: $e');
      return baseTokens;
    }
  }

  /// Record token usage for learning
  static Future<void> recordUsage(
    Session session, {
    required String contentType,
    required String complexityBucket,
    required int tokensAllocated,
    required int tokensUsed,
    required bool wasComplete,
    required bool isQuickAnalysis,
    double? complexityScore,
  }) async {
    try {
      final record = TokenUsageHistory(
        contentType: contentType,
        complexityBucket: complexityBucket,
        complexityScore: complexityScore,
        tokensAllocated: tokensAllocated,
        tokensUsed: tokensUsed,
        wasComplete: wasComplete,
        isQuickAnalysis: isQuickAnalysis,
        createdAt: DateTime.now(),
      );

      await TokenUsageHistory.db.insertRow(session, record);

      final efficiency = tokensAllocated > 0
          ? (tokensUsed / tokensAllocated * 100).toStringAsFixed(1)
          : '0';
      session.log(
        'Token usage recorded: $contentType/$complexityBucket '
        'allocated=$tokensAllocated used=$tokensUsed '
        'efficiency=$efficiency% complete=$wasComplete',
      );
    } catch (e) {
      session.log('Failed to record token usage: $e');
    }
  }

  /// Calculate tokens needed for retry after truncation
  static int calculateRetryTokens(int previousTokens, {int maxTokens = 4096}) {
    // Increase by 50% but cap at max
    return min((previousTokens * 1.5).round(), maxTokens);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  static TokenProfile _selectProfile(
    Map<String, TokenProfile> profiles,
    double complexityScore,
  ) {
    if (complexityScore < 0.33) {
      return profiles['simple']!;
    } else if (complexityScore < 0.66) {
      return profiles['medium']!;
    } else {
      return profiles['complex'] ?? profiles['medium']!;
    }
  }

  static double _getMultiplier(String contentType) {
    return _contentMultipliers[contentType] ?? 1.0;
  }

  static double _normalizeScore(double value, double min, double max) {
    return ((value - min) / (max - min)).clamp(0.0, 1.0);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DATA CLASSES
// ═══════════════════════════════════════════════════════════════════════════

/// Token profile configuration
class TokenProfile {
  final int base;
  final int min;
  final int max;

  const TokenProfile({
    required this.base,
    required this.min,
    required this.max,
  });
}

/// Result of complexity analysis
class ComplexityAnalysis {
  final double complexityScore;
  final String contentType;
  final String complexityBucket;
  final double confidence;
  final Map<String, double> factors;

  const ComplexityAnalysis({
    required this.complexityScore,
    required this.contentType,
    required this.complexityBucket,
    required this.confidence,
    required this.factors,
  });

  @override
  String toString() {
    return 'ComplexityAnalysis(score: ${complexityScore.toStringAsFixed(2)}, '
        'type: $contentType, bucket: $complexityBucket, '
        'confidence: ${confidence.toStringAsFixed(2)})';
  }
}

/// Token allocation result
class TokenAllocation {
  final int tokens;
  final double complexityScore;
  final String contentType;
  final String complexityBucket;
  final double confidence;

  const TokenAllocation({
    required this.tokens,
    required this.complexityScore,
    required this.contentType,
    required this.complexityBucket,
    required this.confidence,
  });

  @override
  String toString() {
    return 'TokenAllocation(tokens: $tokens, type: $contentType, '
        'bucket: $complexityBucket, score: ${complexityScore.toStringAsFixed(2)})';
  }
}

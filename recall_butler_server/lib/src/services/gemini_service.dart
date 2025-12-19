import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'token_optimizer_service.dart';
import 'multi_model_service.dart';

/// Service for interacting with Google Gemini AI
/// Uses Intelligent Adaptive Token Management for optimal API usage
class GeminiService {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';
  static const String _modelFast = 'gemini-2.5-flash'; // Fast model for quick analysis
  static const String _modelDeep = 'gemini-2.5-flash'; // Better model for deep analysis
  static const int _maxRetries = 3;
  static const int _maxTokensAbsolute = 4096; // Absolute max for safety

  // ═══════════════════════════════════════════════════════════════════════
  // QUICK ANALYSIS - Used in sync path (must be fast, <500ms target)
  // ═══════════════════════════════════════════════════════════════════════

  /// Quick analysis for immediate response - simple description and type detection
  /// Uses adaptive token allocation based on image complexity
  static Future<QuickAnalysisResult> quickAnalysis(
    Session session,
    String type,
    Uint8List imageBytes,
  ) async {
    final apiKey = session.passwords['geminiApiKey'];
    if (apiKey == null) {
      return QuickAnalysisResult(
        description: 'Processing...',
        detectedType: 'other',
        confidence: 0.0,
      );
    }

    // Calculate optimal tokens based on image complexity
    final tokenAllocation = await TokenOptimizerService.calculateQuickTokens(
      session,
      imageBytes,
    );
    session.log(
      'Quick analysis token allocation: ${tokenAllocation.tokens} '
      '(type: ${tokenAllocation.contentType}, complexity: ${tokenAllocation.complexityScore.toStringAsFixed(2)})',
    );

    final base64Image = base64Encode(imageBytes);

    final prompt = '''
Analyze this image quickly. Return ONLY valid JSON (no markdown):
{"description":"One sentence description max 15 words","detectedType":"recipe|task|reminder|event|note|shopping|calendar|other","confidence":0.8}
''';

    int tokensUsed = 0;
    bool wasComplete = false;

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$_modelFast:generateContent?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt},
                {
                  'inline_data': {
                    'mime_type': 'image/jpeg',
                    'data': base64Image,
                  }
                }
              ]
            }
          ],
          'generationConfig': {
            'maxOutputTokens': tokenAllocation.tokens,
            'temperature': 0.1,
          }
        }),
      ).timeout(const Duration(seconds: 5)); // Strict timeout

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates'][0]['content']['parts'][0]['text'];

        // Check if response was complete
        final finishReason = data['candidates'][0]['finishReason'] ?? 'STOP';
        wasComplete = finishReason == 'STOP';

        // Estimate tokens used (rough: ~4 chars per token)
        tokensUsed = (text.length / 4).round();

        final cleanedText = _extractJson(text);
        final parsed = jsonDecode(cleanedText);

        // Record usage for learning
        await TokenOptimizerService.recordUsage(
          session,
          contentType: tokenAllocation.contentType,
          complexityBucket: tokenAllocation.complexityBucket,
          tokensAllocated: tokenAllocation.tokens,
          tokensUsed: tokensUsed,
          wasComplete: wasComplete,
          isQuickAnalysis: true,
          complexityScore: tokenAllocation.complexityScore,
        );

        return QuickAnalysisResult(
          description: parsed['description'] ?? 'Image captured',
          detectedType: parsed['detectedType'] ?? 'other',
          confidence: (parsed['confidence'] ?? 0.5).toDouble(),
        );
      }
    } catch (e) {
      session.log('Quick analysis failed: $e', level: LogLevel.warning);
    }

    // Safe fallback on any error
    return QuickAnalysisResult(
      description: 'Image captured - analyzing...',
      detectedType: 'other',
      confidence: 0.0,
    );
  }

  /// Process a capture with Gemini AI
  /// Optionally accepts imageBytes to avoid re-fetching from storage
  static Future<AIProcessingResult> processCapture(
    Session session,
    Capture capture, {
    Uint8List? imageBytes,
  }) async {
    final apiKey = session.passwords['geminiApiKey'];
    if (apiKey == null) {
      throw Exception('Gemini API key not configured');
    }

    switch (capture.type) {
      case 'screenshot':
      case 'photo':
        return await _processImage(session, capture, apiKey, imageBytes: imageBytes);
      case 'voice':
        return await _processVoice(session, capture, apiKey);
      case 'link':
        return await _processLink(session, capture, apiKey);
      default:
        return AIProcessingResult(
          tags: [],
          category: 'Other',
          isReminder: false,
        );
    }
  }

  /// Process image capture with Gemini Vision
  /// Accepts optional imageBytes to skip fetching from URL (faster)
  static Future<AIProcessingResult> _processImage(
    Session session,
    Capture capture,
    String apiKey, {
    Uint8List? imageBytes,
  }) async {
    Uint8List bytes;
    String mimeType;

    // Use provided bytes if available (faster), otherwise fetch from URL
    if (imageBytes != null) {
      bytes = imageBytes;
      mimeType = 'image/jpeg'; // Thumbnail is always JPEG
    } else if (capture.thumbnailUrl != null || capture.originalUrl != null) {
      // Prefer thumbnail (smaller = faster processing)
      final url = capture.thumbnailUrl ?? capture.originalUrl!;
      final imageResponse = await http.get(Uri.parse(url));
      if (imageResponse.statusCode != 200) {
        throw Exception('Failed to fetch image');
      }
      bytes = imageResponse.bodyBytes;
      mimeType = _getMimeType(url);
    } else {
      return AIProcessingResult(
        tags: [],
        category: 'Other',
        isReminder: false,
      );
    }

    final base64Image = base64Encode(bytes);

    final prompt = '''
You are a smart personal assistant analyzing an image to extract important information and set intelligent reminders.

CRITICAL: If this is a CALENDAR image:
1. Identify the month and year shown (e.g., "January 2026")
2. Go through EACH DAY that has any text/event marked
3. Create a SEPARATE actionItem for EACH event found
4. Use EXACT date format YYYY-MM-DD

Return ONLY valid JSON (no markdown, no code blocks):
{
  "extractedText": "All visible text with dates",
  "description": "Brief description of image content",
  "tags": ["calendar", "birthday", "festival"],
  "category": "Personal",
  "isReminder": true,
  "actionItems": [
    {
      "type": "birthday",
      "title": "Billy's Birthday",
      "dueAt": "2026-01-19",
      "priority": "high",
      "reminderDaysBefore": 1,
      "notes": "Remember to wish Billy and arrange gift"
    },
    {
      "type": "event",
      "title": "Republic Day",
      "dueAt": "2026-01-26",
      "priority": "low",
      "reminderDaysBefore": 0,
      "notes": "National holiday"
    }
  ]
}

═══ INTELLIGENT PRIORITY RULES ═══

HIGH PRIORITY (personal/actionable - user needs to DO something):
- Birthdays of people (need to wish, buy gift)
- Anniversaries (personal dates)
- Personal appointments (doctor, meetings)
- Deadlines (bills, submissions, exams)
- Work tasks with dates

MEDIUM PRIORITY (important awareness):
- Religious festivals user might celebrate (based on context)
- Family events
- Travel dates
- Scheduled activities

LOW PRIORITY (general awareness - no action needed):
- Public holidays (Independence Day, Republic Day)
- General festivals (unless clearly personal)
- Bank holidays
- Events that don't require user action

═══ SMART REMINDER TIMING ═══

Set "reminderDaysBefore" based on event type:
- Birthday: 1-2 days before (time to arrange gift/wish)
- Deadline: 2-3 days before (time to prepare)
- Appointment: 1 day before
- Festival/Holiday: 0 (remind on the day)
- Anniversary: 3-7 days before (time to plan)

═══ TYPE CLASSIFICATION ═══

- "birthday" - Someone's birthday
- "anniversary" - Wedding/relationship anniversaries
- "deadline" - Due dates, submissions, payments
- "appointment" - Doctor, meetings, calls
- "event" - Festivals, holidays, celebrations
- "task" - Things to do
- "reminder" - General reminders

Extract EVERY date visible. Prioritize personal events over generic ones.
''';

    // Calculate optimal tokens based on image complexity
    final tokenAllocation = await TokenOptimizerService.calculateDeepTokens(
      session,
      bytes,
    );
    session.log(
      'Deep analysis token allocation: ${tokenAllocation.tokens} '
      '(type: ${tokenAllocation.contentType}, complexity: ${tokenAllocation.complexityScore.toStringAsFixed(2)})',
    );

    final requestBody = {
      'contents': [
        {
          'parts': [
            {'text': prompt},
            {
              'inline_data': {
                'mime_type': mimeType,
                'data': base64Image,
              }
            }
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.1,
        'maxOutputTokens': tokenAllocation.tokens,
      }
    };

    return await _callGeminiWithRetry(
      session,
      apiKey,
      requestBody,
      tokenAllocation,
    );
  }

  /// Process voice capture
  static Future<AIProcessingResult> _processVoice(
    Session session,
    Capture capture,
    String apiKey,
  ) async {
    if (capture.originalUrl == null) {
      return AIProcessingResult(
        tags: [],
        category: 'Other',
        isReminder: false,
      );
    }

    // Fetch the audio data
    final audioResponse = await http.get(Uri.parse(capture.originalUrl!));
    if (audioResponse.statusCode != 200) {
      throw Exception('Failed to fetch audio');
    }

    final base64Audio = base64Encode(audioResponse.bodyBytes);

    final prompt = '''
Transcribe this audio and analyze it. Return a JSON response:
{
  "extractedText": "Full transcription of the audio",
  "description": "Brief summary of what was said",
  "tags": ["tag1", "tag2", "tag3"],
  "category": "One of: Work, Personal, Recipe, Shopping, Travel, Health, Finance, Learning, Other",
  "isReminder": true or false,
  "actionItems": ["action1", "action2"] (extract any tasks or action items mentioned)
}
''';

    final requestBody = {
      'contents': [
        {
          'parts': [
            {'text': prompt},
            {
              'inline_data': {
                'mime_type': 'audio/wav',
                'data': base64Audio,
              }
            }
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.1,
        'maxOutputTokens': 2048,
      }
    };

    return await _callGemini(apiKey, requestBody);
  }

  /// Process link capture
  static Future<AIProcessingResult> _processLink(
    Session session,
    Capture capture,
    String apiKey,
  ) async {
    if (capture.originalUrl == null) {
      return AIProcessingResult(
        tags: [],
        category: 'Other',
        isReminder: false,
      );
    }

    // Fetch the webpage content
    String pageContent;
    try {
      final response = await http.get(
        Uri.parse(capture.originalUrl!),
        headers: {'User-Agent': 'RecallButler/1.0'},
      );
      pageContent = response.body;
      // Limit content length
      if (pageContent.length > 10000) {
        pageContent = pageContent.substring(0, 10000);
      }
    } catch (e) {
      pageContent = 'URL: ${capture.originalUrl}';
    }

    final prompt = '''
Analyze this webpage content and return a JSON response:
{
  "extractedText": "Key content and main points from the page",
  "description": "Brief summary of what this page is about",
  "tags": ["tag1", "tag2", "tag3", "tag4", "tag5"],
  "category": "One of: Work, Personal, Recipe, Shopping, Travel, Health, Finance, Learning, Other",
  "isReminder": false,
  "actionItems": null
}

Webpage content:
$pageContent
''';

    final requestBody = {
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.1,
        'maxOutputTokens': 1024,
      }
    };

    return await _callGemini(apiKey, requestBody);
  }

  /// Expand search query with related terms
  static Future<List<String>> expandSearchQuery(
    Session session,
    String query,
  ) async {
    final apiKey = session.passwords['geminiApiKey'];
    if (apiKey == null) {
      return [query];
    }

    final prompt = '''
Given the search query "$query", generate a list of related search terms that would help find relevant content. Include synonyms, related concepts, and variations.

Return only a JSON array of strings, e.g.: ["term1", "term2", "term3"]

Keep the list to 5-10 highly relevant terms.
''';

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$_modelDeep:generateContent?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.3,
            'maxOutputTokens': 256,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates'][0]['content']['parts'][0]['text'];
        final cleanedText = _extractJson(text);
        final terms = List<String>.from(jsonDecode(cleanedText));
        return [query, ...terms];
      }
    } catch (e) {
      // Fall back to original query
    }

    return [query];
  }

  /// Rerank search results by relevance
  static Future<List<int>> rerankResults(
    Session session,
    String query,
    List<Capture> captures,
  ) async {
    final apiKey = session.passwords['geminiApiKey'];
    if (apiKey == null || captures.isEmpty) {
      return List.generate(captures.length, (i) => i);
    }

    // Build context for each capture
    final captureDescriptions = captures.asMap().entries.map((entry) {
      final c = entry.value;
      return '${entry.key}: ${c.aiSummary ?? c.extractedText ?? c.type}';
    }).join('\n');

    final prompt = '''
Given the search query: "$query"

Rank these captures by relevance (most relevant first):
$captureDescriptions

Return only a JSON array of the indices in order of relevance, e.g.: [2, 0, 1, 3]
''';

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$_modelDeep:generateContent?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.1,
            'maxOutputTokens': 128,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates'][0]['content']['parts'][0]['text'];
        final cleanedText = _extractJson(text);
        return List<int>.from(jsonDecode(cleanedText));
      }
    } catch (e) {
      // Fall back to original order
    }

    return List.generate(captures.length, (i) => i);
  }

  /// Generate morning briefing summary
  static Future<String> generateMorningBriefing(
    Session session,
    List<Action> todayActions,
    List<Capture> recentCaptures,
  ) async {
    final apiKey = session.passwords['geminiApiKey'];
    if (apiKey == null) {
      return 'Good morning! You have ${todayActions.length} tasks today.';
    }

    final actionsSummary = todayActions.isEmpty
        ? 'No tasks scheduled for today.'
        : todayActions.map((a) => '- ${a.title} (${a.priority} priority)').join('\n');

    final capturesSummary = recentCaptures.isEmpty
        ? 'No recent captures.'
        : recentCaptures.map((c) => '- ${c.aiSummary ?? c.type}').join('\n');

    final prompt = '''
Generate a brief, friendly morning briefing like a butler would give. Include:
1. A warm greeting
2. Quick summary of today's tasks
3. Any highlights from recent captures

Today's tasks:
$actionsSummary

Recent captures (last 24h):
$capturesSummary

Keep it to 2-3 sentences, warm and helpful. Don't use bullet points.
''';

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$_modelDeep:generateContent?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 256,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      }
    } catch (e) {
      // Fall back to generic message
    }

    return 'Good morning! You have ${todayActions.length} tasks today and ${recentCaptures.length} recent captures.';
  }

  /// Extract action items from capture content
  static Future<List<Map<String, dynamic>>> extractActions(
    Session session,
    Capture capture,
  ) async {
    final apiKey = session.passwords['geminiApiKey'];
    if (apiKey == null) {
      return [];
    }

    final content = capture.extractedText ?? capture.aiSummary ?? '';
    if (content.isEmpty) {
      return [];
    }

    final prompt = '''
Analyze this content and extract any action items, tasks, reminders, or events.

Content: "$content"
Category: ${capture.category}

Return a JSON array of action items. Each item should have:
{
  "type": "task" | "reminder" | "event" | "shopping",
  "title": "Brief action description",
  "notes": "Additional details if any",
  "dueAt": "ISO date string if a date/time is mentioned, null otherwise",
  "priority": "low" | "medium" | "high"
}

Only extract clear, actionable items. If there are no actions, return an empty array [].
Be conservative - only extract items that are clearly actionable.
''';

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$_modelDeep:generateContent?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.1,
            'maxOutputTokens': 512,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates'][0]['content']['parts'][0]['text'];
        final cleanedText = _extractJson(text);
        final actions = jsonDecode(cleanedText);
        if (actions is List) {
          return actions.cast<Map<String, dynamic>>();
        }
      }
    } catch (e) {
      // Fall back to empty list
    }

    return [];
  }

  /// Generate weekly digest summary
  static Future<String> generateWeeklyDigest(
    Session session,
    List<Capture> captures,
  ) async {
    final apiKey = session.passwords['geminiApiKey'];
    if (apiKey == null || captures.isEmpty) {
      return 'No captures this week.';
    }

    final capturesSummary = captures.map((c) {
      return '- ${c.type}: ${c.aiSummary ?? c.extractedText ?? 'No description'}';
    }).join('\n');

    final prompt = '''
Generate a brief, friendly weekly digest summary for these captures:

$capturesSummary

Write 2-3 sentences highlighting the main themes and any important items.
Be conversational and helpful, like a butler summarizing the week.
''';

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$_modelDeep:generateContent?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 256,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      }
    } catch (e) {
      // Fall back to generic message
    }

    return 'You captured ${captures.length} items this week.';
  }

  /// Call Gemini API with retry logic for truncated responses
  /// Uses adaptive token management and records usage for learning
  static Future<AIProcessingResult> _callGeminiWithRetry(
    Session session,
    String apiKey,
    Map<String, dynamic> requestBody,
    TokenAllocation tokenAllocation,
  ) async {
    int currentTokens = tokenAllocation.tokens;
    int retryCount = 0;
    const maxTruncationRetries = 2;

    while (retryCount <= maxTruncationRetries) {
      // Update token count in request body
      requestBody['generationConfig']['maxOutputTokens'] = currentTokens;

      http.Response? response;

      // Retry logic with exponential backoff for rate limit (429) and server errors (503)
      for (int attempt = 0; attempt < _maxRetries; attempt++) {
        response = await http.post(
          Uri.parse('$_baseUrl/$_modelDeep:generateContent?key=$apiKey'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody),
        );

        if (response.statusCode == 200) {
          break;
        }

        // Handle rate limit (429) and server unavailable (503) with exponential backoff
        if (response.statusCode == 503 || response.statusCode == 429) {
          if (attempt < _maxRetries - 1) {
            // Longer backoff for rate limits: 2s, 4s, 8s
            final delaySeconds = 2 << attempt;
            session.log('Rate limited (${response.statusCode}), retrying in ${delaySeconds}s (attempt ${attempt + 1}/$_maxRetries)');
            await Future.delayed(Duration(seconds: delaySeconds));
            continue;
          }
          // Last attempt failed with rate limit - throw specific exception
          throw RateLimitException('gemini', 'Gemini API rate limited (429) after $_maxRetries retries');
        }

        // For other errors, throw immediately
        throw Exception('Gemini API error: ${response.statusCode}');
      }

      if (response == null || response.statusCode != 200) {
        throw Exception('Gemini API error: unexpected state');
      }

      final data = jsonDecode(response.body);
      final text = data['candidates'][0]['content']['parts'][0]['text'];

      // Check if response was truncated
      final finishReason = data['candidates'][0]['finishReason'] ?? 'STOP';
      final wasComplete = finishReason == 'STOP';

      // Estimate tokens used
      final tokensUsed = (text.length / 4).round();

      if (!wasComplete && retryCount < maxTruncationRetries) {
        // Response was truncated - retry with more tokens
        session.log(
          'Response truncated (finishReason: $finishReason). '
          'Retrying with more tokens: $currentTokens -> ${TokenOptimizerService.calculateRetryTokens(currentTokens)}',
        );

        // Record the truncation for learning
        await TokenOptimizerService.recordUsage(
          session,
          contentType: tokenAllocation.contentType,
          complexityBucket: tokenAllocation.complexityBucket,
          tokensAllocated: currentTokens,
          tokensUsed: tokensUsed,
          wasComplete: false,
          isQuickAnalysis: false,
          complexityScore: tokenAllocation.complexityScore,
        );

        currentTokens = TokenOptimizerService.calculateRetryTokens(
          currentTokens,
          maxTokens: _maxTokensAbsolute,
        );
        retryCount++;
        continue;
      }

      // Record successful usage for learning
      await TokenOptimizerService.recordUsage(
        session,
        contentType: tokenAllocation.contentType,
        complexityBucket: tokenAllocation.complexityBucket,
        tokensAllocated: currentTokens,
        tokensUsed: tokensUsed,
        wasComplete: wasComplete,
        isQuickAnalysis: false,
        complexityScore: tokenAllocation.complexityScore,
      );

      session.log(
        'API call complete: allocated=$currentTokens used=$tokensUsed '
        'efficiency=${(tokensUsed / currentTokens * 100).toStringAsFixed(1)}% '
        'complete=$wasComplete',
      );

      // Parse and return result
      return _parseGeminiResponse(text);
    }

    throw Exception('Failed to get complete response after $maxTruncationRetries truncation retries');
  }

  /// Parse Gemini response text into AIProcessingResult
  static AIProcessingResult _parseGeminiResponse(String text) {
    final jsonText = _extractJson(text);

    try {
      final parsed = jsonDecode(jsonText);

      List<Map<String, dynamic>>? structuredActions;
      if (parsed['actionItems'] != null && parsed['actionItems'] is List) {
        structuredActions = [];
        for (final item in parsed['actionItems']) {
          if (item is String) {
            structuredActions.add({
              'type': 'task',
              'title': item,
              'priority': 'medium',
            });
          } else if (item is Map) {
            structuredActions.add(Map<String, dynamic>.from(item));
          }
        }
      }

      final result = AIProcessingResult(
        extractedText: parsed['extractedText'] ?? '',
        description: parsed['description'] ?? 'AI processing completed',
        tags: List<String>.from(parsed['tags'] ?? []),
        category: parsed['category'] ?? 'Other',
        isReminder: parsed['isReminder'] ?? false,
        structuredActionsJson: structuredActions != null && structuredActions.isNotEmpty
            ? jsonEncode(structuredActions)
            : null,
      );

      if (structuredActions != null && structuredActions.isNotEmpty) {
        print('AI extracted ${structuredActions.length} action items');
      }

      return result;
    } catch (e, stackTrace) {
      print('JSON parsing failed: $e');
      print('Stack: $stackTrace');

      // Try fallback extraction
      List<Map<String, dynamic>>? fallbackActions;
      try {
        final actionItemsMatch = RegExp(r'"actionItems"\s*:\s*\[([\s\S]*?)\]').firstMatch(jsonText);
        if (actionItemsMatch != null) {
          final actionItemsJson = '[${actionItemsMatch.group(1)}]';
          final items = jsonDecode(actionItemsJson);
          if (items is List && items.isNotEmpty) {
            fallbackActions = [];
            for (final item in items) {
              if (item is Map) {
                fallbackActions.add(Map<String, dynamic>.from(item));
              }
            }
          }
        }
      } catch (_) {}

      return AIProcessingResult(
        extractedText: text.length > 500 ? text.substring(0, 500) : text,
        description: 'Content captured',
        tags: ['captured'],
        category: 'Other',
        isReminder: false,
        structuredActionsJson: fallbackActions != null && fallbackActions.isNotEmpty
            ? jsonEncode(fallbackActions)
            : null,
      );
    }
  }

  /// Call Gemini API and parse response (legacy - used by other methods)
  static Future<AIProcessingResult> _callGemini(
    String apiKey,
    Map<String, dynamic> requestBody,
  ) async {
    http.Response? response;

    // Retry logic with exponential backoff for 503 errors
    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      response = await http.post(
        Uri.parse('$_baseUrl/$_modelDeep:generateContent?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        break; // Success, exit retry loop
      }

      // If 503 or 429 (rate limit), wait and retry
      if (response.statusCode == 503 || response.statusCode == 429) {
        if (attempt < _maxRetries - 1) {
          // Exponential backoff: 1s, 2s, 4s (faster retries)
          await Future.delayed(Duration(seconds: 1 << attempt));
          continue;
        }
      }

      // For other errors, throw immediately
      throw Exception('Gemini API error: ${response.statusCode}');
    }

    if (response == null || response.statusCode != 200) {
      throw Exception('Gemini API error after $_maxRetries retries: ${response?.statusCode}');
    }

    final data = jsonDecode(response.body);
    final text = data['candidates'][0]['content']['parts'][0]['text'];

    // Extract JSON from response
    final jsonText = _extractJson(text);

    try {
      final parsed = jsonDecode(jsonText);

      // Handle actionItems - can be list of strings or list of objects
      List<Map<String, dynamic>>? structuredActions;
      if (parsed['actionItems'] != null && parsed['actionItems'] is List) {
        structuredActions = [];
        for (final item in parsed['actionItems']) {
          if (item is String) {
            // Legacy format: simple string
            structuredActions.add({
              'type': 'task',
              'title': item,
              'priority': 'medium',
            });
          } else if (item is Map) {
            // New format: structured object
            structuredActions.add(Map<String, dynamic>.from(item));
          }
        }
      }

      final result = AIProcessingResult(
        extractedText: parsed['extractedText'] ?? '',
        description: parsed['description'] ?? 'AI processing completed',
        tags: List<String>.from(parsed['tags'] ?? []),
        category: parsed['category'] ?? 'Other',
        isReminder: parsed['isReminder'] ?? false,
        structuredActionsJson: structuredActions != null && structuredActions.isNotEmpty
            ? jsonEncode(structuredActions)
            : null,
      );

      // Log success with action count
      if (structuredActions != null && structuredActions.isNotEmpty) {
        print('AI extracted ${structuredActions.length} action items');
      }

      return result;
    } catch (e, stackTrace) {
      // If JSON parsing fails, try to extract actionItems manually
      print('JSON parsing failed: $e');
      print('Stack: $stackTrace');
      print('Attempting to extract data from raw text...');

      // Try to extract actionItems even if full JSON parsing fails
      List<Map<String, dynamic>>? fallbackActions;
      try {
        // Look for actionItems array in the text
        final actionItemsMatch = RegExp(r'"actionItems"\s*:\s*\[([\s\S]*?)\]').firstMatch(jsonText);
        if (actionItemsMatch != null) {
          final actionItemsJson = '[${actionItemsMatch.group(1)}]';
          final items = jsonDecode(actionItemsJson);
          if (items is List && items.isNotEmpty) {
            fallbackActions = [];
            for (final item in items) {
              if (item is Map) {
                fallbackActions.add(Map<String, dynamic>.from(item));
              }
            }
            print('Fallback: extracted ${fallbackActions.length} action items');
          }
        }
      } catch (e2) {
        print('Fallback extraction also failed: $e2');
      }

      return AIProcessingResult(
        extractedText: text.length > 500 ? text.substring(0, 500) : text,
        description: 'Content captured',
        tags: ['captured'],
        category: 'Other',
        isReminder: false,
        structuredActionsJson: fallbackActions != null && fallbackActions.isNotEmpty
            ? jsonEncode(fallbackActions)
            : null,
      );
    }
  }

  /// Extract JSON from potentially wrapped response
  static String _extractJson(String text) {
    // Remove markdown code blocks if present
    text = text.trim();
    if (text.startsWith('```json')) {
      text = text.substring(7);
    } else if (text.startsWith('```')) {
      text = text.substring(3);
    }
    if (text.endsWith('```')) {
      text = text.substring(0, text.length - 3);
    }
    text = text.trim();

    // Try to fix common JSON issues from LLM responses
    // Find the last closing brace to handle truncated responses
    final lastBrace = text.lastIndexOf('}');
    if (lastBrace != -1 && lastBrace < text.length - 1) {
      text = text.substring(0, lastBrace + 1);
    }

    // If JSON is truncated (no closing brace), try to fix it
    if (!text.endsWith('}')) {
      // Count open braces and try to close them
      int openBraces = 0;
      int openBrackets = 0;
      bool inString = false;
      bool escaped = false;

      for (int i = 0; i < text.length; i++) {
        final char = text[i];
        if (escaped) {
          escaped = false;
          continue;
        }
        if (char == '\\') {
          escaped = true;
          continue;
        }
        if (char == '"') {
          inString = !inString;
          continue;
        }
        if (!inString) {
          if (char == '{') openBraces++;
          if (char == '}') openBraces--;
          if (char == '[') openBrackets++;
          if (char == ']') openBrackets--;
        }
      }

      // If we're in a string, close it
      if (inString) {
        text += '"';
      }

      // Close any open brackets/braces
      for (int i = 0; i < openBrackets; i++) {
        text += ']';
      }
      for (int i = 0; i < openBraces; i++) {
        text += '}';
      }
    }

    return text;
  }

  /// Get MIME type from URL
  static String _getMimeType(String url) {
    final lower = url.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
    if (lower.endsWith('.gif')) return 'image/gif';
    if (lower.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg'; // Default
  }
}

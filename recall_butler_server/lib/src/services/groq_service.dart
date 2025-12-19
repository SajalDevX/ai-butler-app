import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Service for interacting with Groq AI API
/// Used as fallback when Gemini API rate limits are exceeded
/// Note: Groq doesn't support vision/images - use for text-only tasks
class GroqService {
  static const String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const String _modelFast = 'llama-3.1-8b-instant'; // Fast model for quick analysis
  static const String _modelDeep = 'llama-3.3-70b-versatile'; // Better model for deep analysis
  static const int _maxRetries = 3;

  /// Check if Groq API is available (has API key configured)
  static bool isAvailable(Session session) {
    final apiKey = session.passwords['groqApiKey'];
    return apiKey != null && apiKey.isNotEmpty;
  }

  /// Quick analysis for text content (no image support)
  /// Returns null if the content requires vision capabilities
  static Future<QuickAnalysisResult?> quickAnalysis(
    Session session,
    String type,
    Uint8List imageBytes,
  ) async {
    // Groq doesn't support vision - return null to indicate fallback not available
    // The MultiModelService will handle this gracefully
    session.log('Groq: Vision not supported, cannot process image', level: LogLevel.debug);
    return null;
  }

  /// Process text-based content with Groq
  static Future<AIProcessingResult?> processTextContent(
    Session session,
    String textContent,
    String prompt,
  ) async {
    final apiKey = session.passwords['groqApiKey'];
    if (apiKey == null) {
      return null;
    }

    try {
      final response = await _callGroq(
        session,
        apiKey,
        prompt,
        _modelDeep,
        maxTokens: 2048,
        temperature: 0.1,
      );

      if (response == null) return null;

      return _parseGroqResponse(response);
    } catch (e) {
      session.log('Groq processing failed: $e', level: LogLevel.warning);
      return null;
    }
  }

  /// Expand search query with related terms
  static Future<List<String>> expandSearchQuery(
    Session session,
    String query,
  ) async {
    final apiKey = session.passwords['groqApiKey'];
    if (apiKey == null) {
      return [query];
    }

    final prompt = '''
Given the search query "$query", generate a list of related search terms that would help find relevant content. Include synonyms, related concepts, and variations.

Return only a JSON array of strings, e.g.: ["term1", "term2", "term3"]

Keep the list to 5-10 highly relevant terms.
''';

    try {
      final response = await _callGroq(
        session,
        apiKey,
        prompt,
        _modelFast,
        maxTokens: 256,
        temperature: 0.3,
      );

      if (response != null) {
        final cleanedText = _extractJson(response);
        final terms = List<String>.from(jsonDecode(cleanedText));
        return [query, ...terms];
      }
    } catch (e) {
      session.log('Groq search expansion failed: $e', level: LogLevel.debug);
    }

    return [query];
  }

  /// Rerank search results by relevance
  static Future<List<int>> rerankResults(
    Session session,
    String query,
    List<Capture> captures,
  ) async {
    final apiKey = session.passwords['groqApiKey'];
    if (apiKey == null || captures.isEmpty) {
      return List.generate(captures.length, (i) => i);
    }

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
      final response = await _callGroq(
        session,
        apiKey,
        prompt,
        _modelFast,
        maxTokens: 128,
        temperature: 0.1,
      );

      if (response != null) {
        final cleanedText = _extractJson(response);
        return List<int>.from(jsonDecode(cleanedText));
      }
    } catch (e) {
      session.log('Groq reranking failed: $e', level: LogLevel.debug);
    }

    return List.generate(captures.length, (i) => i);
  }

  /// Generate morning briefing summary
  static Future<String> generateMorningBriefing(
    Session session,
    List<Action> todayActions,
    List<Capture> recentCaptures,
  ) async {
    final apiKey = session.passwords['groqApiKey'];
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
      final response = await _callGroq(
        session,
        apiKey,
        prompt,
        _modelDeep,
        maxTokens: 256,
        temperature: 0.7,
      );

      if (response != null) {
        return response;
      }
    } catch (e) {
      session.log('Groq briefing generation failed: $e', level: LogLevel.debug);
    }

    return 'Good morning! You have ${todayActions.length} tasks today and ${recentCaptures.length} recent captures.';
  }

  /// Extract action items from capture content
  static Future<List<Map<String, dynamic>>> extractActions(
    Session session,
    Capture capture,
  ) async {
    final apiKey = session.passwords['groqApiKey'];
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
      final response = await _callGroq(
        session,
        apiKey,
        prompt,
        _modelDeep,
        maxTokens: 512,
        temperature: 0.1,
      );

      if (response != null) {
        final cleanedText = _extractJson(response);
        final actions = jsonDecode(cleanedText);
        if (actions is List) {
          return actions.cast<Map<String, dynamic>>();
        }
      }
    } catch (e) {
      session.log('Groq action extraction failed: $e', level: LogLevel.debug);
    }

    return [];
  }

  /// Generate weekly digest summary
  static Future<String> generateWeeklyDigest(
    Session session,
    List<Capture> captures,
  ) async {
    final apiKey = session.passwords['groqApiKey'];
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
      final response = await _callGroq(
        session,
        apiKey,
        prompt,
        _modelDeep,
        maxTokens: 256,
        temperature: 0.7,
      );

      if (response != null) {
        return response;
      }
    } catch (e) {
      session.log('Groq weekly digest failed: $e', level: LogLevel.debug);
    }

    return 'You captured ${captures.length} items this week.';
  }

  /// Analyze email content
  static Future<Map<String, dynamic>?> analyzeEmail(
    Session session,
    String fromEmail,
    String? fromName,
    String subject,
    DateTime receivedAt,
    String? snippet,
    String? bodyText,
  ) async {
    final apiKey = session.passwords['groqApiKey'];
    if (apiKey == null) {
      return null;
    }

    final bodyPreview = bodyText != null && bodyText.length > 2000
        ? bodyText.substring(0, 2000)
        : bodyText ?? 'No body text available';

    final prompt = '''
Analyze this email and provide structured analysis.

FROM: ${fromName ?? fromEmail} <$fromEmail>
SUBJECT: $subject
DATE: ${receivedAt.toIso8601String()}
PREVIEW: ${snippet ?? ''}

BODY (truncated):
$bodyPreview

Provide your analysis in this EXACT JSON format:
{
  "summary": "2-3 sentence summary of the email content and purpose",
  "importanceScore": <number 1-10, where 10 is most important>,
  "importanceReason": "brief explanation of why this score",
  "sentiment": "<positive|negative|neutral>",
  "requiresAction": <true|false>,
  "suggestedActions": [
    {"action": "what to do", "priority": "<high|medium|low>"}
  ],
  "deadlineDetected": "<ISO date string or null>",
  "category": "<work|personal|newsletter|promotional|transactional|social>"
}

Importance scoring guidelines:
- 10: Urgent action required immediately
- 8-9: Important and requires response within 24 hours
- 6-7: Moderately important, should address this week
- 4-5: Low importance, FYI or can wait
- 1-3: Not important (newsletters, promotions, spam)
''';

    try {
      final response = await _callGroq(
        session,
        apiKey,
        prompt,
        _modelDeep,
        maxTokens: 500,
        temperature: 0.3,
      );

      if (response != null) {
        final cleanedText = _extractJson(response);
        return jsonDecode(cleanedText) as Map<String, dynamic>;
      }
    } catch (e) {
      session.log('Groq email analysis failed: $e', level: LogLevel.warning);
    }

    return null;
  }

  /// Generate draft reply for an email
  static Future<String?> generateDraftReply(
    Session session,
    String fromEmail,
    String? fromName,
    String subject,
    String? bodyText,
    String? snippet, {
    String tone = 'professional',
    String? additionalContext,
  }) async {
    final apiKey = session.passwords['groqApiKey'];
    if (apiKey == null) {
      return null;
    }

    final prompt = '''
Generate a draft reply to this email.

ORIGINAL EMAIL:
FROM: ${fromName ?? fromEmail}
SUBJECT: $subject
BODY:
${bodyText ?? snippet ?? ''}

REQUIREMENTS:
- Tone: $tone
- Keep it concise but complete
- Address all questions or points raised
- Be helpful and action-oriented
${additionalContext != null ? '- Additional context: $additionalContext' : ''}

Generate ONLY the reply body text, no subject or headers. Start directly with the greeting.
''';

    try {
      final response = await _callGroq(
        session,
        apiKey,
        prompt,
        _modelDeep,
        maxTokens: 800,
        temperature: 0.7,
      );

      return response;
    } catch (e) {
      session.log('Groq draft generation failed: $e', level: LogLevel.warning);
      return null;
    }
  }

  /// Generate meeting context/preparation brief
  static Future<String?> generateMeetingContext(
    Session session,
    String title,
    DateTime startTime,
    DateTime endTime,
    String? location,
    String? description,
    List<String> attendees,
    String emailContext,
  ) async {
    final apiKey = session.passwords['groqApiKey'];
    if (apiKey == null) {
      return null;
    }

    final prompt = '''
Generate a pre-meeting brief for this upcoming meeting.

MEETING DETAILS:
Title: $title
Time: ${startTime.toLocal()}
Duration: ${endTime.difference(startTime).inMinutes} minutes
Location: ${location ?? 'Not specified'}
Description: ${description ?? 'No description'}

ATTENDEES:
${attendees.take(10).join('\n')}

RELATED RECENT EMAILS:
$emailContext

Generate a concise meeting preparation brief in this format:

## Meeting Context
[2-3 sentences about what this meeting is likely about based on available information]

## Key Points to Prepare
- [Important point 1]
- [Important point 2]
- [Important point 3]

## Relevant Background
[Brief summary of relevant email threads or discussions]

## Suggested Questions/Topics
- [Question or topic to raise]
- [Question or topic to raise]
''';

    try {
      final response = await _callGroq(
        session,
        apiKey,
        prompt,
        _modelDeep,
        maxTokens: 1000,
        temperature: 0.5,
      );

      return response;
    } catch (e) {
      session.log('Groq meeting context failed: $e', level: LogLevel.warning);
      return null;
    }
  }

  /// Generate daily email digest
  static Future<String?> generateDailyDigest(
    Session session,
    String emailSummaries,
    String eventSummaries,
    int totalEmails,
    int actionableCount,
  ) async {
    final apiKey = session.passwords['groqApiKey'];
    if (apiKey == null) {
      return null;
    }

    final prompt = '''
Generate a brief, scannable daily email digest.

TODAY'S EMAILS ($totalEmails total, $actionableCount require action):
$emailSummaries

TODAY'S CALENDAR:
${eventSummaries.isEmpty ? 'No events scheduled' : eventSummaries}

Create a digest with:
1. **Quick Stats** - emails received, requiring action, meetings today
2. **Top Priority** - 1-2 most important items to address
3. **Action Items** - brief list of things that need response/action
4. **Today's Schedule** - key meetings/events

Keep it under 300 words, use bullet points, be scannable.
''';

    try {
      final response = await _callGroq(
        session,
        apiKey,
        prompt,
        _modelDeep,
        maxTokens: 600,
        temperature: 0.5,
      );

      return response;
    } catch (e) {
      session.log('Groq daily digest failed: $e', level: LogLevel.warning);
      return null;
    }
  }

  /// Core method to call Groq API with retry logic
  static Future<String?> _callGroq(
    Session session,
    String apiKey,
    String prompt,
    String model, {
    int maxTokens = 1024,
    double temperature = 0.1,
  }) async {
    http.Response? response;

    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'max_tokens': maxTokens,
          'temperature': temperature,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final choices = data['choices'] as List<dynamic>?;
        if (choices != null && choices.isNotEmpty) {
          final message = choices.first['message'] as Map<String, dynamic>;
          return message['content'] as String;
        }
        return null;
      }

      // Handle rate limit (429) with exponential backoff
      if (response.statusCode == 429) {
        if (attempt < _maxRetries - 1) {
          final delaySeconds = 2 << attempt;
          session.log(
            'Groq rate limited, retrying in ${delaySeconds}s (attempt ${attempt + 1}/$_maxRetries)',
          );
          await Future.delayed(Duration(seconds: delaySeconds));
          continue;
        }
        throw Exception('Groq API rate limited after $_maxRetries retries');
      }

      // For other errors, log and return null
      session.log('Groq API error: ${response.statusCode}', level: LogLevel.warning);
      return null;
    }

    return null;
  }

  /// Parse Groq response into AIProcessingResult
  static AIProcessingResult? _parseGroqResponse(String text) {
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

      return AIProcessingResult(
        extractedText: parsed['extractedText'] ?? '',
        description: parsed['description'] ?? 'AI processing completed',
        tags: List<String>.from(parsed['tags'] ?? []),
        category: parsed['category'] ?? 'Other',
        isReminder: parsed['isReminder'] ?? false,
        structuredActionsJson: structuredActions != null && structuredActions.isNotEmpty
            ? jsonEncode(structuredActions)
            : null,
      );
    } catch (e) {
      return AIProcessingResult(
        extractedText: text.length > 500 ? text.substring(0, 500) : text,
        description: 'Content captured',
        tags: ['captured'],
        category: 'Other',
        isReminder: false,
      );
    }
  }

  /// Extract JSON from potentially wrapped response
  static String _extractJson(String text) {
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

    final lastBrace = text.lastIndexOf('}');
    if (lastBrace != -1 && lastBrace < text.length - 1) {
      text = text.substring(0, lastBrace + 1);
    }

    return text;
  }
}

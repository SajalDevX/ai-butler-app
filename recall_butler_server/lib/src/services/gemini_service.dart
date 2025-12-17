import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Service for interacting with Google Gemini AI
class GeminiService {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';
  static const String _model = 'gemini-2.5-flash';

  /// Process a capture with Gemini AI
  static Future<AIProcessingResult> processCapture(
    Session session,
    Capture capture,
  ) async {
    final apiKey = session.passwords['geminiApiKey'];
    if (apiKey == null) {
      throw Exception('Gemini API key not configured');
    }

    switch (capture.type) {
      case 'screenshot':
      case 'photo':
        return await _processImage(session, capture, apiKey);
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
  static Future<AIProcessingResult> _processImage(
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

    // Fetch the image data
    final imageResponse = await http.get(Uri.parse(capture.originalUrl!));
    if (imageResponse.statusCode != 200) {
      throw Exception('Failed to fetch image');
    }

    final base64Image = base64Encode(imageResponse.bodyBytes);
    final mimeType = _getMimeType(capture.originalUrl!);

    final prompt = '''
Analyze this image and return a JSON response with the following structure:
{
  "extractedText": "Any readable text in the image",
  "description": "1-2 sentence description of the image content",
  "tags": ["tag1", "tag2", "tag3", "tag4", "tag5"],
  "category": "One of: Work, Personal, Recipe, Shopping, Travel, Health, Finance, Learning, Other",
  "isReminder": true or false (true if this appears to be a reminder, todo, or task),
  "actionItems": ["action1", "action2"] (optional, only if there are clear action items)
}

Be thorough in extracting all text. Generate relevant, specific tags.
Choose the most appropriate category based on content.
''';

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
        'maxOutputTokens': 1024,
      }
    };

    return await _callGemini(apiKey, requestBody);
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
        Uri.parse('$_baseUrl/$_model:generateContent?key=$apiKey'),
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
        Uri.parse('$_baseUrl/$_model:generateContent?key=$apiKey'),
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
        Uri.parse('$_baseUrl/$_model:generateContent?key=$apiKey'),
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

  /// Call Gemini API and parse response
  static Future<AIProcessingResult> _callGemini(
    String apiKey,
    Map<String, dynamic> requestBody,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$_model:generateContent?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode != 200) {
      throw Exception('Gemini API error: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    final text = data['candidates'][0]['content']['parts'][0]['text'];

    // Extract JSON from response
    final jsonText = _extractJson(text);

    try {
      final parsed = jsonDecode(jsonText);

      return AIProcessingResult(
        extractedText: parsed['extractedText'] ?? '',
        description: parsed['description'] ?? 'AI processing completed',
        tags: List<String>.from(parsed['tags'] ?? []),
        category: parsed['category'] ?? 'Other',
        isReminder: parsed['isReminder'] ?? false,
        actionItems: parsed['actionItems'] != null
            ? List<String>.from(parsed['actionItems'])
            : null,
      );
    } catch (e) {
      // If JSON parsing fails, return a basic result with the raw text
      print('JSON parsing failed, using fallback. Error: $e');
      print('Raw text was: $jsonText');

      return AIProcessingResult(
        extractedText: text.length > 500 ? text.substring(0, 500) : text,
        description: 'Content captured (AI parsing had issues)',
        tags: ['captured'],
        category: 'Other',
        isReminder: false,
        actionItems: null,
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

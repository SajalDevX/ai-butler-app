import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'gmail_service.dart';
import 'calendar_service.dart';
import 'groq_service.dart';
import 'multi_model_service.dart';
import 'push_notification_service.dart';

/// AI-powered email analysis and draft generation service
/// Uses Gemini with Groq fallback to analyze emails, score importance, and generate responses
class EmailAIService {
  static const String _apiBaseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';
  static const String _model = 'gemini-2.5-flash';
  static const int _maxRetries = 3;

  /// Analyze unprocessed emails for a user
  static Future<int> analyzeUnprocessedEmails(
    Session session,
    int userId, {
    int batchSize = 5,
  }) async {
    final emails = await GmailService.getUnprocessedEmails(
      session,
      userId,
      limit: batchSize,
    );

    if (emails.isEmpty) return 0;

    final apiKey = session.serverpod.getPassword('geminiApiKey');
    if (apiKey == null) {
      session.log('Gemini API key not configured', level: LogLevel.error);
      return 0;
    }

    int processedCount = 0;

    for (final email in emails) {
      try {
        final analysis = await _analyzeEmail(session, apiKey, email);

        // Update email with analysis
        email.aiSummary = analysis['summary'] as String?;
        int importanceScore = analysis['importanceScore'] as int? ?? 5;

        // Apply critical keyword override - certain words guarantee minimum score 9
        importanceScore = _applyCriticalKeywordOverride(
          email.subject,
          email.bodyText,
          importanceScore,
        );

        email.importanceScore = importanceScore;
        email.importanceReason = analysis['importanceReason'] as String?;
        email.sentiment = analysis['sentiment'] as String?;
        email.requiresAction = analysis['requiresAction'] as bool? ?? false;
        email.suggestedActions = analysis['suggestedActions'] != null
            ? jsonEncode(analysis['suggestedActions'])
            : null;

        final deadlineStr = analysis['deadlineDetected'] as String?;
        if (deadlineStr != null) {
          email.deadlineDetected = DateTime.tryParse(deadlineStr);
        }

        email.isProcessed = true;
        email.updatedAt = DateTime.now();

        await EmailSummary.db.updateRow(session, email);
        processedCount++;

        session.log(
          'Analyzed email ${email.id}: importance=${email.importanceScore}, '
          'requiresAction=${email.requiresAction}',
        );

        // Send push notification for critical emails (priority >= 9)
        if (email.importanceScore >= PushNotificationService.criticalPriorityThreshold) {
          try {
            await PushNotificationService.notifyCriticalEmail(session, email, userId);
            session.log('Push notification sent for critical email ${email.id}');
          } catch (notifyError) {
            session.log('Failed to send push notification: $notifyError', level: LogLevel.warning);
          }
        }
      } catch (e) {
        session.log('Failed to analyze email ${email.id}: $e', level: LogLevel.warning);
        email.processingError = e.toString();
        email.isProcessed = true; // Mark as processed to avoid retry loop
        email.updatedAt = DateTime.now();
        await EmailSummary.db.updateRow(session, email);
      }
    }

    return processedCount;
  }

  /// Analyze a single email with multi-model fallback
  static Future<Map<String, dynamic>> _analyzeEmail(
    Session session,
    String apiKey,
    EmailSummary email,
  ) async {
    // Check if Gemini is rate limited, try Groq first if so
    if (MultiModelService.isProviderRateLimited(ModelProvider.gemini)) {
      session.log('Gemini rate limited, trying Groq for email analysis');
      final groqResult = await GroqService.analyzeEmail(
        session,
        email.fromEmail,
        email.fromName,
        email.subject,
        email.receivedAt,
        email.snippet,
        email.bodyText,
      );
      if (groqResult != null) {
        MultiModelService.clearProviderRateLimit(ModelProvider.groq);
        return groqResult;
      }
    }

    // Try Gemini first
    try {
      final result = await _analyzeEmailWithGemini(session, apiKey, email);
      MultiModelService.clearProviderRateLimit(ModelProvider.gemini);
      return result;
    } catch (e) {
      final errorStr = e.toString().toLowerCase();
      final isRateLimit = errorStr.contains('429') ||
          errorStr.contains('rate limit') ||
          errorStr.contains('quota');
      final isParseError = e is FormatException ||
          errorStr.contains('formatexception') ||
          errorStr.contains('unexpected end') ||
          errorStr.contains('invalid json');

      if (isRateLimit || isParseError) {
        final reason = isRateLimit ? 'rate limited' : 'parse error';
        session.log('Gemini $reason, falling back to Groq', level: LogLevel.warning);

        if (isRateLimit) {
          MultiModelService.markProviderRateLimited(ModelProvider.gemini);
        }

        // Try Groq as fallback
        final groqResult = await GroqService.analyzeEmail(
          session,
          email.fromEmail,
          email.fromName,
          email.subject,
          email.receivedAt,
          email.snippet,
          email.bodyText,
        );

        if (groqResult != null) {
          MultiModelService.clearProviderRateLimit(ModelProvider.groq);
          return groqResult;
        }
      }

      // Re-throw if no fallback succeeded
      rethrow;
    }
  }

  /// Analyze email using Gemini API
  static Future<Map<String, dynamic>> _analyzeEmailWithGemini(
    Session session,
    String apiKey,
    EmailSummary email,
  ) async {
    final prompt = '''
Analyze this email and provide structured analysis.

FROM: ${email.fromName ?? email.fromEmail} <${email.fromEmail}>
SUBJECT: ${email.subject}
DATE: ${email.receivedAt.toIso8601String()}
PREVIEW: ${email.snippet ?? ''}

BODY (truncated):
${email.bodyText?.substring(0, email.bodyText!.length > 2000 ? 2000 : email.bodyText!.length) ?? 'No body text available'}

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
- 10: Urgent action required immediately (time-sensitive deadlines, emergencies)
- 8-9: Important and requires response within 24 hours
- 6-7: Moderately important, should address this week
- 4-5: Low importance, FYI or can wait
- 1-3: Not important (newsletters, promotions, spam)

Consider these factors for importance:
- Is sender a VIP (executive, client, family)?
- Does it contain deadlines or time-sensitive info?
- Does it require a decision or action?
- Is it a reply to something the user sent?
- Is it a calendar invite or meeting-related?
''';

    http.Response? response;

    // Retry logic with exponential backoff
    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      response = await http.post(
        Uri.parse('$_apiBaseUrl/$_model:generateContent?key=$apiKey'),
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
            'maxOutputTokens': 500,
            'responseMimeType': 'application/json',
          },
        }),
      );

      if (response.statusCode == 200) {
        break;
      }

      // Handle rate limit (429) and server unavailable (503)
      if (response.statusCode == 429 || response.statusCode == 503) {
        if (attempt < _maxRetries - 1) {
          final delaySeconds = 2 << attempt;
          session.log('Rate limited (${response.statusCode}), retrying in ${delaySeconds}s');
          await Future.delayed(Duration(seconds: delaySeconds));
          continue;
        }
        throw Exception('Gemini API rate limited (429) after $_maxRetries retries');
      }

      throw Exception('Gemini API error: ${response.statusCode}');
    }

    if (response == null || response.statusCode != 200) {
      throw Exception('Gemini API error: ${response?.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = data['candidates'] as List<dynamic>?;

    if (candidates == null || candidates.isEmpty) {
      throw Exception('No response from Gemini');
    }

    final content = candidates.first['content'] as Map<String, dynamic>;
    final parts = content['parts'] as List<dynamic>;
    final text = parts.first['text'] as String;

    return jsonDecode(text) as Map<String, dynamic>;
  }

  /// Generate draft reply for an email with multi-model fallback
  static Future<String?> generateDraftReply(
    Session session,
    int emailId, {
    String tone = 'professional',
    String? additionalContext,
  }) async {
    final email = await EmailSummary.db.findById(session, emailId);
    if (email == null) return null;

    final apiKey = session.serverpod.getPassword('geminiApiKey');

    String? draft;

    // Check if Gemini is rate limited, try Groq first if so
    if (MultiModelService.isProviderRateLimited(ModelProvider.gemini)) {
      session.log('Gemini rate limited, trying Groq for draft generation');
      draft = await GroqService.generateDraftReply(
        session,
        email.fromEmail,
        email.fromName,
        email.subject,
        email.bodyText,
        email.snippet,
        tone: tone,
        additionalContext: additionalContext,
      );
      if (draft != null) {
        MultiModelService.clearProviderRateLimit(ModelProvider.groq);
      }
    }

    // Try Gemini if we don't have a draft yet
    if (draft == null && apiKey != null) {
      try {
        draft = await _generateDraftWithGemini(session, apiKey, email, tone, additionalContext);
        if (draft != null) {
          MultiModelService.clearProviderRateLimit(ModelProvider.gemini);
        }
      } catch (e) {
        final isRateLimit = e.toString().contains('429') ||
            e.toString().contains('rate limit') ||
            e.toString().contains('quota');

        if (isRateLimit) {
          session.log('Gemini rate limited, falling back to Groq for draft', level: LogLevel.warning);
          MultiModelService.markProviderRateLimited(ModelProvider.gemini);

          draft = await GroqService.generateDraftReply(
            session,
            email.fromEmail,
            email.fromName,
            email.subject,
            email.bodyText,
            email.snippet,
            tone: tone,
            additionalContext: additionalContext,
          );

          if (draft != null) {
            MultiModelService.clearProviderRateLimit(ModelProvider.groq);
          }
        } else {
          session.log('Error generating draft: $e', level: LogLevel.error);
        }
      }
    }

    // Save draft if we got one
    if (draft != null) {
      email.draftReply = draft;
      email.draftTone = tone;
      email.updatedAt = DateTime.now();
      await EmailSummary.db.updateRow(session, email);
    }

    return draft;
  }

  /// Generate draft reply using Gemini API
  static Future<String?> _generateDraftWithGemini(
    Session session,
    String apiKey,
    EmailSummary email,
    String tone,
    String? additionalContext,
  ) async {
    final prompt = '''
Generate a draft reply to this email.

ORIGINAL EMAIL:
FROM: ${email.fromName ?? email.fromEmail}
SUBJECT: ${email.subject}
BODY:
${email.bodyText ?? email.snippet ?? ''}

REQUIREMENTS:
- Tone: $tone
- Keep it concise but complete
- Address all questions or points raised
- Be helpful and action-oriented
${additionalContext != null ? '- Additional context: $additionalContext' : ''}

Generate ONLY the reply body text, no subject or headers. Start directly with the greeting.
''';

    http.Response? response;

    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      response = await http.post(
        Uri.parse('$_apiBaseUrl/$_model:generateContent?key=$apiKey'),
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
            'maxOutputTokens': 800,
          },
        }),
      );

      if (response.statusCode == 200) {
        break;
      }

      if (response.statusCode == 429 || response.statusCode == 503) {
        if (attempt < _maxRetries - 1) {
          final delaySeconds = 2 << attempt;
          await Future.delayed(Duration(seconds: delaySeconds));
          continue;
        }
        throw Exception('Gemini API rate limited (429) after $_maxRetries retries');
      }

      throw Exception('Gemini API error: ${response.statusCode}');
    }

    if (response == null || response.statusCode != 200) {
      return null;
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = data['candidates'] as List<dynamic>?;

    if (candidates == null || candidates.isEmpty) return null;

    final content = candidates.first['content'] as Map<String, dynamic>;
    final parts = content['parts'] as List<dynamic>;
    return parts.first['text'] as String;
  }

  /// Generate meeting context/preparation brief with multi-model fallback
  static Future<String?> generateMeetingContext(
    Session session,
    int eventId,
    int userId,
  ) async {
    final event = await CalendarEventCache.db.findById(session, eventId);
    if (event == null) return null;

    final apiKey = session.serverpod.getPassword('geminiApiKey');

    // Find related emails (from attendees or mentioning the meeting)
    final attendees = event.attendeesJson != null
        ? (jsonDecode(event.attendeesJson!) as List<dynamic>)
            .map((a) => a['email'] as String)
            .toList()
        : <String>[];

    // Get recent emails from attendees
    List<EmailSummary> relatedEmails = [];
    if (attendees.isNotEmpty) {
      for (final attendeeEmail in attendees.take(5)) {
        final emails = await EmailSummary.db.find(
          session,
          where: (t) =>
              t.userId.equals(userId) &
              t.fromEmail.equals(attendeeEmail),
          orderBy: (t) => t.receivedAt,
          orderDescending: true,
          limit: 3,
        );
        relatedEmails.addAll(emails);
      }
    }

    // Search for emails mentioning the meeting topic
    final titleWords = event.title
        .split(' ')
        .where((w) => w.length > 3)
        .take(3)
        .toList();

    if (titleWords.isNotEmpty) {
      final topicEmails = await EmailSummary.db.find(
        session,
        where: (t) => t.userId.equals(userId),
        orderBy: (t) => t.receivedAt,
        orderDescending: true,
        limit: 50,
      );

      // Filter by topic (simple text match)
      final matchingEmails = topicEmails.where((e) {
        final searchText = '${e.subject} ${e.bodyText ?? ''}'.toLowerCase();
        return titleWords.any((w) => searchText.contains(w.toLowerCase()));
      }).take(5);

      relatedEmails.addAll(matchingEmails);
    }

    // Remove duplicates
    final seenIds = <int>{};
    relatedEmails = relatedEmails.where((e) => seenIds.add(e.id!)).toList();

    // Build context for AI
    final emailContext = relatedEmails.take(5).map((e) => '''
- From: ${e.fromName ?? e.fromEmail}
  Subject: ${e.subject}
  Summary: ${e.aiSummary ?? e.snippet ?? 'No summary'}
  Date: ${e.receivedAt.toIso8601String()}
''').join('\n');

    String? contextBrief;

    // Check if Gemini is rate limited, try Groq first if so
    if (MultiModelService.isProviderRateLimited(ModelProvider.gemini)) {
      session.log('Gemini rate limited, trying Groq for meeting context');
      contextBrief = await GroqService.generateMeetingContext(
        session,
        event.title,
        event.startTime,
        event.endTime,
        event.location,
        event.description,
        attendees,
        emailContext,
      );
      if (contextBrief != null) {
        MultiModelService.clearProviderRateLimit(ModelProvider.groq);
      }
    }

    // Try Gemini if we don't have context yet
    if (contextBrief == null && apiKey != null) {
      try {
        contextBrief = await _generateMeetingContextWithGemini(
          session,
          apiKey,
          event,
          attendees,
          emailContext,
        );
        if (contextBrief != null) {
          MultiModelService.clearProviderRateLimit(ModelProvider.gemini);
        }
      } catch (e) {
        final isRateLimit = e.toString().contains('429') ||
            e.toString().contains('rate limit') ||
            e.toString().contains('quota');

        if (isRateLimit) {
          session.log('Gemini rate limited, falling back to Groq for meeting context',
              level: LogLevel.warning);
          MultiModelService.markProviderRateLimited(ModelProvider.gemini);

          contextBrief = await GroqService.generateMeetingContext(
            session,
            event.title,
            event.startTime,
            event.endTime,
            event.location,
            event.description,
            attendees,
            emailContext,
          );

          if (contextBrief != null) {
            MultiModelService.clearProviderRateLimit(ModelProvider.groq);
          }
        } else {
          session.log('Error generating meeting context: $e', level: LogLevel.error);
        }
      }
    }

    // Save to event if we got context
    if (contextBrief != null) {
      await CalendarService.updateEventContext(
        session,
        eventId,
        contextBrief: contextBrief,
        relatedEmailIds: relatedEmails.map((e) => e.gmailId).toList(),
      );
    }

    return contextBrief;
  }

  /// Generate meeting context using Gemini API
  static Future<String?> _generateMeetingContextWithGemini(
    Session session,
    String apiKey,
    CalendarEventCache event,
    List<String> attendees,
    String emailContext,
  ) async {
    final prompt = '''
Generate a pre-meeting brief for this upcoming meeting.

MEETING DETAILS:
Title: ${event.title}
Time: ${event.startTime.toLocal()}
Duration: ${event.endTime.difference(event.startTime).inMinutes} minutes
Location: ${event.location ?? 'Not specified'}
Description: ${event.description ?? 'No description'}

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

    http.Response? response;

    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      response = await http.post(
        Uri.parse('$_apiBaseUrl/$_model:generateContent?key=$apiKey'),
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
            'temperature': 0.5,
            'maxOutputTokens': 1000,
          },
        }),
      );

      if (response.statusCode == 200) {
        break;
      }

      if (response.statusCode == 429 || response.statusCode == 503) {
        if (attempt < _maxRetries - 1) {
          final delaySeconds = 2 << attempt;
          await Future.delayed(Duration(seconds: delaySeconds));
          continue;
        }
        throw Exception('Gemini API rate limited (429) after $_maxRetries retries');
      }

      throw Exception('Gemini API error: ${response.statusCode}');
    }

    if (response == null || response.statusCode != 200) {
      return null;
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = data['candidates'] as List<dynamic>?;

    if (candidates == null || candidates.isEmpty) return null;

    final content = candidates.first['content'] as Map<String, dynamic>;
    final parts = content['parts'] as List<dynamic>;
    return parts.first['text'] as String;
  }

  /// Get daily email digest with multi-model fallback
  static Future<String?> generateDailyDigest(
    Session session,
    int userId,
  ) async {
    final apiKey = session.serverpod.getPassword('geminiApiKey');

    // Get today's important emails
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final todayEmails = await EmailSummary.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.receivedAt.between(startOfDay, endOfDay) &
          t.isProcessed.equals(true),
      orderBy: (t) => t.importanceScore,
      orderDescending: true,
      limit: 20,
    );

    if (todayEmails.isEmpty) {
      return 'No new emails today.';
    }

    // Get today's events
    final todayEvents = await CalendarService.getTodayEvents(session, userId);

    // Get actionable emails
    final actionableEmails = todayEmails.where((e) => e.requiresAction).toList();

    final emailSummaries = todayEmails.take(10).map((e) => '''
- [Importance: ${e.importanceScore}/10] ${e.subject}
  From: ${e.fromName ?? e.fromEmail}
  ${e.aiSummary ?? e.snippet ?? ''}
  ${e.requiresAction ? '⚡ Action required' : ''}
''').join('\n');

    final eventSummaries = todayEvents.map((e) => '''
- ${e.startTime.toLocal().hour}:${e.startTime.toLocal().minute.toString().padLeft(2, '0')} - ${e.title}
  ${e.location ?? ''}
''').join('\n');

    String? digest;

    // Check if Gemini is rate limited, try Groq first if so
    if (MultiModelService.isProviderRateLimited(ModelProvider.gemini)) {
      session.log('Gemini rate limited, trying Groq for daily digest');
      digest = await GroqService.generateDailyDigest(
        session,
        emailSummaries,
        eventSummaries,
        todayEmails.length,
        actionableEmails.length,
      );
      if (digest != null) {
        MultiModelService.clearProviderRateLimit(ModelProvider.groq);
      }
    }

    // Try Gemini if we don't have digest yet
    if (digest == null && apiKey != null) {
      try {
        digest = await _generateDailyDigestWithGemini(
          session,
          apiKey,
          emailSummaries,
          eventSummaries,
          todayEmails.length,
          actionableEmails.length,
        );
        if (digest != null) {
          MultiModelService.clearProviderRateLimit(ModelProvider.gemini);
        }
      } catch (e) {
        final isRateLimit = e.toString().contains('429') ||
            e.toString().contains('rate limit') ||
            e.toString().contains('quota');

        if (isRateLimit) {
          session.log('Gemini rate limited, falling back to Groq for daily digest',
              level: LogLevel.warning);
          MultiModelService.markProviderRateLimited(ModelProvider.gemini);

          digest = await GroqService.generateDailyDigest(
            session,
            emailSummaries,
            eventSummaries,
            todayEmails.length,
            actionableEmails.length,
          );

          if (digest != null) {
            MultiModelService.clearProviderRateLimit(ModelProvider.groq);
          }
        } else {
          session.log('Error generating daily digest: $e', level: LogLevel.error);
        }
      }
    }

    return digest;
  }

  /// Generate daily digest using Gemini API
  static Future<String?> _generateDailyDigestWithGemini(
    Session session,
    String apiKey,
    String emailSummaries,
    String eventSummaries,
    int totalEmails,
    int actionableCount,
  ) async {
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

    http.Response? response;

    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      response = await http.post(
        Uri.parse('$_apiBaseUrl/$_model:generateContent?key=$apiKey'),
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
            'temperature': 0.5,
            'maxOutputTokens': 600,
          },
        }),
      );

      if (response.statusCode == 200) {
        break;
      }

      if (response.statusCode == 429 || response.statusCode == 503) {
        if (attempt < _maxRetries - 1) {
          final delaySeconds = 2 << attempt;
          await Future.delayed(Duration(seconds: delaySeconds));
          continue;
        }
        throw Exception('Gemini API rate limited (429) after $_maxRetries retries');
      }

      throw Exception('Gemini API error: ${response.statusCode}');
    }

    if (response == null || response.statusCode != 200) {
      return null;
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = data['candidates'] as List<dynamic>?;

    if (candidates == null || candidates.isEmpty) return null;

    final content = candidates.first['content'] as Map<String, dynamic>;
    final parts = content['parts'] as List<dynamic>;
    return parts.first['text'] as String;
  }

  /// Apply critical keyword override to ensure life-threatening situations
  /// always get high importance scores regardless of AI judgment
  static int _applyCriticalKeywordOverride(
    String subject,
    String? bodyText,
    int currentScore,
  ) {
    // Critical keywords that should guarantee minimum score of 9
    const criticalKeywords = [
      'died',
      'death',
      'passed away',
      'passing away',
      'emergency',
      'hospital',
      'accident',
      'critical condition',
      'life threatening',
      'life-threatening',
      'urgent medical',
      'heart attack',
      'stroke',
      'ambulance',
      'icu',
      'intensive care',
      'surgery',
      'dying',
      'fatal',
      'killed',
      'murder',
      'suicide',
      'overdose',
    ];

    final textToSearch = '${subject.toLowerCase()} ${(bodyText ?? '').toLowerCase()}';

    for (final keyword in criticalKeywords) {
      if (textToSearch.contains(keyword)) {
        // If critical keyword found and score is below 9, boost it to 9
        if (currentScore < 9) {
          return 9;
        }
        break;
      }
    }

    return currentScore;
  }
}

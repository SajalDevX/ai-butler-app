import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'gmail_service.dart';
import 'calendar_service.dart';

/// AI-powered email analysis and draft generation service
/// Uses Gemini to analyze emails, score importance, and generate responses
class EmailAIService {
  static const String _apiBaseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';
  static const String _model = 'gemini-2.5-flash';

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
        email.importanceScore = analysis['importanceScore'] as int? ?? 5;
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

  /// Analyze a single email
  static Future<Map<String, dynamic>> _analyzeEmail(
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

    final response = await http.post(
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

    if (response.statusCode != 200) {
      throw Exception('Gemini API error: ${response.statusCode}');
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

  /// Generate draft reply for an email
  static Future<String?> generateDraftReply(
    Session session,
    int emailId, {
    String tone = 'professional',
    String? additionalContext,
  }) async {
    final email = await EmailSummary.db.findById(session, emailId);
    if (email == null) return null;

    final apiKey = session.serverpod.getPassword('geminiApiKey');
    if (apiKey == null) return null;

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

    try {
      final response = await http.post(
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

      if (response.statusCode != 200) {
        session.log('Failed to generate draft: ${response.statusCode}', level: LogLevel.error);
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final candidates = data['candidates'] as List<dynamic>?;

      if (candidates == null || candidates.isEmpty) return null;

      final content = candidates.first['content'] as Map<String, dynamic>;
      final parts = content['parts'] as List<dynamic>;
      final draft = parts.first['text'] as String;

      // Save draft to email
      email.draftReply = draft;
      email.draftTone = tone;
      email.updatedAt = DateTime.now();
      await EmailSummary.db.updateRow(session, email);

      return draft;
    } catch (e) {
      session.log('Error generating draft: $e', level: LogLevel.error);
      return null;
    }
  }

  /// Generate meeting context/preparation brief
  static Future<String?> generateMeetingContext(
    Session session,
    int eventId,
    int userId,
  ) async {
    final event = await CalendarEventCache.db.findById(session, eventId);
    if (event == null) return null;

    final apiKey = session.serverpod.getPassword('geminiApiKey');
    if (apiKey == null) return null;

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

    try {
      final response = await http.post(
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

      if (response.statusCode != 200) {
        session.log('Failed to generate meeting context: ${response.statusCode}',
            level: LogLevel.error);
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final candidates = data['candidates'] as List<dynamic>?;

      if (candidates == null || candidates.isEmpty) return null;

      final content = candidates.first['content'] as Map<String, dynamic>;
      final parts = content['parts'] as List<dynamic>;
      final contextBrief = parts.first['text'] as String;

      // Save to event
      await CalendarService.updateEventContext(
        session,
        eventId,
        contextBrief: contextBrief,
        relatedEmailIds: relatedEmails.map((e) => e.gmailId).toList(),
      );

      return contextBrief;
    } catch (e) {
      session.log('Error generating meeting context: $e', level: LogLevel.error);
      return null;
    }
  }

  /// Get daily email digest
  static Future<String?> generateDailyDigest(
    Session session,
    int userId,
  ) async {
    final apiKey = session.serverpod.getPassword('geminiApiKey');
    if (apiKey == null) return null;

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

    final prompt = '''
Generate a brief, scannable daily email digest.

TODAY'S EMAILS (${todayEmails.length} total, ${actionableEmails.length} require action):
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
      final response = await http.post(
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

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final candidates = data['candidates'] as List<dynamic>?;

      if (candidates == null || candidates.isEmpty) return null;

      final content = candidates.first['content'] as Map<String, dynamic>;
      final parts = content['parts'] as List<dynamic>;

      return parts.first['text'] as String;
    } catch (e) {
      session.log('Error generating daily digest: $e', level: LogLevel.error);
      return null;
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'google_auth_helper.dart';

/// Service for interacting with Google Calendar API
/// Handles event fetching, caching, and meeting context generation
class CalendarService {
  static const String _baseUrl = 'https://www.googleapis.com/calendar/v3';
  static const int _defaultSyncDays = 30; // Sync events for next 30 days

  /// Sync calendar events for a user
  static Future<CalendarSyncResult> syncEvents(
    Session session,
    int userId, {
    int daysAhead = _defaultSyncDays,
    bool includeRecurring = true,
  }) async {
    final accessToken = await GoogleAuthHelper.getValidAccessToken(session, userId);
    if (accessToken == null) {
      return CalendarSyncResult(
        success: false,
        error: 'Not authenticated with Google',
        newEventCount: 0,
        updatedEventCount: 0,
      );
    }

    try {
      final now = DateTime.now();
      final timeMin = now.toUtc().toIso8601String();
      final timeMax = now.add(Duration(days: daysAhead)).toUtc().toIso8601String();

      // Fetch events from primary calendar
      final events = await _fetchEvents(
        accessToken,
        'primary',
        timeMin,
        timeMax,
        singleEvents: includeRecurring,
      );

      int newCount = 0;
      int updatedCount = 0;

      for (final event in events) {
        final result = await _upsertEvent(session, userId, event);
        if (result == 'new') {
          newCount++;
        } else if (result == 'updated') {
          updatedCount++;
        }
      }

      // Update last sync time
      final googleToken = await GoogleToken.db.findFirstRow(
        session,
        where: (t) => t.userId.equals(userId),
      );

      if (googleToken != null) {
        googleToken.lastCalendarSync = DateTime.now();
        googleToken.updatedAt = DateTime.now();
        await GoogleToken.db.updateRow(session, googleToken);
      }

      session.log('Calendar sync complete: $newCount new, $updatedCount updated');

      return CalendarSyncResult(
        success: true,
        newEventCount: newCount,
        updatedEventCount: updatedCount,
      );
    } catch (e, stackTrace) {
      session.log('Calendar sync error: $e\n$stackTrace', level: LogLevel.error);
      return CalendarSyncResult(
        success: false,
        error: e.toString(),
        newEventCount: 0,
        updatedEventCount: 0,
      );
    }
  }

  /// Fetch events from a calendar
  static Future<List<Map<String, dynamic>>> _fetchEvents(
    String accessToken,
    String calendarId,
    String timeMin,
    String timeMax, {
    bool singleEvents = true,
  }) async {
    final events = <Map<String, dynamic>>[];
    String? pageToken;

    do {
      var url = '$_baseUrl/calendars/$calendarId/events'
          '?timeMin=$timeMin'
          '&timeMax=$timeMax'
          '&singleEvents=$singleEvents'
          '&orderBy=startTime'
          '&maxResults=250';

      if (pageToken != null) {
        url += '&pageToken=$pageToken';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch events: ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final items = data['items'] as List<dynamic>? ?? [];

      for (final item in items) {
        events.add(item as Map<String, dynamic>);
      }

      pageToken = data['nextPageToken'] as String?;
    } while (pageToken != null);

    return events;
  }

  /// Insert or update an event in the cache
  static Future<String> _upsertEvent(
    Session session,
    int userId,
    Map<String, dynamic> eventData,
  ) async {
    final googleEventId = eventData['id'] as String;

    // Check if event exists
    var existing = await CalendarEventCache.db.findFirstRow(
      session,
      where: (t) => t.googleEventId.equals(googleEventId),
    );

    final now = DateTime.now();
    final parsed = _parseEvent(eventData, userId);

    if (existing != null) {
      // Check if event has changed (by etag)
      if (existing.etag == eventData['etag']) {
        return 'unchanged';
      }

      // Update existing event
      existing.title = parsed.title;
      existing.description = parsed.description;
      existing.location = parsed.location;
      existing.startTime = parsed.startTime;
      existing.endTime = parsed.endTime;
      existing.isAllDay = parsed.isAllDay;
      existing.isRecurring = parsed.isRecurring;
      existing.recurringEventId = parsed.recurringEventId;
      existing.recurrenceRule = parsed.recurrenceRule;
      existing.organizerEmail = parsed.organizerEmail;
      existing.attendeesJson = parsed.attendeesJson;
      existing.attendeeCount = parsed.attendeeCount;
      existing.meetingLink = parsed.meetingLink;
      existing.conferenceType = parsed.conferenceType;
      existing.eventStatus = parsed.eventStatus;
      existing.responseStatus = parsed.responseStatus;
      existing.reminderMinutes = parsed.reminderMinutes;
      existing.etag = parsed.etag;
      existing.lastSyncedAt = now;
      existing.updatedAt = now;

      await CalendarEventCache.db.updateRow(session, existing);
      return 'updated';
    } else {
      // Insert new event
      parsed.createdAt = now;
      parsed.updatedAt = now;
      parsed.lastSyncedAt = now;

      await CalendarEventCache.db.insertRow(session, parsed);
      return 'new';
    }
  }

  /// Parse Google Calendar event to our model
  static CalendarEventCache _parseEvent(
    Map<String, dynamic> eventData,
    int userId,
  ) {
    // Parse start/end times
    final start = eventData['start'] as Map<String, dynamic>?;
    final end = eventData['end'] as Map<String, dynamic>?;

    final isAllDay = start?['date'] != null;
    DateTime startTime;
    DateTime endTime;

    if (isAllDay) {
      startTime = DateTime.parse(start!['date'] as String);
      endTime = DateTime.parse(end!['date'] as String);
    } else {
      startTime = DateTime.parse(start?['dateTime'] as String? ?? DateTime.now().toIso8601String());
      endTime = DateTime.parse(end?['dateTime'] as String? ?? DateTime.now().toIso8601String());
    }

    // Parse attendees
    final attendees = eventData['attendees'] as List<dynamic>? ?? [];
    final attendeesList = attendees
        .map((a) => {
              'email': a['email'],
              'displayName': a['displayName'],
              'responseStatus': a['responseStatus'],
              'self': a['self'],
            })
        .toList();

    // Get user's response status
    String? responseStatus;
    for (final attendee in attendees) {
      if (attendee['self'] == true) {
        responseStatus = attendee['responseStatus'] as String?;
        break;
      }
    }

    // Parse conference data (meeting links)
    String? meetingLink;
    String? conferenceType;
    final conferenceData = eventData['conferenceData'] as Map<String, dynamic>?;
    if (conferenceData != null) {
      final entryPoints = conferenceData['entryPoints'] as List<dynamic>? ?? [];
      for (final entry in entryPoints) {
        if (entry['entryPointType'] == 'video') {
          meetingLink = entry['uri'] as String?;
          break;
        }
      }

      final solution = conferenceData['conferenceSolution'] as Map<String, dynamic>?;
      if (solution != null) {
        final name = (solution['name'] as String?)?.toLowerCase() ?? '';
        if (name.contains('meet')) {
          conferenceType = 'meet';
        } else if (name.contains('zoom')) {
          conferenceType = 'zoom';
        } else if (name.contains('teams')) {
          conferenceType = 'teams';
        }
      }
    }

    // Check for meeting link in description or location
    if (meetingLink == null) {
      final description = eventData['description'] as String? ?? '';
      final location = eventData['location'] as String? ?? '';
      final combined = '$description $location';

      // Look for common meeting URLs
      final meetingPatterns = [
        RegExp(r'https://[a-z]+\.zoom\.us/[^\s]+'),
        RegExp(r'https://meet\.google\.com/[^\s]+'),
        RegExp(r'https://teams\.microsoft\.com/[^\s]+'),
      ];

      for (final pattern in meetingPatterns) {
        final match = pattern.firstMatch(combined);
        if (match != null) {
          meetingLink = match.group(0);
          if (meetingLink!.contains('zoom')) {
            conferenceType = 'zoom';
          } else if (meetingLink.contains('meet.google')) {
            conferenceType = 'meet';
          } else if (meetingLink.contains('teams')) {
            conferenceType = 'teams';
          }
          break;
        }
      }
    }

    // Parse reminder
    int? reminderMinutes;
    bool hasCustomReminder = false;
    final reminders = eventData['reminders'] as Map<String, dynamic>?;
    if (reminders != null) {
      final useDefault = reminders['useDefault'] as bool? ?? true;
      if (!useDefault) {
        hasCustomReminder = true;
        final overrides = reminders['overrides'] as List<dynamic>? ?? [];
        if (overrides.isNotEmpty) {
          reminderMinutes = overrides.first['minutes'] as int?;
        }
      }
    }

    // Parse organizer
    final organizer = eventData['organizer'] as Map<String, dynamic>?;
    final organizerEmail = organizer?['email'] as String?;

    // Parse recurrence
    final recurrence = eventData['recurrence'] as List<dynamic>?;
    String? recurrenceRule;
    if (recurrence != null && recurrence.isNotEmpty) {
      recurrenceRule = recurrence.first as String?;
    }

    return CalendarEventCache(
      userId: userId,
      googleEventId: eventData['id'] as String,
      calendarId: 'primary',
      title: eventData['summary'] as String? ?? '(No Title)',
      description: eventData['description'] as String?,
      location: eventData['location'] as String?,
      startTime: startTime,
      endTime: endTime,
      isAllDay: isAllDay,
      isRecurring: eventData['recurringEventId'] != null || recurrence != null,
      recurringEventId: eventData['recurringEventId'] as String?,
      recurrenceRule: recurrenceRule,
      organizerEmail: organizerEmail,
      attendeesJson: jsonEncode(attendeesList),
      attendeeCount: attendees.length,
      meetingLink: meetingLink,
      conferenceType: conferenceType,
      eventStatus: eventData['status'] as String? ?? 'confirmed',
      responseStatus: responseStatus,
      reminderMinutes: reminderMinutes,
      hasCustomReminder: hasCustomReminder,
      etag: eventData['etag'] as String?,
      lastSyncedAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Get upcoming events for a user
  static Future<List<CalendarEventCache>> getUpcomingEvents(
    Session session,
    int userId, {
    int hoursAhead = 24,
    int limit = 10,
  }) async {
    final now = DateTime.now();
    final endTime = now.add(Duration(hours: hoursAhead));

    return await CalendarEventCache.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.startTime.between(now, endTime) &
          t.eventStatus.notEquals('cancelled'),
      orderBy: (t) => t.startTime,
      limit: limit,
    );
  }

  /// Get today's events
  static Future<List<CalendarEventCache>> getTodayEvents(
    Session session,
    int userId,
  ) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return await CalendarEventCache.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.startTime.between(startOfDay, endOfDay) &
          t.eventStatus.notEquals('cancelled'),
      orderBy: (t) => t.startTime,
    );
  }

  /// Get events requiring preparation (with meetings in next N hours)
  static Future<List<CalendarEventCache>> getEventsPendingPrep(
    Session session,
    int userId, {
    int hoursAhead = 24,
  }) async {
    final now = DateTime.now();
    final endTime = now.add(Duration(hours: hoursAhead));

    return await CalendarEventCache.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.startTime.between(now, endTime) &
          t.attendeeCount.between(1, 1000) & // Has attendees (is a meeting)
          t.contextBrief.equals(null) & // Not yet prepared
          t.eventStatus.notEquals('cancelled'),
      orderBy: (t) => t.startTime,
    );
  }

  /// Get events by date range
  static Future<List<CalendarEventCache>> getEventsByRange(
    Session session,
    int userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await CalendarEventCache.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.startTime.between(startDate, endDate) &
          t.eventStatus.notEquals('cancelled'),
      orderBy: (t) => t.startTime,
    );
  }

  /// Update event with AI-generated context
  static Future<void> updateEventContext(
    Session session,
    int eventId, {
    String? aiSummary,
    String? suggestedPrep,
    String? contextBrief,
    List<String>? relatedEmailIds,
    List<int>? relatedCaptureIds,
  }) async {
    final event = await CalendarEventCache.db.findById(session, eventId);
    if (event == null) return;

    if (aiSummary != null) event.aiSummary = aiSummary;
    if (suggestedPrep != null) event.suggestedPrep = suggestedPrep;
    if (contextBrief != null) event.contextBrief = contextBrief;
    if (relatedEmailIds != null) {
      event.relatedEmailIds = jsonEncode(relatedEmailIds);
    }
    if (relatedCaptureIds != null) {
      event.relatedCaptureIds = jsonEncode(relatedCaptureIds);
    }
    event.updatedAt = DateTime.now();

    await CalendarEventCache.db.updateRow(session, event);
  }

  /// Delete old events (cleanup)
  static Future<int> cleanupOldEvents(
    Session session,
    int userId, {
    int daysOld = 30,
  }) async {
    final cutoff = DateTime.now().subtract(Duration(days: daysOld));
    // Use a very old date as the lower bound for "less than" comparison
    final veryOldDate = DateTime(2000, 1, 1);

    final deleted = await CalendarEventCache.db.deleteWhere(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.endTime.between(veryOldDate, cutoff),
    );

    return deleted.length;
  }
}

/// Result of calendar sync operation
class CalendarSyncResult {
  final bool success;
  final String? error;
  final int newEventCount;
  final int updatedEventCount;

  CalendarSyncResult({
    required this.success,
    this.error,
    required this.newEventCount,
    required this.updatedEventCount,
  });
}

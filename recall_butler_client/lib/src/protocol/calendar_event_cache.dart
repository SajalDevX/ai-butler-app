/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Calendar Event Cache
/// Caches Google Calendar events with AI enrichment
abstract class CalendarEventCache implements _i1.SerializableModel {
  CalendarEventCache._({
    this.id,
    required this.userId,
    required this.googleEventId,
    required this.calendarId,
    required this.title,
    this.description,
    this.location,
    required this.startTime,
    required this.endTime,
    required this.isAllDay,
    required this.isRecurring,
    this.recurringEventId,
    this.recurrenceRule,
    this.organizerEmail,
    this.attendeesJson,
    required this.attendeeCount,
    this.meetingLink,
    this.conferenceType,
    this.aiSummary,
    this.suggestedPrep,
    this.relatedEmailIds,
    this.relatedCaptureIds,
    this.contextBrief,
    required this.eventStatus,
    this.responseStatus,
    this.reminderMinutes,
    required this.hasCustomReminder,
    this.etag,
    required this.lastSyncedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CalendarEventCache({
    int? id,
    required int userId,
    required String googleEventId,
    required String calendarId,
    required String title,
    String? description,
    String? location,
    required DateTime startTime,
    required DateTime endTime,
    required bool isAllDay,
    required bool isRecurring,
    String? recurringEventId,
    String? recurrenceRule,
    String? organizerEmail,
    String? attendeesJson,
    required int attendeeCount,
    String? meetingLink,
    String? conferenceType,
    String? aiSummary,
    String? suggestedPrep,
    String? relatedEmailIds,
    String? relatedCaptureIds,
    String? contextBrief,
    required String eventStatus,
    String? responseStatus,
    int? reminderMinutes,
    required bool hasCustomReminder,
    String? etag,
    required DateTime lastSyncedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CalendarEventCacheImpl;

  factory CalendarEventCache.fromJson(Map<String, dynamic> jsonSerialization) {
    return CalendarEventCache(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      googleEventId: jsonSerialization['googleEventId'] as String,
      calendarId: jsonSerialization['calendarId'] as String,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      location: jsonSerialization['location'] as String?,
      startTime:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['startTime']),
      endTime: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endTime']),
      isAllDay: jsonSerialization['isAllDay'] as bool,
      isRecurring: jsonSerialization['isRecurring'] as bool,
      recurringEventId: jsonSerialization['recurringEventId'] as String?,
      recurrenceRule: jsonSerialization['recurrenceRule'] as String?,
      organizerEmail: jsonSerialization['organizerEmail'] as String?,
      attendeesJson: jsonSerialization['attendeesJson'] as String?,
      attendeeCount: jsonSerialization['attendeeCount'] as int,
      meetingLink: jsonSerialization['meetingLink'] as String?,
      conferenceType: jsonSerialization['conferenceType'] as String?,
      aiSummary: jsonSerialization['aiSummary'] as String?,
      suggestedPrep: jsonSerialization['suggestedPrep'] as String?,
      relatedEmailIds: jsonSerialization['relatedEmailIds'] as String?,
      relatedCaptureIds: jsonSerialization['relatedCaptureIds'] as String?,
      contextBrief: jsonSerialization['contextBrief'] as String?,
      eventStatus: jsonSerialization['eventStatus'] as String,
      responseStatus: jsonSerialization['responseStatus'] as String?,
      reminderMinutes: jsonSerialization['reminderMinutes'] as int?,
      hasCustomReminder: jsonSerialization['hasCustomReminder'] as bool,
      etag: jsonSerialization['etag'] as String?,
      lastSyncedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['lastSyncedAt']),
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  String googleEventId;

  String calendarId;

  String title;

  String? description;

  String? location;

  DateTime startTime;

  DateTime endTime;

  bool isAllDay;

  bool isRecurring;

  String? recurringEventId;

  String? recurrenceRule;

  String? organizerEmail;

  String? attendeesJson;

  int attendeeCount;

  String? meetingLink;

  String? conferenceType;

  String? aiSummary;

  String? suggestedPrep;

  String? relatedEmailIds;

  String? relatedCaptureIds;

  String? contextBrief;

  String eventStatus;

  String? responseStatus;

  int? reminderMinutes;

  bool hasCustomReminder;

  String? etag;

  DateTime lastSyncedAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [CalendarEventCache]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CalendarEventCache copyWith({
    int? id,
    int? userId,
    String? googleEventId,
    String? calendarId,
    String? title,
    String? description,
    String? location,
    DateTime? startTime,
    DateTime? endTime,
    bool? isAllDay,
    bool? isRecurring,
    String? recurringEventId,
    String? recurrenceRule,
    String? organizerEmail,
    String? attendeesJson,
    int? attendeeCount,
    String? meetingLink,
    String? conferenceType,
    String? aiSummary,
    String? suggestedPrep,
    String? relatedEmailIds,
    String? relatedCaptureIds,
    String? contextBrief,
    String? eventStatus,
    String? responseStatus,
    int? reminderMinutes,
    bool? hasCustomReminder,
    String? etag,
    DateTime? lastSyncedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'googleEventId': googleEventId,
      'calendarId': calendarId,
      'title': title,
      if (description != null) 'description': description,
      if (location != null) 'location': location,
      'startTime': startTime.toJson(),
      'endTime': endTime.toJson(),
      'isAllDay': isAllDay,
      'isRecurring': isRecurring,
      if (recurringEventId != null) 'recurringEventId': recurringEventId,
      if (recurrenceRule != null) 'recurrenceRule': recurrenceRule,
      if (organizerEmail != null) 'organizerEmail': organizerEmail,
      if (attendeesJson != null) 'attendeesJson': attendeesJson,
      'attendeeCount': attendeeCount,
      if (meetingLink != null) 'meetingLink': meetingLink,
      if (conferenceType != null) 'conferenceType': conferenceType,
      if (aiSummary != null) 'aiSummary': aiSummary,
      if (suggestedPrep != null) 'suggestedPrep': suggestedPrep,
      if (relatedEmailIds != null) 'relatedEmailIds': relatedEmailIds,
      if (relatedCaptureIds != null) 'relatedCaptureIds': relatedCaptureIds,
      if (contextBrief != null) 'contextBrief': contextBrief,
      'eventStatus': eventStatus,
      if (responseStatus != null) 'responseStatus': responseStatus,
      if (reminderMinutes != null) 'reminderMinutes': reminderMinutes,
      'hasCustomReminder': hasCustomReminder,
      if (etag != null) 'etag': etag,
      'lastSyncedAt': lastSyncedAt.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CalendarEventCacheImpl extends CalendarEventCache {
  _CalendarEventCacheImpl({
    int? id,
    required int userId,
    required String googleEventId,
    required String calendarId,
    required String title,
    String? description,
    String? location,
    required DateTime startTime,
    required DateTime endTime,
    required bool isAllDay,
    required bool isRecurring,
    String? recurringEventId,
    String? recurrenceRule,
    String? organizerEmail,
    String? attendeesJson,
    required int attendeeCount,
    String? meetingLink,
    String? conferenceType,
    String? aiSummary,
    String? suggestedPrep,
    String? relatedEmailIds,
    String? relatedCaptureIds,
    String? contextBrief,
    required String eventStatus,
    String? responseStatus,
    int? reminderMinutes,
    required bool hasCustomReminder,
    String? etag,
    required DateTime lastSyncedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
          id: id,
          userId: userId,
          googleEventId: googleEventId,
          calendarId: calendarId,
          title: title,
          description: description,
          location: location,
          startTime: startTime,
          endTime: endTime,
          isAllDay: isAllDay,
          isRecurring: isRecurring,
          recurringEventId: recurringEventId,
          recurrenceRule: recurrenceRule,
          organizerEmail: organizerEmail,
          attendeesJson: attendeesJson,
          attendeeCount: attendeeCount,
          meetingLink: meetingLink,
          conferenceType: conferenceType,
          aiSummary: aiSummary,
          suggestedPrep: suggestedPrep,
          relatedEmailIds: relatedEmailIds,
          relatedCaptureIds: relatedCaptureIds,
          contextBrief: contextBrief,
          eventStatus: eventStatus,
          responseStatus: responseStatus,
          reminderMinutes: reminderMinutes,
          hasCustomReminder: hasCustomReminder,
          etag: etag,
          lastSyncedAt: lastSyncedAt,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Returns a shallow copy of this [CalendarEventCache]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CalendarEventCache copyWith({
    Object? id = _Undefined,
    int? userId,
    String? googleEventId,
    String? calendarId,
    String? title,
    Object? description = _Undefined,
    Object? location = _Undefined,
    DateTime? startTime,
    DateTime? endTime,
    bool? isAllDay,
    bool? isRecurring,
    Object? recurringEventId = _Undefined,
    Object? recurrenceRule = _Undefined,
    Object? organizerEmail = _Undefined,
    Object? attendeesJson = _Undefined,
    int? attendeeCount,
    Object? meetingLink = _Undefined,
    Object? conferenceType = _Undefined,
    Object? aiSummary = _Undefined,
    Object? suggestedPrep = _Undefined,
    Object? relatedEmailIds = _Undefined,
    Object? relatedCaptureIds = _Undefined,
    Object? contextBrief = _Undefined,
    String? eventStatus,
    Object? responseStatus = _Undefined,
    Object? reminderMinutes = _Undefined,
    bool? hasCustomReminder,
    Object? etag = _Undefined,
    DateTime? lastSyncedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CalendarEventCache(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      googleEventId: googleEventId ?? this.googleEventId,
      calendarId: calendarId ?? this.calendarId,
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      location: location is String? ? location : this.location,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAllDay: isAllDay ?? this.isAllDay,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringEventId: recurringEventId is String?
          ? recurringEventId
          : this.recurringEventId,
      recurrenceRule:
          recurrenceRule is String? ? recurrenceRule : this.recurrenceRule,
      organizerEmail:
          organizerEmail is String? ? organizerEmail : this.organizerEmail,
      attendeesJson:
          attendeesJson is String? ? attendeesJson : this.attendeesJson,
      attendeeCount: attendeeCount ?? this.attendeeCount,
      meetingLink: meetingLink is String? ? meetingLink : this.meetingLink,
      conferenceType:
          conferenceType is String? ? conferenceType : this.conferenceType,
      aiSummary: aiSummary is String? ? aiSummary : this.aiSummary,
      suggestedPrep:
          suggestedPrep is String? ? suggestedPrep : this.suggestedPrep,
      relatedEmailIds:
          relatedEmailIds is String? ? relatedEmailIds : this.relatedEmailIds,
      relatedCaptureIds: relatedCaptureIds is String?
          ? relatedCaptureIds
          : this.relatedCaptureIds,
      contextBrief: contextBrief is String? ? contextBrief : this.contextBrief,
      eventStatus: eventStatus ?? this.eventStatus,
      responseStatus:
          responseStatus is String? ? responseStatus : this.responseStatus,
      reminderMinutes:
          reminderMinutes is int? ? reminderMinutes : this.reminderMinutes,
      hasCustomReminder: hasCustomReminder ?? this.hasCustomReminder,
      etag: etag is String? ? etag : this.etag,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

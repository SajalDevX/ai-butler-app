/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Calendar Event Cache
/// Caches Google Calendar events with AI enrichment
abstract class CalendarEventCache
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = CalendarEventCacheTable();

  static const db = CalendarEventCacheRepository._();

  @override
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

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static CalendarEventCacheInclude include() {
    return CalendarEventCacheInclude._();
  }

  static CalendarEventCacheIncludeList includeList({
    _i1.WhereExpressionBuilder<CalendarEventCacheTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CalendarEventCacheTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CalendarEventCacheTable>? orderByList,
    CalendarEventCacheInclude? include,
  }) {
    return CalendarEventCacheIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CalendarEventCache.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CalendarEventCache.t),
      include: include,
    );
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

class CalendarEventCacheTable extends _i1.Table<int?> {
  CalendarEventCacheTable({super.tableRelation})
      : super(tableName: 'calendar_event_cache') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    googleEventId = _i1.ColumnString(
      'googleEventId',
      this,
    );
    calendarId = _i1.ColumnString(
      'calendarId',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    location = _i1.ColumnString(
      'location',
      this,
    );
    startTime = _i1.ColumnDateTime(
      'startTime',
      this,
    );
    endTime = _i1.ColumnDateTime(
      'endTime',
      this,
    );
    isAllDay = _i1.ColumnBool(
      'isAllDay',
      this,
    );
    isRecurring = _i1.ColumnBool(
      'isRecurring',
      this,
    );
    recurringEventId = _i1.ColumnString(
      'recurringEventId',
      this,
    );
    recurrenceRule = _i1.ColumnString(
      'recurrenceRule',
      this,
    );
    organizerEmail = _i1.ColumnString(
      'organizerEmail',
      this,
    );
    attendeesJson = _i1.ColumnString(
      'attendeesJson',
      this,
    );
    attendeeCount = _i1.ColumnInt(
      'attendeeCount',
      this,
    );
    meetingLink = _i1.ColumnString(
      'meetingLink',
      this,
    );
    conferenceType = _i1.ColumnString(
      'conferenceType',
      this,
    );
    aiSummary = _i1.ColumnString(
      'aiSummary',
      this,
    );
    suggestedPrep = _i1.ColumnString(
      'suggestedPrep',
      this,
    );
    relatedEmailIds = _i1.ColumnString(
      'relatedEmailIds',
      this,
    );
    relatedCaptureIds = _i1.ColumnString(
      'relatedCaptureIds',
      this,
    );
    contextBrief = _i1.ColumnString(
      'contextBrief',
      this,
    );
    eventStatus = _i1.ColumnString(
      'eventStatus',
      this,
    );
    responseStatus = _i1.ColumnString(
      'responseStatus',
      this,
    );
    reminderMinutes = _i1.ColumnInt(
      'reminderMinutes',
      this,
    );
    hasCustomReminder = _i1.ColumnBool(
      'hasCustomReminder',
      this,
    );
    etag = _i1.ColumnString(
      'etag',
      this,
    );
    lastSyncedAt = _i1.ColumnDateTime(
      'lastSyncedAt',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final _i1.ColumnInt userId;

  late final _i1.ColumnString googleEventId;

  late final _i1.ColumnString calendarId;

  late final _i1.ColumnString title;

  late final _i1.ColumnString description;

  late final _i1.ColumnString location;

  late final _i1.ColumnDateTime startTime;

  late final _i1.ColumnDateTime endTime;

  late final _i1.ColumnBool isAllDay;

  late final _i1.ColumnBool isRecurring;

  late final _i1.ColumnString recurringEventId;

  late final _i1.ColumnString recurrenceRule;

  late final _i1.ColumnString organizerEmail;

  late final _i1.ColumnString attendeesJson;

  late final _i1.ColumnInt attendeeCount;

  late final _i1.ColumnString meetingLink;

  late final _i1.ColumnString conferenceType;

  late final _i1.ColumnString aiSummary;

  late final _i1.ColumnString suggestedPrep;

  late final _i1.ColumnString relatedEmailIds;

  late final _i1.ColumnString relatedCaptureIds;

  late final _i1.ColumnString contextBrief;

  late final _i1.ColumnString eventStatus;

  late final _i1.ColumnString responseStatus;

  late final _i1.ColumnInt reminderMinutes;

  late final _i1.ColumnBool hasCustomReminder;

  late final _i1.ColumnString etag;

  late final _i1.ColumnDateTime lastSyncedAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        googleEventId,
        calendarId,
        title,
        description,
        location,
        startTime,
        endTime,
        isAllDay,
        isRecurring,
        recurringEventId,
        recurrenceRule,
        organizerEmail,
        attendeesJson,
        attendeeCount,
        meetingLink,
        conferenceType,
        aiSummary,
        suggestedPrep,
        relatedEmailIds,
        relatedCaptureIds,
        contextBrief,
        eventStatus,
        responseStatus,
        reminderMinutes,
        hasCustomReminder,
        etag,
        lastSyncedAt,
        createdAt,
        updatedAt,
      ];
}

class CalendarEventCacheInclude extends _i1.IncludeObject {
  CalendarEventCacheInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CalendarEventCache.t;
}

class CalendarEventCacheIncludeList extends _i1.IncludeList {
  CalendarEventCacheIncludeList._({
    _i1.WhereExpressionBuilder<CalendarEventCacheTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CalendarEventCache.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CalendarEventCache.t;
}

class CalendarEventCacheRepository {
  const CalendarEventCacheRepository._();

  /// Returns a list of [CalendarEventCache]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<CalendarEventCache>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CalendarEventCacheTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CalendarEventCacheTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CalendarEventCacheTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<CalendarEventCache>(
      where: where?.call(CalendarEventCache.t),
      orderBy: orderBy?.call(CalendarEventCache.t),
      orderByList: orderByList?.call(CalendarEventCache.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [CalendarEventCache] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<CalendarEventCache?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CalendarEventCacheTable>? where,
    int? offset,
    _i1.OrderByBuilder<CalendarEventCacheTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CalendarEventCacheTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<CalendarEventCache>(
      where: where?.call(CalendarEventCache.t),
      orderBy: orderBy?.call(CalendarEventCache.t),
      orderByList: orderByList?.call(CalendarEventCache.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [CalendarEventCache] by its [id] or null if no such row exists.
  Future<CalendarEventCache?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<CalendarEventCache>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [CalendarEventCache]s in the list and returns the inserted rows.
  ///
  /// The returned [CalendarEventCache]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<CalendarEventCache>> insert(
    _i1.Session session,
    List<CalendarEventCache> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<CalendarEventCache>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [CalendarEventCache] and returns the inserted row.
  ///
  /// The returned [CalendarEventCache] will have its `id` field set.
  Future<CalendarEventCache> insertRow(
    _i1.Session session,
    CalendarEventCache row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CalendarEventCache>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CalendarEventCache]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CalendarEventCache>> update(
    _i1.Session session,
    List<CalendarEventCache> rows, {
    _i1.ColumnSelections<CalendarEventCacheTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CalendarEventCache>(
      rows,
      columns: columns?.call(CalendarEventCache.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CalendarEventCache]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CalendarEventCache> updateRow(
    _i1.Session session,
    CalendarEventCache row, {
    _i1.ColumnSelections<CalendarEventCacheTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CalendarEventCache>(
      row,
      columns: columns?.call(CalendarEventCache.t),
      transaction: transaction,
    );
  }

  /// Deletes all [CalendarEventCache]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CalendarEventCache>> delete(
    _i1.Session session,
    List<CalendarEventCache> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CalendarEventCache>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CalendarEventCache].
  Future<CalendarEventCache> deleteRow(
    _i1.Session session,
    CalendarEventCache row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CalendarEventCache>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CalendarEventCache>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CalendarEventCacheTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CalendarEventCache>(
      where: where(CalendarEventCache.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CalendarEventCacheTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CalendarEventCache>(
      where: where?.call(CalendarEventCache.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

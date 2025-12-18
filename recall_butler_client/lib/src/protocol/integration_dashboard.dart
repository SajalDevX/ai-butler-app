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
import 'email_summary.dart' as _i2;
import 'calendar_event_cache.dart' as _i3;

/// Dashboard data for Google integrations
abstract class IntegrationDashboard implements _i1.SerializableModel {
  IntegrationDashboard._({
    required this.unreadEmailCount,
    required this.actionableEmailCount,
    required this.importantEmails,
    required this.todayEvents,
    required this.upcomingMeetings,
    required this.gmailEnabled,
    required this.calendarEnabled,
    this.lastGmailSync,
    this.lastCalendarSync,
  });

  factory IntegrationDashboard({
    required int unreadEmailCount,
    required int actionableEmailCount,
    required List<_i2.EmailSummary> importantEmails,
    required List<_i3.CalendarEventCache> todayEvents,
    required List<_i3.CalendarEventCache> upcomingMeetings,
    required bool gmailEnabled,
    required bool calendarEnabled,
    DateTime? lastGmailSync,
    DateTime? lastCalendarSync,
  }) = _IntegrationDashboardImpl;

  factory IntegrationDashboard.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return IntegrationDashboard(
      unreadEmailCount: jsonSerialization['unreadEmailCount'] as int,
      actionableEmailCount: jsonSerialization['actionableEmailCount'] as int,
      importantEmails: (jsonSerialization['importantEmails'] as List)
          .map((e) => _i2.EmailSummary.fromJson((e as Map<String, dynamic>)))
          .toList(),
      todayEvents: (jsonSerialization['todayEvents'] as List)
          .map((e) =>
              _i3.CalendarEventCache.fromJson((e as Map<String, dynamic>)))
          .toList(),
      upcomingMeetings: (jsonSerialization['upcomingMeetings'] as List)
          .map((e) =>
              _i3.CalendarEventCache.fromJson((e as Map<String, dynamic>)))
          .toList(),
      gmailEnabled: jsonSerialization['gmailEnabled'] as bool,
      calendarEnabled: jsonSerialization['calendarEnabled'] as bool,
      lastGmailSync: jsonSerialization['lastGmailSync'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastGmailSync']),
      lastCalendarSync: jsonSerialization['lastCalendarSync'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastCalendarSync']),
    );
  }

  int unreadEmailCount;

  int actionableEmailCount;

  List<_i2.EmailSummary> importantEmails;

  List<_i3.CalendarEventCache> todayEvents;

  List<_i3.CalendarEventCache> upcomingMeetings;

  bool gmailEnabled;

  bool calendarEnabled;

  DateTime? lastGmailSync;

  DateTime? lastCalendarSync;

  /// Returns a shallow copy of this [IntegrationDashboard]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  IntegrationDashboard copyWith({
    int? unreadEmailCount,
    int? actionableEmailCount,
    List<_i2.EmailSummary>? importantEmails,
    List<_i3.CalendarEventCache>? todayEvents,
    List<_i3.CalendarEventCache>? upcomingMeetings,
    bool? gmailEnabled,
    bool? calendarEnabled,
    DateTime? lastGmailSync,
    DateTime? lastCalendarSync,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'unreadEmailCount': unreadEmailCount,
      'actionableEmailCount': actionableEmailCount,
      'importantEmails': importantEmails.toJson(valueToJson: (v) => v.toJson()),
      'todayEvents': todayEvents.toJson(valueToJson: (v) => v.toJson()),
      'upcomingMeetings':
          upcomingMeetings.toJson(valueToJson: (v) => v.toJson()),
      'gmailEnabled': gmailEnabled,
      'calendarEnabled': calendarEnabled,
      if (lastGmailSync != null) 'lastGmailSync': lastGmailSync?.toJson(),
      if (lastCalendarSync != null)
        'lastCalendarSync': lastCalendarSync?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IntegrationDashboardImpl extends IntegrationDashboard {
  _IntegrationDashboardImpl({
    required int unreadEmailCount,
    required int actionableEmailCount,
    required List<_i2.EmailSummary> importantEmails,
    required List<_i3.CalendarEventCache> todayEvents,
    required List<_i3.CalendarEventCache> upcomingMeetings,
    required bool gmailEnabled,
    required bool calendarEnabled,
    DateTime? lastGmailSync,
    DateTime? lastCalendarSync,
  }) : super._(
          unreadEmailCount: unreadEmailCount,
          actionableEmailCount: actionableEmailCount,
          importantEmails: importantEmails,
          todayEvents: todayEvents,
          upcomingMeetings: upcomingMeetings,
          gmailEnabled: gmailEnabled,
          calendarEnabled: calendarEnabled,
          lastGmailSync: lastGmailSync,
          lastCalendarSync: lastCalendarSync,
        );

  /// Returns a shallow copy of this [IntegrationDashboard]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  IntegrationDashboard copyWith({
    int? unreadEmailCount,
    int? actionableEmailCount,
    List<_i2.EmailSummary>? importantEmails,
    List<_i3.CalendarEventCache>? todayEvents,
    List<_i3.CalendarEventCache>? upcomingMeetings,
    bool? gmailEnabled,
    bool? calendarEnabled,
    Object? lastGmailSync = _Undefined,
    Object? lastCalendarSync = _Undefined,
  }) {
    return IntegrationDashboard(
      unreadEmailCount: unreadEmailCount ?? this.unreadEmailCount,
      actionableEmailCount: actionableEmailCount ?? this.actionableEmailCount,
      importantEmails: importantEmails ??
          this.importantEmails.map((e0) => e0.copyWith()).toList(),
      todayEvents:
          todayEvents ?? this.todayEvents.map((e0) => e0.copyWith()).toList(),
      upcomingMeetings: upcomingMeetings ??
          this.upcomingMeetings.map((e0) => e0.copyWith()).toList(),
      gmailEnabled: gmailEnabled ?? this.gmailEnabled,
      calendarEnabled: calendarEnabled ?? this.calendarEnabled,
      lastGmailSync:
          lastGmailSync is DateTime? ? lastGmailSync : this.lastGmailSync,
      lastCalendarSync: lastCalendarSync is DateTime?
          ? lastCalendarSync
          : this.lastCalendarSync,
    );
  }
}

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
import 'greeting.dart' as _i2;
import 'action.dart' as _i3;
import 'calendar_event_cache.dart' as _i4;
import 'capture.dart' as _i5;
import 'capture_collection.dart' as _i6;
import 'capture_request.dart' as _i7;
import 'collection.dart' as _i8;
import 'dashboard_stats.dart' as _i9;
import 'device_token.dart' as _i10;
import 'email_draft_result.dart' as _i11;
import 'email_send_result.dart' as _i12;
import 'email_summary.dart' as _i13;
import 'google_auth_result.dart' as _i14;
import 'google_auth_status.dart' as _i15;
import 'google_token.dart' as _i16;
import 'integration_dashboard.dart' as _i17;
import 'meeting_prep_result.dart' as _i18;
import 'morning_briefing.dart' as _i19;
import 'notification_log.dart' as _i20;
import 'reminder.dart' as _i21;
import 'scheduled_email_task.dart' as _i22;
import 'search_query.dart' as _i23;
import 'search_request.dart' as _i24;
import 'search_result.dart' as _i25;
import 'sync_result.dart' as _i26;
import 'sync_task.dart' as _i27;
import 'token_usage_history.dart' as _i28;
import 'user_preference.dart' as _i29;
import 'weekly_digest.dart' as _i30;
import 'package:recall_butler_client/src/protocol/action.dart' as _i31;
import 'package:recall_butler_client/src/protocol/capture.dart' as _i32;
import 'package:recall_butler_client/src/protocol/collection.dart' as _i33;
import 'package:recall_butler_client/src/protocol/email_summary.dart' as _i34;
import 'package:recall_butler_client/src/protocol/calendar_event_cache.dart'
    as _i35;
import 'package:recall_butler_client/src/protocol/notification_log.dart'
    as _i36;
export 'greeting.dart';
export 'action.dart';
export 'calendar_event_cache.dart';
export 'capture.dart';
export 'capture_collection.dart';
export 'capture_request.dart';
export 'collection.dart';
export 'dashboard_stats.dart';
export 'device_token.dart';
export 'email_draft_result.dart';
export 'email_send_result.dart';
export 'email_summary.dart';
export 'google_auth_result.dart';
export 'google_auth_status.dart';
export 'google_token.dart';
export 'integration_dashboard.dart';
export 'meeting_prep_result.dart';
export 'morning_briefing.dart';
export 'notification_log.dart';
export 'reminder.dart';
export 'scheduled_email_task.dart';
export 'search_query.dart';
export 'search_request.dart';
export 'search_result.dart';
export 'sync_result.dart';
export 'sync_task.dart';
export 'token_usage_history.dart';
export 'user_preference.dart';
export 'weekly_digest.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i2.Greeting) {
      return _i2.Greeting.fromJson(data) as T;
    }
    if (t == _i3.Action) {
      return _i3.Action.fromJson(data) as T;
    }
    if (t == _i4.CalendarEventCache) {
      return _i4.CalendarEventCache.fromJson(data) as T;
    }
    if (t == _i5.Capture) {
      return _i5.Capture.fromJson(data) as T;
    }
    if (t == _i6.CaptureCollection) {
      return _i6.CaptureCollection.fromJson(data) as T;
    }
    if (t == _i7.CaptureRequest) {
      return _i7.CaptureRequest.fromJson(data) as T;
    }
    if (t == _i8.Collection) {
      return _i8.Collection.fromJson(data) as T;
    }
    if (t == _i9.DashboardStats) {
      return _i9.DashboardStats.fromJson(data) as T;
    }
    if (t == _i10.DeviceToken) {
      return _i10.DeviceToken.fromJson(data) as T;
    }
    if (t == _i11.EmailDraftResult) {
      return _i11.EmailDraftResult.fromJson(data) as T;
    }
    if (t == _i12.EmailSendResult) {
      return _i12.EmailSendResult.fromJson(data) as T;
    }
    if (t == _i13.EmailSummary) {
      return _i13.EmailSummary.fromJson(data) as T;
    }
    if (t == _i14.GoogleAuthResult) {
      return _i14.GoogleAuthResult.fromJson(data) as T;
    }
    if (t == _i15.GoogleAuthStatus) {
      return _i15.GoogleAuthStatus.fromJson(data) as T;
    }
    if (t == _i16.GoogleToken) {
      return _i16.GoogleToken.fromJson(data) as T;
    }
    if (t == _i17.IntegrationDashboard) {
      return _i17.IntegrationDashboard.fromJson(data) as T;
    }
    if (t == _i18.MeetingPrepResult) {
      return _i18.MeetingPrepResult.fromJson(data) as T;
    }
    if (t == _i19.MorningBriefing) {
      return _i19.MorningBriefing.fromJson(data) as T;
    }
    if (t == _i20.NotificationLog) {
      return _i20.NotificationLog.fromJson(data) as T;
    }
    if (t == _i21.Reminder) {
      return _i21.Reminder.fromJson(data) as T;
    }
    if (t == _i22.ScheduledEmailTask) {
      return _i22.ScheduledEmailTask.fromJson(data) as T;
    }
    if (t == _i23.SearchQuery) {
      return _i23.SearchQuery.fromJson(data) as T;
    }
    if (t == _i24.SearchRequest) {
      return _i24.SearchRequest.fromJson(data) as T;
    }
    if (t == _i25.SearchResult) {
      return _i25.SearchResult.fromJson(data) as T;
    }
    if (t == _i26.SyncResult) {
      return _i26.SyncResult.fromJson(data) as T;
    }
    if (t == _i27.SyncTask) {
      return _i27.SyncTask.fromJson(data) as T;
    }
    if (t == _i28.TokenUsageHistory) {
      return _i28.TokenUsageHistory.fromJson(data) as T;
    }
    if (t == _i29.UserPreference) {
      return _i29.UserPreference.fromJson(data) as T;
    }
    if (t == _i30.WeeklyDigest) {
      return _i30.WeeklyDigest.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Greeting?>()) {
      return (data != null ? _i2.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.Action?>()) {
      return (data != null ? _i3.Action.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.CalendarEventCache?>()) {
      return (data != null ? _i4.CalendarEventCache.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.Capture?>()) {
      return (data != null ? _i5.Capture.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.CaptureCollection?>()) {
      return (data != null ? _i6.CaptureCollection.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.CaptureRequest?>()) {
      return (data != null ? _i7.CaptureRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.Collection?>()) {
      return (data != null ? _i8.Collection.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.DashboardStats?>()) {
      return (data != null ? _i9.DashboardStats.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.DeviceToken?>()) {
      return (data != null ? _i10.DeviceToken.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.EmailDraftResult?>()) {
      return (data != null ? _i11.EmailDraftResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.EmailSendResult?>()) {
      return (data != null ? _i12.EmailSendResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.EmailSummary?>()) {
      return (data != null ? _i13.EmailSummary.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.GoogleAuthResult?>()) {
      return (data != null ? _i14.GoogleAuthResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.GoogleAuthStatus?>()) {
      return (data != null ? _i15.GoogleAuthStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.GoogleToken?>()) {
      return (data != null ? _i16.GoogleToken.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.IntegrationDashboard?>()) {
      return (data != null ? _i17.IntegrationDashboard.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i18.MeetingPrepResult?>()) {
      return (data != null ? _i18.MeetingPrepResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.MorningBriefing?>()) {
      return (data != null ? _i19.MorningBriefing.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.NotificationLog?>()) {
      return (data != null ? _i20.NotificationLog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.Reminder?>()) {
      return (data != null ? _i21.Reminder.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.ScheduledEmailTask?>()) {
      return (data != null ? _i22.ScheduledEmailTask.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i23.SearchQuery?>()) {
      return (data != null ? _i23.SearchQuery.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.SearchRequest?>()) {
      return (data != null ? _i24.SearchRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.SearchResult?>()) {
      return (data != null ? _i25.SearchResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.SyncResult?>()) {
      return (data != null ? _i26.SyncResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.SyncTask?>()) {
      return (data != null ? _i27.SyncTask.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.TokenUsageHistory?>()) {
      return (data != null ? _i28.TokenUsageHistory.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.UserPreference?>()) {
      return (data != null ? _i29.UserPreference.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.WeeklyDigest?>()) {
      return (data != null ? _i30.WeeklyDigest.fromJson(data) : null) as T;
    }
    if (t == List<_i13.EmailSummary>) {
      return (data as List)
          .map((e) => deserialize<_i13.EmailSummary>(e))
          .toList() as T;
    }
    if (t == List<_i4.CalendarEventCache>) {
      return (data as List)
          .map((e) => deserialize<_i4.CalendarEventCache>(e))
          .toList() as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i5.Capture>) {
      return (data as List).map((e) => deserialize<_i5.Capture>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<String>(e)).toList()
          : null) as T;
    }
    if (t == List<_i31.Action>) {
      return (data as List).map((e) => deserialize<_i31.Action>(e)).toList()
          as T;
    }
    if (t == List<Map<String, dynamic>>) {
      return (data as List)
          .map((e) => deserialize<Map<String, dynamic>>(e))
          .toList() as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<dynamic>(v))) as T;
    }
    if (t == List<_i32.Capture>) {
      return (data as List).map((e) => deserialize<_i32.Capture>(e)).toList()
          as T;
    }
    if (t == List<_i33.Collection>) {
      return (data as List).map((e) => deserialize<_i33.Collection>(e)).toList()
          as T;
    }
    if (t == List<_i34.EmailSummary>) {
      return (data as List)
          .map((e) => deserialize<_i34.EmailSummary>(e))
          .toList() as T;
    }
    if (t == List<_i35.CalendarEventCache>) {
      return (data as List)
          .map((e) => deserialize<_i35.CalendarEventCache>(e))
          .toList() as T;
    }
    if (t == List<_i36.NotificationLog>) {
      return (data as List)
          .map((e) => deserialize<_i36.NotificationLog>(e))
          .toList() as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.Greeting) {
      return 'Greeting';
    }
    if (data is _i3.Action) {
      return 'Action';
    }
    if (data is _i4.CalendarEventCache) {
      return 'CalendarEventCache';
    }
    if (data is _i5.Capture) {
      return 'Capture';
    }
    if (data is _i6.CaptureCollection) {
      return 'CaptureCollection';
    }
    if (data is _i7.CaptureRequest) {
      return 'CaptureRequest';
    }
    if (data is _i8.Collection) {
      return 'Collection';
    }
    if (data is _i9.DashboardStats) {
      return 'DashboardStats';
    }
    if (data is _i10.DeviceToken) {
      return 'DeviceToken';
    }
    if (data is _i11.EmailDraftResult) {
      return 'EmailDraftResult';
    }
    if (data is _i12.EmailSendResult) {
      return 'EmailSendResult';
    }
    if (data is _i13.EmailSummary) {
      return 'EmailSummary';
    }
    if (data is _i14.GoogleAuthResult) {
      return 'GoogleAuthResult';
    }
    if (data is _i15.GoogleAuthStatus) {
      return 'GoogleAuthStatus';
    }
    if (data is _i16.GoogleToken) {
      return 'GoogleToken';
    }
    if (data is _i17.IntegrationDashboard) {
      return 'IntegrationDashboard';
    }
    if (data is _i18.MeetingPrepResult) {
      return 'MeetingPrepResult';
    }
    if (data is _i19.MorningBriefing) {
      return 'MorningBriefing';
    }
    if (data is _i20.NotificationLog) {
      return 'NotificationLog';
    }
    if (data is _i21.Reminder) {
      return 'Reminder';
    }
    if (data is _i22.ScheduledEmailTask) {
      return 'ScheduledEmailTask';
    }
    if (data is _i23.SearchQuery) {
      return 'SearchQuery';
    }
    if (data is _i24.SearchRequest) {
      return 'SearchRequest';
    }
    if (data is _i25.SearchResult) {
      return 'SearchResult';
    }
    if (data is _i26.SyncResult) {
      return 'SyncResult';
    }
    if (data is _i27.SyncTask) {
      return 'SyncTask';
    }
    if (data is _i28.TokenUsageHistory) {
      return 'TokenUsageHistory';
    }
    if (data is _i29.UserPreference) {
      return 'UserPreference';
    }
    if (data is _i30.WeeklyDigest) {
      return 'WeeklyDigest';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i2.Greeting>(data['data']);
    }
    if (dataClassName == 'Action') {
      return deserialize<_i3.Action>(data['data']);
    }
    if (dataClassName == 'CalendarEventCache') {
      return deserialize<_i4.CalendarEventCache>(data['data']);
    }
    if (dataClassName == 'Capture') {
      return deserialize<_i5.Capture>(data['data']);
    }
    if (dataClassName == 'CaptureCollection') {
      return deserialize<_i6.CaptureCollection>(data['data']);
    }
    if (dataClassName == 'CaptureRequest') {
      return deserialize<_i7.CaptureRequest>(data['data']);
    }
    if (dataClassName == 'Collection') {
      return deserialize<_i8.Collection>(data['data']);
    }
    if (dataClassName == 'DashboardStats') {
      return deserialize<_i9.DashboardStats>(data['data']);
    }
    if (dataClassName == 'DeviceToken') {
      return deserialize<_i10.DeviceToken>(data['data']);
    }
    if (dataClassName == 'EmailDraftResult') {
      return deserialize<_i11.EmailDraftResult>(data['data']);
    }
    if (dataClassName == 'EmailSendResult') {
      return deserialize<_i12.EmailSendResult>(data['data']);
    }
    if (dataClassName == 'EmailSummary') {
      return deserialize<_i13.EmailSummary>(data['data']);
    }
    if (dataClassName == 'GoogleAuthResult') {
      return deserialize<_i14.GoogleAuthResult>(data['data']);
    }
    if (dataClassName == 'GoogleAuthStatus') {
      return deserialize<_i15.GoogleAuthStatus>(data['data']);
    }
    if (dataClassName == 'GoogleToken') {
      return deserialize<_i16.GoogleToken>(data['data']);
    }
    if (dataClassName == 'IntegrationDashboard') {
      return deserialize<_i17.IntegrationDashboard>(data['data']);
    }
    if (dataClassName == 'MeetingPrepResult') {
      return deserialize<_i18.MeetingPrepResult>(data['data']);
    }
    if (dataClassName == 'MorningBriefing') {
      return deserialize<_i19.MorningBriefing>(data['data']);
    }
    if (dataClassName == 'NotificationLog') {
      return deserialize<_i20.NotificationLog>(data['data']);
    }
    if (dataClassName == 'Reminder') {
      return deserialize<_i21.Reminder>(data['data']);
    }
    if (dataClassName == 'ScheduledEmailTask') {
      return deserialize<_i22.ScheduledEmailTask>(data['data']);
    }
    if (dataClassName == 'SearchQuery') {
      return deserialize<_i23.SearchQuery>(data['data']);
    }
    if (dataClassName == 'SearchRequest') {
      return deserialize<_i24.SearchRequest>(data['data']);
    }
    if (dataClassName == 'SearchResult') {
      return deserialize<_i25.SearchResult>(data['data']);
    }
    if (dataClassName == 'SyncResult') {
      return deserialize<_i26.SyncResult>(data['data']);
    }
    if (dataClassName == 'SyncTask') {
      return deserialize<_i27.SyncTask>(data['data']);
    }
    if (dataClassName == 'TokenUsageHistory') {
      return deserialize<_i28.TokenUsageHistory>(data['data']);
    }
    if (dataClassName == 'UserPreference') {
      return deserialize<_i29.UserPreference>(data['data']);
    }
    if (dataClassName == 'WeeklyDigest') {
      return deserialize<_i30.WeeklyDigest>(data['data']);
    }
    return super.deserializeByClassName(data);
  }
}

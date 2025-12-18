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
import 'capture.dart' as _i4;
import 'capture_collection.dart' as _i5;
import 'capture_request.dart' as _i6;
import 'collection.dart' as _i7;
import 'dashboard_stats.dart' as _i8;
import 'morning_briefing.dart' as _i9;
import 'reminder.dart' as _i10;
import 'search_query.dart' as _i11;
import 'search_request.dart' as _i12;
import 'search_result.dart' as _i13;
import 'token_usage_history.dart' as _i14;
import 'user_preference.dart' as _i15;
import 'weekly_digest.dart' as _i16;
import 'package:recall_butler_client/src/protocol/action.dart' as _i17;
import 'package:recall_butler_client/src/protocol/capture.dart' as _i18;
import 'package:recall_butler_client/src/protocol/collection.dart' as _i19;
export 'greeting.dart';
export 'action.dart';
export 'capture.dart';
export 'capture_collection.dart';
export 'capture_request.dart';
export 'collection.dart';
export 'dashboard_stats.dart';
export 'morning_briefing.dart';
export 'reminder.dart';
export 'search_query.dart';
export 'search_request.dart';
export 'search_result.dart';
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
    if (t == _i4.Capture) {
      return _i4.Capture.fromJson(data) as T;
    }
    if (t == _i5.CaptureCollection) {
      return _i5.CaptureCollection.fromJson(data) as T;
    }
    if (t == _i6.CaptureRequest) {
      return _i6.CaptureRequest.fromJson(data) as T;
    }
    if (t == _i7.Collection) {
      return _i7.Collection.fromJson(data) as T;
    }
    if (t == _i8.DashboardStats) {
      return _i8.DashboardStats.fromJson(data) as T;
    }
    if (t == _i9.MorningBriefing) {
      return _i9.MorningBriefing.fromJson(data) as T;
    }
    if (t == _i10.Reminder) {
      return _i10.Reminder.fromJson(data) as T;
    }
    if (t == _i11.SearchQuery) {
      return _i11.SearchQuery.fromJson(data) as T;
    }
    if (t == _i12.SearchRequest) {
      return _i12.SearchRequest.fromJson(data) as T;
    }
    if (t == _i13.SearchResult) {
      return _i13.SearchResult.fromJson(data) as T;
    }
    if (t == _i14.TokenUsageHistory) {
      return _i14.TokenUsageHistory.fromJson(data) as T;
    }
    if (t == _i15.UserPreference) {
      return _i15.UserPreference.fromJson(data) as T;
    }
    if (t == _i16.WeeklyDigest) {
      return _i16.WeeklyDigest.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Greeting?>()) {
      return (data != null ? _i2.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.Action?>()) {
      return (data != null ? _i3.Action.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.Capture?>()) {
      return (data != null ? _i4.Capture.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.CaptureCollection?>()) {
      return (data != null ? _i5.CaptureCollection.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.CaptureRequest?>()) {
      return (data != null ? _i6.CaptureRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.Collection?>()) {
      return (data != null ? _i7.Collection.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.DashboardStats?>()) {
      return (data != null ? _i8.DashboardStats.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.MorningBriefing?>()) {
      return (data != null ? _i9.MorningBriefing.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.Reminder?>()) {
      return (data != null ? _i10.Reminder.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.SearchQuery?>()) {
      return (data != null ? _i11.SearchQuery.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.SearchRequest?>()) {
      return (data != null ? _i12.SearchRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.SearchResult?>()) {
      return (data != null ? _i13.SearchResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.TokenUsageHistory?>()) {
      return (data != null ? _i14.TokenUsageHistory.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.UserPreference?>()) {
      return (data != null ? _i15.UserPreference.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.WeeklyDigest?>()) {
      return (data != null ? _i16.WeeklyDigest.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i4.Capture>) {
      return (data as List).map((e) => deserialize<_i4.Capture>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<String>(e)).toList()
          : null) as T;
    }
    if (t == List<_i17.Action>) {
      return (data as List).map((e) => deserialize<_i17.Action>(e)).toList()
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
    if (t == List<_i18.Capture>) {
      return (data as List).map((e) => deserialize<_i18.Capture>(e)).toList()
          as T;
    }
    if (t == List<_i19.Collection>) {
      return (data as List).map((e) => deserialize<_i19.Collection>(e)).toList()
          as T;
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
    if (data is _i4.Capture) {
      return 'Capture';
    }
    if (data is _i5.CaptureCollection) {
      return 'CaptureCollection';
    }
    if (data is _i6.CaptureRequest) {
      return 'CaptureRequest';
    }
    if (data is _i7.Collection) {
      return 'Collection';
    }
    if (data is _i8.DashboardStats) {
      return 'DashboardStats';
    }
    if (data is _i9.MorningBriefing) {
      return 'MorningBriefing';
    }
    if (data is _i10.Reminder) {
      return 'Reminder';
    }
    if (data is _i11.SearchQuery) {
      return 'SearchQuery';
    }
    if (data is _i12.SearchRequest) {
      return 'SearchRequest';
    }
    if (data is _i13.SearchResult) {
      return 'SearchResult';
    }
    if (data is _i14.TokenUsageHistory) {
      return 'TokenUsageHistory';
    }
    if (data is _i15.UserPreference) {
      return 'UserPreference';
    }
    if (data is _i16.WeeklyDigest) {
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
    if (dataClassName == 'Capture') {
      return deserialize<_i4.Capture>(data['data']);
    }
    if (dataClassName == 'CaptureCollection') {
      return deserialize<_i5.CaptureCollection>(data['data']);
    }
    if (dataClassName == 'CaptureRequest') {
      return deserialize<_i6.CaptureRequest>(data['data']);
    }
    if (dataClassName == 'Collection') {
      return deserialize<_i7.Collection>(data['data']);
    }
    if (dataClassName == 'DashboardStats') {
      return deserialize<_i8.DashboardStats>(data['data']);
    }
    if (dataClassName == 'MorningBriefing') {
      return deserialize<_i9.MorningBriefing>(data['data']);
    }
    if (dataClassName == 'Reminder') {
      return deserialize<_i10.Reminder>(data['data']);
    }
    if (dataClassName == 'SearchQuery') {
      return deserialize<_i11.SearchQuery>(data['data']);
    }
    if (dataClassName == 'SearchRequest') {
      return deserialize<_i12.SearchRequest>(data['data']);
    }
    if (dataClassName == 'SearchResult') {
      return deserialize<_i13.SearchResult>(data['data']);
    }
    if (dataClassName == 'TokenUsageHistory') {
      return deserialize<_i14.TokenUsageHistory>(data['data']);
    }
    if (dataClassName == 'UserPreference') {
      return deserialize<_i15.UserPreference>(data['data']);
    }
    if (dataClassName == 'WeeklyDigest') {
      return deserialize<_i16.WeeklyDigest>(data['data']);
    }
    return super.deserializeByClassName(data);
  }
}

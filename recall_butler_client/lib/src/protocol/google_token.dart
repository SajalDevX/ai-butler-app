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

/// Google OAuth Token Storage
/// Stores encrypted OAuth tokens for Google API access
abstract class GoogleToken implements _i1.SerializableModel {
  GoogleToken._({
    this.id,
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.scope,
    required this.gmailEnabled,
    required this.calendarEnabled,
    this.lastGmailSync,
    this.lastCalendarSync,
    this.gmailHistoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GoogleToken({
    int? id,
    required int userId,
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
    required String scope,
    required bool gmailEnabled,
    required bool calendarEnabled,
    DateTime? lastGmailSync,
    DateTime? lastCalendarSync,
    String? gmailHistoryId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _GoogleTokenImpl;

  factory GoogleToken.fromJson(Map<String, dynamic> jsonSerialization) {
    return GoogleToken(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      accessToken: jsonSerialization['accessToken'] as String,
      refreshToken: jsonSerialization['refreshToken'] as String,
      expiresAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      scope: jsonSerialization['scope'] as String,
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
      gmailHistoryId: jsonSerialization['gmailHistoryId'] as String?,
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

  String accessToken;

  String refreshToken;

  DateTime expiresAt;

  String scope;

  bool gmailEnabled;

  bool calendarEnabled;

  DateTime? lastGmailSync;

  DateTime? lastCalendarSync;

  String? gmailHistoryId;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [GoogleToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  GoogleToken copyWith({
    int? id,
    int? userId,
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    String? scope,
    bool? gmailEnabled,
    bool? calendarEnabled,
    DateTime? lastGmailSync,
    DateTime? lastCalendarSync,
    String? gmailHistoryId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toJson(),
      'scope': scope,
      'gmailEnabled': gmailEnabled,
      'calendarEnabled': calendarEnabled,
      if (lastGmailSync != null) 'lastGmailSync': lastGmailSync?.toJson(),
      if (lastCalendarSync != null)
        'lastCalendarSync': lastCalendarSync?.toJson(),
      if (gmailHistoryId != null) 'gmailHistoryId': gmailHistoryId,
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

class _GoogleTokenImpl extends GoogleToken {
  _GoogleTokenImpl({
    int? id,
    required int userId,
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
    required String scope,
    required bool gmailEnabled,
    required bool calendarEnabled,
    DateTime? lastGmailSync,
    DateTime? lastCalendarSync,
    String? gmailHistoryId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
          id: id,
          userId: userId,
          accessToken: accessToken,
          refreshToken: refreshToken,
          expiresAt: expiresAt,
          scope: scope,
          gmailEnabled: gmailEnabled,
          calendarEnabled: calendarEnabled,
          lastGmailSync: lastGmailSync,
          lastCalendarSync: lastCalendarSync,
          gmailHistoryId: gmailHistoryId,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Returns a shallow copy of this [GoogleToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  GoogleToken copyWith({
    Object? id = _Undefined,
    int? userId,
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    String? scope,
    bool? gmailEnabled,
    bool? calendarEnabled,
    Object? lastGmailSync = _Undefined,
    Object? lastCalendarSync = _Undefined,
    Object? gmailHistoryId = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GoogleToken(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      scope: scope ?? this.scope,
      gmailEnabled: gmailEnabled ?? this.gmailEnabled,
      calendarEnabled: calendarEnabled ?? this.calendarEnabled,
      lastGmailSync:
          lastGmailSync is DateTime? ? lastGmailSync : this.lastGmailSync,
      lastCalendarSync: lastCalendarSync is DateTime?
          ? lastCalendarSync
          : this.lastCalendarSync,
      gmailHistoryId:
          gmailHistoryId is String? ? gmailHistoryId : this.gmailHistoryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

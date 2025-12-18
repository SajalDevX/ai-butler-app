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

/// Current Google authentication status
abstract class GoogleAuthStatus implements _i1.SerializableModel {
  GoogleAuthStatus._({
    required this.isAuthenticated,
    required this.gmailEnabled,
    required this.calendarEnabled,
    this.lastGmailSync,
    this.lastCalendarSync,
    this.tokenExpiresAt,
  });

  factory GoogleAuthStatus({
    required bool isAuthenticated,
    required bool gmailEnabled,
    required bool calendarEnabled,
    DateTime? lastGmailSync,
    DateTime? lastCalendarSync,
    DateTime? tokenExpiresAt,
  }) = _GoogleAuthStatusImpl;

  factory GoogleAuthStatus.fromJson(Map<String, dynamic> jsonSerialization) {
    return GoogleAuthStatus(
      isAuthenticated: jsonSerialization['isAuthenticated'] as bool,
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
      tokenExpiresAt: jsonSerialization['tokenExpiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['tokenExpiresAt']),
    );
  }

  bool isAuthenticated;

  bool gmailEnabled;

  bool calendarEnabled;

  DateTime? lastGmailSync;

  DateTime? lastCalendarSync;

  DateTime? tokenExpiresAt;

  /// Returns a shallow copy of this [GoogleAuthStatus]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  GoogleAuthStatus copyWith({
    bool? isAuthenticated,
    bool? gmailEnabled,
    bool? calendarEnabled,
    DateTime? lastGmailSync,
    DateTime? lastCalendarSync,
    DateTime? tokenExpiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'isAuthenticated': isAuthenticated,
      'gmailEnabled': gmailEnabled,
      'calendarEnabled': calendarEnabled,
      if (lastGmailSync != null) 'lastGmailSync': lastGmailSync?.toJson(),
      if (lastCalendarSync != null)
        'lastCalendarSync': lastCalendarSync?.toJson(),
      if (tokenExpiresAt != null) 'tokenExpiresAt': tokenExpiresAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GoogleAuthStatusImpl extends GoogleAuthStatus {
  _GoogleAuthStatusImpl({
    required bool isAuthenticated,
    required bool gmailEnabled,
    required bool calendarEnabled,
    DateTime? lastGmailSync,
    DateTime? lastCalendarSync,
    DateTime? tokenExpiresAt,
  }) : super._(
          isAuthenticated: isAuthenticated,
          gmailEnabled: gmailEnabled,
          calendarEnabled: calendarEnabled,
          lastGmailSync: lastGmailSync,
          lastCalendarSync: lastCalendarSync,
          tokenExpiresAt: tokenExpiresAt,
        );

  /// Returns a shallow copy of this [GoogleAuthStatus]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  GoogleAuthStatus copyWith({
    bool? isAuthenticated,
    bool? gmailEnabled,
    bool? calendarEnabled,
    Object? lastGmailSync = _Undefined,
    Object? lastCalendarSync = _Undefined,
    Object? tokenExpiresAt = _Undefined,
  }) {
    return GoogleAuthStatus(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      gmailEnabled: gmailEnabled ?? this.gmailEnabled,
      calendarEnabled: calendarEnabled ?? this.calendarEnabled,
      lastGmailSync:
          lastGmailSync is DateTime? ? lastGmailSync : this.lastGmailSync,
      lastCalendarSync: lastCalendarSync is DateTime?
          ? lastCalendarSync
          : this.lastCalendarSync,
      tokenExpiresAt:
          tokenExpiresAt is DateTime? ? tokenExpiresAt : this.tokenExpiresAt,
    );
  }
}

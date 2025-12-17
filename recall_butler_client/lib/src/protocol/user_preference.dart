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

/// UserPreference - user settings and preferences
abstract class UserPreference implements _i1.SerializableModel {
  UserPreference._({
    this.id,
    required this.userId,
    required this.timezone,
    this.notificationTime,
    required this.overlayEnabled,
    required this.weeklyDigestEnabled,
    required this.proactiveRemindersEnabled,
    required this.theme,
  });

  factory UserPreference({
    int? id,
    required int userId,
    required String timezone,
    String? notificationTime,
    required bool overlayEnabled,
    required bool weeklyDigestEnabled,
    required bool proactiveRemindersEnabled,
    required String theme,
  }) = _UserPreferenceImpl;

  factory UserPreference.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserPreference(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      timezone: jsonSerialization['timezone'] as String,
      notificationTime: jsonSerialization['notificationTime'] as String?,
      overlayEnabled: jsonSerialization['overlayEnabled'] as bool,
      weeklyDigestEnabled: jsonSerialization['weeklyDigestEnabled'] as bool,
      proactiveRemindersEnabled:
          jsonSerialization['proactiveRemindersEnabled'] as bool,
      theme: jsonSerialization['theme'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Foreign key to user
  int userId;

  /// User's timezone
  String timezone;

  /// Preferred notification time (HH:mm format)
  String? notificationTime;

  /// Whether floating overlay is enabled
  bool overlayEnabled;

  /// Whether weekly digest is enabled
  bool weeklyDigestEnabled;

  /// Whether proactive reminders are enabled
  bool proactiveRemindersEnabled;

  /// Theme preference: dark, light, system
  String theme;

  /// Returns a shallow copy of this [UserPreference]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserPreference copyWith({
    int? id,
    int? userId,
    String? timezone,
    String? notificationTime,
    bool? overlayEnabled,
    bool? weeklyDigestEnabled,
    bool? proactiveRemindersEnabled,
    String? theme,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'timezone': timezone,
      if (notificationTime != null) 'notificationTime': notificationTime,
      'overlayEnabled': overlayEnabled,
      'weeklyDigestEnabled': weeklyDigestEnabled,
      'proactiveRemindersEnabled': proactiveRemindersEnabled,
      'theme': theme,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserPreferenceImpl extends UserPreference {
  _UserPreferenceImpl({
    int? id,
    required int userId,
    required String timezone,
    String? notificationTime,
    required bool overlayEnabled,
    required bool weeklyDigestEnabled,
    required bool proactiveRemindersEnabled,
    required String theme,
  }) : super._(
          id: id,
          userId: userId,
          timezone: timezone,
          notificationTime: notificationTime,
          overlayEnabled: overlayEnabled,
          weeklyDigestEnabled: weeklyDigestEnabled,
          proactiveRemindersEnabled: proactiveRemindersEnabled,
          theme: theme,
        );

  /// Returns a shallow copy of this [UserPreference]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserPreference copyWith({
    Object? id = _Undefined,
    int? userId,
    String? timezone,
    Object? notificationTime = _Undefined,
    bool? overlayEnabled,
    bool? weeklyDigestEnabled,
    bool? proactiveRemindersEnabled,
    String? theme,
  }) {
    return UserPreference(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      timezone: timezone ?? this.timezone,
      notificationTime: notificationTime is String?
          ? notificationTime
          : this.notificationTime,
      overlayEnabled: overlayEnabled ?? this.overlayEnabled,
      weeklyDigestEnabled: weeklyDigestEnabled ?? this.weeklyDigestEnabled,
      proactiveRemindersEnabled:
          proactiveRemindersEnabled ?? this.proactiveRemindersEnabled,
      theme: theme ?? this.theme,
    );
  }
}

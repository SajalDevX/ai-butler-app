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

/// Device Token Storage for Push Notifications
/// Stores FCM tokens for sending push notifications to user devices
abstract class DeviceToken implements _i1.SerializableModel {
  DeviceToken._({
    this.id,
    required this.userId,
    required this.fcmToken,
    required this.deviceType,
    this.deviceName,
    required this.isActive,
    this.lastUsedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeviceToken({
    int? id,
    required int userId,
    required String fcmToken,
    required String deviceType,
    String? deviceName,
    required bool isActive,
    DateTime? lastUsedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DeviceTokenImpl;

  factory DeviceToken.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceToken(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      fcmToken: jsonSerialization['fcmToken'] as String,
      deviceType: jsonSerialization['deviceType'] as String,
      deviceName: jsonSerialization['deviceName'] as String?,
      isActive: jsonSerialization['isActive'] as bool,
      lastUsedAt: jsonSerialization['lastUsedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['lastUsedAt']),
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

  String fcmToken;

  String deviceType;

  String? deviceName;

  bool isActive;

  DateTime? lastUsedAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [DeviceToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DeviceToken copyWith({
    int? id,
    int? userId,
    String? fcmToken,
    String? deviceType,
    String? deviceName,
    bool? isActive,
    DateTime? lastUsedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'fcmToken': fcmToken,
      'deviceType': deviceType,
      if (deviceName != null) 'deviceName': deviceName,
      'isActive': isActive,
      if (lastUsedAt != null) 'lastUsedAt': lastUsedAt?.toJson(),
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

class _DeviceTokenImpl extends DeviceToken {
  _DeviceTokenImpl({
    int? id,
    required int userId,
    required String fcmToken,
    required String deviceType,
    String? deviceName,
    required bool isActive,
    DateTime? lastUsedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
          id: id,
          userId: userId,
          fcmToken: fcmToken,
          deviceType: deviceType,
          deviceName: deviceName,
          isActive: isActive,
          lastUsedAt: lastUsedAt,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Returns a shallow copy of this [DeviceToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DeviceToken copyWith({
    Object? id = _Undefined,
    int? userId,
    String? fcmToken,
    String? deviceType,
    Object? deviceName = _Undefined,
    bool? isActive,
    Object? lastUsedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DeviceToken(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      fcmToken: fcmToken ?? this.fcmToken,
      deviceType: deviceType ?? this.deviceType,
      deviceName: deviceName is String? ? deviceName : this.deviceName,
      isActive: isActive ?? this.isActive,
      lastUsedAt: lastUsedAt is DateTime? ? lastUsedAt : this.lastUsedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

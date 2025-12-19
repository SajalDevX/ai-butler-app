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

/// Device Token Storage for Push Notifications
/// Stores FCM tokens for sending push notifications to user devices
abstract class DeviceToken
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = DeviceTokenTable();

  static const db = DeviceTokenRepository._();

  @override
  int? id;

  int userId;

  String fcmToken;

  String deviceType;

  String? deviceName;

  bool isActive;

  DateTime? lastUsedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static DeviceTokenInclude include() {
    return DeviceTokenInclude._();
  }

  static DeviceTokenIncludeList includeList({
    _i1.WhereExpressionBuilder<DeviceTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeviceTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DeviceTokenTable>? orderByList,
    DeviceTokenInclude? include,
  }) {
    return DeviceTokenIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeviceToken.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DeviceToken.t),
      include: include,
    );
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

class DeviceTokenTable extends _i1.Table<int?> {
  DeviceTokenTable({super.tableRelation}) : super(tableName: 'device_tokens') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    fcmToken = _i1.ColumnString(
      'fcmToken',
      this,
    );
    deviceType = _i1.ColumnString(
      'deviceType',
      this,
    );
    deviceName = _i1.ColumnString(
      'deviceName',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
    );
    lastUsedAt = _i1.ColumnDateTime(
      'lastUsedAt',
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

  late final _i1.ColumnString fcmToken;

  late final _i1.ColumnString deviceType;

  late final _i1.ColumnString deviceName;

  late final _i1.ColumnBool isActive;

  late final _i1.ColumnDateTime lastUsedAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        fcmToken,
        deviceType,
        deviceName,
        isActive,
        lastUsedAt,
        createdAt,
        updatedAt,
      ];
}

class DeviceTokenInclude extends _i1.IncludeObject {
  DeviceTokenInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => DeviceToken.t;
}

class DeviceTokenIncludeList extends _i1.IncludeList {
  DeviceTokenIncludeList._({
    _i1.WhereExpressionBuilder<DeviceTokenTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DeviceToken.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => DeviceToken.t;
}

class DeviceTokenRepository {
  const DeviceTokenRepository._();

  /// Returns a list of [DeviceToken]s matching the given query parameters.
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
  Future<List<DeviceToken>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DeviceTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeviceTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DeviceTokenTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<DeviceToken>(
      where: where?.call(DeviceToken.t),
      orderBy: orderBy?.call(DeviceToken.t),
      orderByList: orderByList?.call(DeviceToken.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [DeviceToken] matching the given query parameters.
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
  Future<DeviceToken?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DeviceTokenTable>? where,
    int? offset,
    _i1.OrderByBuilder<DeviceTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DeviceTokenTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<DeviceToken>(
      where: where?.call(DeviceToken.t),
      orderBy: orderBy?.call(DeviceToken.t),
      orderByList: orderByList?.call(DeviceToken.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [DeviceToken] by its [id] or null if no such row exists.
  Future<DeviceToken?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<DeviceToken>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [DeviceToken]s in the list and returns the inserted rows.
  ///
  /// The returned [DeviceToken]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<DeviceToken>> insert(
    _i1.Session session,
    List<DeviceToken> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<DeviceToken>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [DeviceToken] and returns the inserted row.
  ///
  /// The returned [DeviceToken] will have its `id` field set.
  Future<DeviceToken> insertRow(
    _i1.Session session,
    DeviceToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DeviceToken>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DeviceToken]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DeviceToken>> update(
    _i1.Session session,
    List<DeviceToken> rows, {
    _i1.ColumnSelections<DeviceTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DeviceToken>(
      rows,
      columns: columns?.call(DeviceToken.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeviceToken]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DeviceToken> updateRow(
    _i1.Session session,
    DeviceToken row, {
    _i1.ColumnSelections<DeviceTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DeviceToken>(
      row,
      columns: columns?.call(DeviceToken.t),
      transaction: transaction,
    );
  }

  /// Deletes all [DeviceToken]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DeviceToken>> delete(
    _i1.Session session,
    List<DeviceToken> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DeviceToken>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [DeviceToken].
  Future<DeviceToken> deleteRow(
    _i1.Session session,
    DeviceToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DeviceToken>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<DeviceToken>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<DeviceTokenTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DeviceToken>(
      where: where(DeviceToken.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DeviceTokenTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DeviceToken>(
      where: where?.call(DeviceToken.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

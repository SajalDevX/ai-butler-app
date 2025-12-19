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

/// Notification Log for tracking sent push notifications
/// Prevents duplicate notifications and provides history
abstract class NotificationLog
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  NotificationLog._({
    this.id,
    required this.userId,
    required this.sourceType,
    required this.sourceId,
    required this.title,
    required this.body,
    required this.priority,
    required this.sentAt,
    this.deliveredAt,
    this.readAt,
    this.fcmMessageId,
    this.error,
  });

  factory NotificationLog({
    int? id,
    required int userId,
    required String sourceType,
    required String sourceId,
    required String title,
    required String body,
    required int priority,
    required DateTime sentAt,
    DateTime? deliveredAt,
    DateTime? readAt,
    String? fcmMessageId,
    String? error,
  }) = _NotificationLogImpl;

  factory NotificationLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return NotificationLog(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      sourceType: jsonSerialization['sourceType'] as String,
      sourceId: jsonSerialization['sourceId'] as String,
      title: jsonSerialization['title'] as String,
      body: jsonSerialization['body'] as String,
      priority: jsonSerialization['priority'] as int,
      sentAt: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['sentAt']),
      deliveredAt: jsonSerialization['deliveredAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['deliveredAt']),
      readAt: jsonSerialization['readAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['readAt']),
      fcmMessageId: jsonSerialization['fcmMessageId'] as String?,
      error: jsonSerialization['error'] as String?,
    );
  }

  static final t = NotificationLogTable();

  static const db = NotificationLogRepository._();

  @override
  int? id;

  int userId;

  String sourceType;

  String sourceId;

  String title;

  String body;

  int priority;

  DateTime sentAt;

  DateTime? deliveredAt;

  DateTime? readAt;

  String? fcmMessageId;

  String? error;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [NotificationLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NotificationLog copyWith({
    int? id,
    int? userId,
    String? sourceType,
    String? sourceId,
    String? title,
    String? body,
    int? priority,
    DateTime? sentAt,
    DateTime? deliveredAt,
    DateTime? readAt,
    String? fcmMessageId,
    String? error,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'sourceType': sourceType,
      'sourceId': sourceId,
      'title': title,
      'body': body,
      'priority': priority,
      'sentAt': sentAt.toJson(),
      if (deliveredAt != null) 'deliveredAt': deliveredAt?.toJson(),
      if (readAt != null) 'readAt': readAt?.toJson(),
      if (fcmMessageId != null) 'fcmMessageId': fcmMessageId,
      if (error != null) 'error': error,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'sourceType': sourceType,
      'sourceId': sourceId,
      'title': title,
      'body': body,
      'priority': priority,
      'sentAt': sentAt.toJson(),
      if (deliveredAt != null) 'deliveredAt': deliveredAt?.toJson(),
      if (readAt != null) 'readAt': readAt?.toJson(),
      if (fcmMessageId != null) 'fcmMessageId': fcmMessageId,
      if (error != null) 'error': error,
    };
  }

  static NotificationLogInclude include() {
    return NotificationLogInclude._();
  }

  static NotificationLogIncludeList includeList({
    _i1.WhereExpressionBuilder<NotificationLogTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NotificationLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NotificationLogTable>? orderByList,
    NotificationLogInclude? include,
  }) {
    return NotificationLogIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotificationLog.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(NotificationLog.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationLogImpl extends NotificationLog {
  _NotificationLogImpl({
    int? id,
    required int userId,
    required String sourceType,
    required String sourceId,
    required String title,
    required String body,
    required int priority,
    required DateTime sentAt,
    DateTime? deliveredAt,
    DateTime? readAt,
    String? fcmMessageId,
    String? error,
  }) : super._(
          id: id,
          userId: userId,
          sourceType: sourceType,
          sourceId: sourceId,
          title: title,
          body: body,
          priority: priority,
          sentAt: sentAt,
          deliveredAt: deliveredAt,
          readAt: readAt,
          fcmMessageId: fcmMessageId,
          error: error,
        );

  /// Returns a shallow copy of this [NotificationLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NotificationLog copyWith({
    Object? id = _Undefined,
    int? userId,
    String? sourceType,
    String? sourceId,
    String? title,
    String? body,
    int? priority,
    DateTime? sentAt,
    Object? deliveredAt = _Undefined,
    Object? readAt = _Undefined,
    Object? fcmMessageId = _Undefined,
    Object? error = _Undefined,
  }) {
    return NotificationLog(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      sourceType: sourceType ?? this.sourceType,
      sourceId: sourceId ?? this.sourceId,
      title: title ?? this.title,
      body: body ?? this.body,
      priority: priority ?? this.priority,
      sentAt: sentAt ?? this.sentAt,
      deliveredAt: deliveredAt is DateTime? ? deliveredAt : this.deliveredAt,
      readAt: readAt is DateTime? ? readAt : this.readAt,
      fcmMessageId: fcmMessageId is String? ? fcmMessageId : this.fcmMessageId,
      error: error is String? ? error : this.error,
    );
  }
}

class NotificationLogTable extends _i1.Table<int?> {
  NotificationLogTable({super.tableRelation})
      : super(tableName: 'notification_logs') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    sourceType = _i1.ColumnString(
      'sourceType',
      this,
    );
    sourceId = _i1.ColumnString(
      'sourceId',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    body = _i1.ColumnString(
      'body',
      this,
    );
    priority = _i1.ColumnInt(
      'priority',
      this,
    );
    sentAt = _i1.ColumnDateTime(
      'sentAt',
      this,
    );
    deliveredAt = _i1.ColumnDateTime(
      'deliveredAt',
      this,
    );
    readAt = _i1.ColumnDateTime(
      'readAt',
      this,
    );
    fcmMessageId = _i1.ColumnString(
      'fcmMessageId',
      this,
    );
    error = _i1.ColumnString(
      'error',
      this,
    );
  }

  late final _i1.ColumnInt userId;

  late final _i1.ColumnString sourceType;

  late final _i1.ColumnString sourceId;

  late final _i1.ColumnString title;

  late final _i1.ColumnString body;

  late final _i1.ColumnInt priority;

  late final _i1.ColumnDateTime sentAt;

  late final _i1.ColumnDateTime deliveredAt;

  late final _i1.ColumnDateTime readAt;

  late final _i1.ColumnString fcmMessageId;

  late final _i1.ColumnString error;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        sourceType,
        sourceId,
        title,
        body,
        priority,
        sentAt,
        deliveredAt,
        readAt,
        fcmMessageId,
        error,
      ];
}

class NotificationLogInclude extends _i1.IncludeObject {
  NotificationLogInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => NotificationLog.t;
}

class NotificationLogIncludeList extends _i1.IncludeList {
  NotificationLogIncludeList._({
    _i1.WhereExpressionBuilder<NotificationLogTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NotificationLog.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => NotificationLog.t;
}

class NotificationLogRepository {
  const NotificationLogRepository._();

  /// Returns a list of [NotificationLog]s matching the given query parameters.
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
  Future<List<NotificationLog>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<NotificationLogTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NotificationLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NotificationLogTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<NotificationLog>(
      where: where?.call(NotificationLog.t),
      orderBy: orderBy?.call(NotificationLog.t),
      orderByList: orderByList?.call(NotificationLog.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [NotificationLog] matching the given query parameters.
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
  Future<NotificationLog?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<NotificationLogTable>? where,
    int? offset,
    _i1.OrderByBuilder<NotificationLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NotificationLogTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<NotificationLog>(
      where: where?.call(NotificationLog.t),
      orderBy: orderBy?.call(NotificationLog.t),
      orderByList: orderByList?.call(NotificationLog.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [NotificationLog] by its [id] or null if no such row exists.
  Future<NotificationLog?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<NotificationLog>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [NotificationLog]s in the list and returns the inserted rows.
  ///
  /// The returned [NotificationLog]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<NotificationLog>> insert(
    _i1.Session session,
    List<NotificationLog> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<NotificationLog>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [NotificationLog] and returns the inserted row.
  ///
  /// The returned [NotificationLog] will have its `id` field set.
  Future<NotificationLog> insertRow(
    _i1.Session session,
    NotificationLog row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<NotificationLog>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [NotificationLog]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<NotificationLog>> update(
    _i1.Session session,
    List<NotificationLog> rows, {
    _i1.ColumnSelections<NotificationLogTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<NotificationLog>(
      rows,
      columns: columns?.call(NotificationLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotificationLog]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NotificationLog> updateRow(
    _i1.Session session,
    NotificationLog row, {
    _i1.ColumnSelections<NotificationLogTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<NotificationLog>(
      row,
      columns: columns?.call(NotificationLog.t),
      transaction: transaction,
    );
  }

  /// Deletes all [NotificationLog]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<NotificationLog>> delete(
    _i1.Session session,
    List<NotificationLog> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<NotificationLog>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [NotificationLog].
  Future<NotificationLog> deleteRow(
    _i1.Session session,
    NotificationLog row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NotificationLog>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<NotificationLog>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<NotificationLogTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<NotificationLog>(
      where: where(NotificationLog.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<NotificationLogTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<NotificationLog>(
      where: where?.call(NotificationLog.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

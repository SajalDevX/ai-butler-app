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

/// Reminder - proactive reminder notifications for captures
abstract class Reminder
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Reminder._({
    this.id,
    required this.userId,
    required this.captureId,
    this.message,
    required this.triggerAt,
    required this.isSent,
    required this.isDismissed,
    required this.createdAt,
  });

  factory Reminder({
    int? id,
    required int userId,
    required int captureId,
    String? message,
    required DateTime triggerAt,
    required bool isSent,
    required bool isDismissed,
    required DateTime createdAt,
  }) = _ReminderImpl;

  factory Reminder.fromJson(Map<String, dynamic> jsonSerialization) {
    return Reminder(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      captureId: jsonSerialization['captureId'] as int,
      message: jsonSerialization['message'] as String?,
      triggerAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['triggerAt']),
      isSent: jsonSerialization['isSent'] as bool,
      isDismissed: jsonSerialization['isDismissed'] as bool,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = ReminderTable();

  static const db = ReminderRepository._();

  @override
  int? id;

  /// Foreign key to user
  int userId;

  /// Foreign key to capture
  int captureId;

  /// Reminder message
  String? message;

  /// When to trigger the reminder
  DateTime triggerAt;

  /// Whether the reminder has been sent
  bool isSent;

  /// Whether the user has dismissed the reminder
  bool isDismissed;

  /// Creation timestamp
  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Reminder]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Reminder copyWith({
    int? id,
    int? userId,
    int? captureId,
    String? message,
    DateTime? triggerAt,
    bool? isSent,
    bool? isDismissed,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'captureId': captureId,
      if (message != null) 'message': message,
      'triggerAt': triggerAt.toJson(),
      'isSent': isSent,
      'isDismissed': isDismissed,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'captureId': captureId,
      if (message != null) 'message': message,
      'triggerAt': triggerAt.toJson(),
      'isSent': isSent,
      'isDismissed': isDismissed,
      'createdAt': createdAt.toJson(),
    };
  }

  static ReminderInclude include() {
    return ReminderInclude._();
  }

  static ReminderIncludeList includeList({
    _i1.WhereExpressionBuilder<ReminderTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReminderTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReminderTable>? orderByList,
    ReminderInclude? include,
  }) {
    return ReminderIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Reminder.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Reminder.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReminderImpl extends Reminder {
  _ReminderImpl({
    int? id,
    required int userId,
    required int captureId,
    String? message,
    required DateTime triggerAt,
    required bool isSent,
    required bool isDismissed,
    required DateTime createdAt,
  }) : super._(
          id: id,
          userId: userId,
          captureId: captureId,
          message: message,
          triggerAt: triggerAt,
          isSent: isSent,
          isDismissed: isDismissed,
          createdAt: createdAt,
        );

  /// Returns a shallow copy of this [Reminder]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Reminder copyWith({
    Object? id = _Undefined,
    int? userId,
    int? captureId,
    Object? message = _Undefined,
    DateTime? triggerAt,
    bool? isSent,
    bool? isDismissed,
    DateTime? createdAt,
  }) {
    return Reminder(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      captureId: captureId ?? this.captureId,
      message: message is String? ? message : this.message,
      triggerAt: triggerAt ?? this.triggerAt,
      isSent: isSent ?? this.isSent,
      isDismissed: isDismissed ?? this.isDismissed,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ReminderTable extends _i1.Table<int?> {
  ReminderTable({super.tableRelation}) : super(tableName: 'reminder') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    captureId = _i1.ColumnInt(
      'captureId',
      this,
    );
    message = _i1.ColumnString(
      'message',
      this,
    );
    triggerAt = _i1.ColumnDateTime(
      'triggerAt',
      this,
    );
    isSent = _i1.ColumnBool(
      'isSent',
      this,
    );
    isDismissed = _i1.ColumnBool(
      'isDismissed',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  /// Foreign key to user
  late final _i1.ColumnInt userId;

  /// Foreign key to capture
  late final _i1.ColumnInt captureId;

  /// Reminder message
  late final _i1.ColumnString message;

  /// When to trigger the reminder
  late final _i1.ColumnDateTime triggerAt;

  /// Whether the reminder has been sent
  late final _i1.ColumnBool isSent;

  /// Whether the user has dismissed the reminder
  late final _i1.ColumnBool isDismissed;

  /// Creation timestamp
  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        captureId,
        message,
        triggerAt,
        isSent,
        isDismissed,
        createdAt,
      ];
}

class ReminderInclude extends _i1.IncludeObject {
  ReminderInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Reminder.t;
}

class ReminderIncludeList extends _i1.IncludeList {
  ReminderIncludeList._({
    _i1.WhereExpressionBuilder<ReminderTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Reminder.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Reminder.t;
}

class ReminderRepository {
  const ReminderRepository._();

  /// Returns a list of [Reminder]s matching the given query parameters.
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
  Future<List<Reminder>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReminderTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReminderTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReminderTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Reminder>(
      where: where?.call(Reminder.t),
      orderBy: orderBy?.call(Reminder.t),
      orderByList: orderByList?.call(Reminder.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Reminder] matching the given query parameters.
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
  Future<Reminder?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReminderTable>? where,
    int? offset,
    _i1.OrderByBuilder<ReminderTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReminderTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Reminder>(
      where: where?.call(Reminder.t),
      orderBy: orderBy?.call(Reminder.t),
      orderByList: orderByList?.call(Reminder.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Reminder] by its [id] or null if no such row exists.
  Future<Reminder?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Reminder>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Reminder]s in the list and returns the inserted rows.
  ///
  /// The returned [Reminder]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Reminder>> insert(
    _i1.Session session,
    List<Reminder> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Reminder>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Reminder] and returns the inserted row.
  ///
  /// The returned [Reminder] will have its `id` field set.
  Future<Reminder> insertRow(
    _i1.Session session,
    Reminder row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Reminder>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Reminder]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Reminder>> update(
    _i1.Session session,
    List<Reminder> rows, {
    _i1.ColumnSelections<ReminderTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Reminder>(
      rows,
      columns: columns?.call(Reminder.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Reminder]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Reminder> updateRow(
    _i1.Session session,
    Reminder row, {
    _i1.ColumnSelections<ReminderTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Reminder>(
      row,
      columns: columns?.call(Reminder.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Reminder]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Reminder>> delete(
    _i1.Session session,
    List<Reminder> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Reminder>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Reminder].
  Future<Reminder> deleteRow(
    _i1.Session session,
    Reminder row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Reminder>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Reminder>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ReminderTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Reminder>(
      where: where(Reminder.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReminderTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Reminder>(
      where: where?.call(Reminder.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

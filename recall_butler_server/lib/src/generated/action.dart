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

/// Action - AI-extracted tasks, reminders, and events from captures
abstract class Action implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Action._({
    this.id,
    required this.userId,
    this.captureId,
    required this.type,
    required this.title,
    this.notes,
    this.dueAt,
    required this.isCompleted,
    required this.priority,
    required this.createdAt,
    this.completedAt,
  });

  factory Action({
    int? id,
    required int userId,
    int? captureId,
    required String type,
    required String title,
    String? notes,
    DateTime? dueAt,
    required bool isCompleted,
    required String priority,
    required DateTime createdAt,
    DateTime? completedAt,
  }) = _ActionImpl;

  factory Action.fromJson(Map<String, dynamic> jsonSerialization) {
    return Action(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      captureId: jsonSerialization['captureId'] as int?,
      type: jsonSerialization['type'] as String,
      title: jsonSerialization['title'] as String,
      notes: jsonSerialization['notes'] as String?,
      dueAt: jsonSerialization['dueAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['dueAt']),
      isCompleted: jsonSerialization['isCompleted'] as bool,
      priority: jsonSerialization['priority'] as String,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt']),
    );
  }

  static final t = ActionTable();

  static const db = ActionRepository._();

  @override
  int? id;

  /// Foreign key to user
  int userId;

  /// Foreign key to source capture (optional - actions can be standalone)
  int? captureId;

  /// Type: task, reminder, event, shopping
  String type;

  /// Action title/description
  String title;

  /// Detailed notes (optional)
  String? notes;

  /// Due date/time (optional)
  DateTime? dueAt;

  /// Whether the action is completed
  bool isCompleted;

  /// Priority: low, medium, high
  String priority;

  /// Creation timestamp
  DateTime createdAt;

  /// Completion timestamp (optional)
  DateTime? completedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Action]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Action copyWith({
    int? id,
    int? userId,
    int? captureId,
    String? type,
    String? title,
    String? notes,
    DateTime? dueAt,
    bool? isCompleted,
    String? priority,
    DateTime? createdAt,
    DateTime? completedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      if (captureId != null) 'captureId': captureId,
      'type': type,
      'title': title,
      if (notes != null) 'notes': notes,
      if (dueAt != null) 'dueAt': dueAt?.toJson(),
      'isCompleted': isCompleted,
      'priority': priority,
      'createdAt': createdAt.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      if (captureId != null) 'captureId': captureId,
      'type': type,
      'title': title,
      if (notes != null) 'notes': notes,
      if (dueAt != null) 'dueAt': dueAt?.toJson(),
      'isCompleted': isCompleted,
      'priority': priority,
      'createdAt': createdAt.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
    };
  }

  static ActionInclude include() {
    return ActionInclude._();
  }

  static ActionIncludeList includeList({
    _i1.WhereExpressionBuilder<ActionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ActionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActionTable>? orderByList,
    ActionInclude? include,
  }) {
    return ActionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Action.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Action.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ActionImpl extends Action {
  _ActionImpl({
    int? id,
    required int userId,
    int? captureId,
    required String type,
    required String title,
    String? notes,
    DateTime? dueAt,
    required bool isCompleted,
    required String priority,
    required DateTime createdAt,
    DateTime? completedAt,
  }) : super._(
          id: id,
          userId: userId,
          captureId: captureId,
          type: type,
          title: title,
          notes: notes,
          dueAt: dueAt,
          isCompleted: isCompleted,
          priority: priority,
          createdAt: createdAt,
          completedAt: completedAt,
        );

  /// Returns a shallow copy of this [Action]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Action copyWith({
    Object? id = _Undefined,
    int? userId,
    Object? captureId = _Undefined,
    String? type,
    String? title,
    Object? notes = _Undefined,
    Object? dueAt = _Undefined,
    bool? isCompleted,
    String? priority,
    DateTime? createdAt,
    Object? completedAt = _Undefined,
  }) {
    return Action(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      captureId: captureId is int? ? captureId : this.captureId,
      type: type ?? this.type,
      title: title ?? this.title,
      notes: notes is String? ? notes : this.notes,
      dueAt: dueAt is DateTime? ? dueAt : this.dueAt,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
    );
  }
}

class ActionTable extends _i1.Table<int?> {
  ActionTable({super.tableRelation}) : super(tableName: 'action') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    captureId = _i1.ColumnInt(
      'captureId',
      this,
    );
    type = _i1.ColumnString(
      'type',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    notes = _i1.ColumnString(
      'notes',
      this,
    );
    dueAt = _i1.ColumnDateTime(
      'dueAt',
      this,
    );
    isCompleted = _i1.ColumnBool(
      'isCompleted',
      this,
    );
    priority = _i1.ColumnString(
      'priority',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    completedAt = _i1.ColumnDateTime(
      'completedAt',
      this,
    );
  }

  /// Foreign key to user
  late final _i1.ColumnInt userId;

  /// Foreign key to source capture (optional - actions can be standalone)
  late final _i1.ColumnInt captureId;

  /// Type: task, reminder, event, shopping
  late final _i1.ColumnString type;

  /// Action title/description
  late final _i1.ColumnString title;

  /// Detailed notes (optional)
  late final _i1.ColumnString notes;

  /// Due date/time (optional)
  late final _i1.ColumnDateTime dueAt;

  /// Whether the action is completed
  late final _i1.ColumnBool isCompleted;

  /// Priority: low, medium, high
  late final _i1.ColumnString priority;

  /// Creation timestamp
  late final _i1.ColumnDateTime createdAt;

  /// Completion timestamp (optional)
  late final _i1.ColumnDateTime completedAt;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        captureId,
        type,
        title,
        notes,
        dueAt,
        isCompleted,
        priority,
        createdAt,
        completedAt,
      ];
}

class ActionInclude extends _i1.IncludeObject {
  ActionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Action.t;
}

class ActionIncludeList extends _i1.IncludeList {
  ActionIncludeList._({
    _i1.WhereExpressionBuilder<ActionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Action.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Action.t;
}

class ActionRepository {
  const ActionRepository._();

  /// Returns a list of [Action]s matching the given query parameters.
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
  Future<List<Action>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ActionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Action>(
      where: where?.call(Action.t),
      orderBy: orderBy?.call(Action.t),
      orderByList: orderByList?.call(Action.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Action] matching the given query parameters.
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
  Future<Action?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActionTable>? where,
    int? offset,
    _i1.OrderByBuilder<ActionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Action>(
      where: where?.call(Action.t),
      orderBy: orderBy?.call(Action.t),
      orderByList: orderByList?.call(Action.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Action] by its [id] or null if no such row exists.
  Future<Action?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Action>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Action]s in the list and returns the inserted rows.
  ///
  /// The returned [Action]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Action>> insert(
    _i1.Session session,
    List<Action> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Action>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Action] and returns the inserted row.
  ///
  /// The returned [Action] will have its `id` field set.
  Future<Action> insertRow(
    _i1.Session session,
    Action row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Action>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Action]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Action>> update(
    _i1.Session session,
    List<Action> rows, {
    _i1.ColumnSelections<ActionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Action>(
      rows,
      columns: columns?.call(Action.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Action]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Action> updateRow(
    _i1.Session session,
    Action row, {
    _i1.ColumnSelections<ActionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Action>(
      row,
      columns: columns?.call(Action.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Action]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Action>> delete(
    _i1.Session session,
    List<Action> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Action>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Action].
  Future<Action> deleteRow(
    _i1.Session session,
    Action row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Action>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Action>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ActionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Action>(
      where: where(Action.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Action>(
      where: where?.call(Action.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

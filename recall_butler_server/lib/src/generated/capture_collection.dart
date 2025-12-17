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

/// CaptureCollection - join table for many-to-many relationship
abstract class CaptureCollection
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CaptureCollection._({
    this.id,
    required this.captureId,
    required this.collectionId,
    required this.addedAt,
  });

  factory CaptureCollection({
    int? id,
    required int captureId,
    required int collectionId,
    required DateTime addedAt,
  }) = _CaptureCollectionImpl;

  factory CaptureCollection.fromJson(Map<String, dynamic> jsonSerialization) {
    return CaptureCollection(
      id: jsonSerialization['id'] as int?,
      captureId: jsonSerialization['captureId'] as int,
      collectionId: jsonSerialization['collectionId'] as int,
      addedAt: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['addedAt']),
    );
  }

  static final t = CaptureCollectionTable();

  static const db = CaptureCollectionRepository._();

  @override
  int? id;

  /// Foreign key to capture
  int captureId;

  /// Foreign key to collection
  int collectionId;

  /// When the capture was added to the collection
  DateTime addedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CaptureCollection]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CaptureCollection copyWith({
    int? id,
    int? captureId,
    int? collectionId,
    DateTime? addedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'captureId': captureId,
      'collectionId': collectionId,
      'addedAt': addedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'captureId': captureId,
      'collectionId': collectionId,
      'addedAt': addedAt.toJson(),
    };
  }

  static CaptureCollectionInclude include() {
    return CaptureCollectionInclude._();
  }

  static CaptureCollectionIncludeList includeList({
    _i1.WhereExpressionBuilder<CaptureCollectionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CaptureCollectionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CaptureCollectionTable>? orderByList,
    CaptureCollectionInclude? include,
  }) {
    return CaptureCollectionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CaptureCollection.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CaptureCollection.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CaptureCollectionImpl extends CaptureCollection {
  _CaptureCollectionImpl({
    int? id,
    required int captureId,
    required int collectionId,
    required DateTime addedAt,
  }) : super._(
          id: id,
          captureId: captureId,
          collectionId: collectionId,
          addedAt: addedAt,
        );

  /// Returns a shallow copy of this [CaptureCollection]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CaptureCollection copyWith({
    Object? id = _Undefined,
    int? captureId,
    int? collectionId,
    DateTime? addedAt,
  }) {
    return CaptureCollection(
      id: id is int? ? id : this.id,
      captureId: captureId ?? this.captureId,
      collectionId: collectionId ?? this.collectionId,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}

class CaptureCollectionTable extends _i1.Table<int?> {
  CaptureCollectionTable({super.tableRelation})
      : super(tableName: 'capture_collection') {
    captureId = _i1.ColumnInt(
      'captureId',
      this,
    );
    collectionId = _i1.ColumnInt(
      'collectionId',
      this,
    );
    addedAt = _i1.ColumnDateTime(
      'addedAt',
      this,
    );
  }

  /// Foreign key to capture
  late final _i1.ColumnInt captureId;

  /// Foreign key to collection
  late final _i1.ColumnInt collectionId;

  /// When the capture was added to the collection
  late final _i1.ColumnDateTime addedAt;

  @override
  List<_i1.Column> get columns => [
        id,
        captureId,
        collectionId,
        addedAt,
      ];
}

class CaptureCollectionInclude extends _i1.IncludeObject {
  CaptureCollectionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CaptureCollection.t;
}

class CaptureCollectionIncludeList extends _i1.IncludeList {
  CaptureCollectionIncludeList._({
    _i1.WhereExpressionBuilder<CaptureCollectionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CaptureCollection.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CaptureCollection.t;
}

class CaptureCollectionRepository {
  const CaptureCollectionRepository._();

  /// Returns a list of [CaptureCollection]s matching the given query parameters.
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
  Future<List<CaptureCollection>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CaptureCollectionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CaptureCollectionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CaptureCollectionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<CaptureCollection>(
      where: where?.call(CaptureCollection.t),
      orderBy: orderBy?.call(CaptureCollection.t),
      orderByList: orderByList?.call(CaptureCollection.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [CaptureCollection] matching the given query parameters.
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
  Future<CaptureCollection?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CaptureCollectionTable>? where,
    int? offset,
    _i1.OrderByBuilder<CaptureCollectionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CaptureCollectionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<CaptureCollection>(
      where: where?.call(CaptureCollection.t),
      orderBy: orderBy?.call(CaptureCollection.t),
      orderByList: orderByList?.call(CaptureCollection.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [CaptureCollection] by its [id] or null if no such row exists.
  Future<CaptureCollection?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<CaptureCollection>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [CaptureCollection]s in the list and returns the inserted rows.
  ///
  /// The returned [CaptureCollection]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<CaptureCollection>> insert(
    _i1.Session session,
    List<CaptureCollection> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<CaptureCollection>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [CaptureCollection] and returns the inserted row.
  ///
  /// The returned [CaptureCollection] will have its `id` field set.
  Future<CaptureCollection> insertRow(
    _i1.Session session,
    CaptureCollection row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CaptureCollection>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CaptureCollection]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CaptureCollection>> update(
    _i1.Session session,
    List<CaptureCollection> rows, {
    _i1.ColumnSelections<CaptureCollectionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CaptureCollection>(
      rows,
      columns: columns?.call(CaptureCollection.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CaptureCollection]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CaptureCollection> updateRow(
    _i1.Session session,
    CaptureCollection row, {
    _i1.ColumnSelections<CaptureCollectionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CaptureCollection>(
      row,
      columns: columns?.call(CaptureCollection.t),
      transaction: transaction,
    );
  }

  /// Deletes all [CaptureCollection]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CaptureCollection>> delete(
    _i1.Session session,
    List<CaptureCollection> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CaptureCollection>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CaptureCollection].
  Future<CaptureCollection> deleteRow(
    _i1.Session session,
    CaptureCollection row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CaptureCollection>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CaptureCollection>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CaptureCollectionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CaptureCollection>(
      where: where(CaptureCollection.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CaptureCollectionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CaptureCollection>(
      where: where?.call(CaptureCollection.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

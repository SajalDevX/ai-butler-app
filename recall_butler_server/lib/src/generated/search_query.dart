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

/// SearchQuery - analytics tracking for user searches
abstract class SearchQuery
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  SearchQuery._({
    this.id,
    required this.userId,
    required this.query,
    required this.resultsCount,
    this.clickedCaptureId,
    required this.searchedAt,
  });

  factory SearchQuery({
    int? id,
    required int userId,
    required String query,
    required int resultsCount,
    int? clickedCaptureId,
    required DateTime searchedAt,
  }) = _SearchQueryImpl;

  factory SearchQuery.fromJson(Map<String, dynamic> jsonSerialization) {
    return SearchQuery(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      query: jsonSerialization['query'] as String,
      resultsCount: jsonSerialization['resultsCount'] as int,
      clickedCaptureId: jsonSerialization['clickedCaptureId'] as int?,
      searchedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['searchedAt']),
    );
  }

  static final t = SearchQueryTable();

  static const db = SearchQueryRepository._();

  @override
  int? id;

  /// Foreign key to user
  int userId;

  /// The search query string
  String query;

  /// Number of results returned
  int resultsCount;

  /// ID of capture that was clicked (if any)
  int? clickedCaptureId;

  /// When the search was performed
  DateTime searchedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [SearchQuery]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SearchQuery copyWith({
    int? id,
    int? userId,
    String? query,
    int? resultsCount,
    int? clickedCaptureId,
    DateTime? searchedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'query': query,
      'resultsCount': resultsCount,
      if (clickedCaptureId != null) 'clickedCaptureId': clickedCaptureId,
      'searchedAt': searchedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'query': query,
      'resultsCount': resultsCount,
      if (clickedCaptureId != null) 'clickedCaptureId': clickedCaptureId,
      'searchedAt': searchedAt.toJson(),
    };
  }

  static SearchQueryInclude include() {
    return SearchQueryInclude._();
  }

  static SearchQueryIncludeList includeList({
    _i1.WhereExpressionBuilder<SearchQueryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SearchQueryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SearchQueryTable>? orderByList,
    SearchQueryInclude? include,
  }) {
    return SearchQueryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SearchQuery.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SearchQuery.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SearchQueryImpl extends SearchQuery {
  _SearchQueryImpl({
    int? id,
    required int userId,
    required String query,
    required int resultsCount,
    int? clickedCaptureId,
    required DateTime searchedAt,
  }) : super._(
          id: id,
          userId: userId,
          query: query,
          resultsCount: resultsCount,
          clickedCaptureId: clickedCaptureId,
          searchedAt: searchedAt,
        );

  /// Returns a shallow copy of this [SearchQuery]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SearchQuery copyWith({
    Object? id = _Undefined,
    int? userId,
    String? query,
    int? resultsCount,
    Object? clickedCaptureId = _Undefined,
    DateTime? searchedAt,
  }) {
    return SearchQuery(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      query: query ?? this.query,
      resultsCount: resultsCount ?? this.resultsCount,
      clickedCaptureId:
          clickedCaptureId is int? ? clickedCaptureId : this.clickedCaptureId,
      searchedAt: searchedAt ?? this.searchedAt,
    );
  }
}

class SearchQueryTable extends _i1.Table<int?> {
  SearchQueryTable({super.tableRelation}) : super(tableName: 'search_query') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    query = _i1.ColumnString(
      'query',
      this,
    );
    resultsCount = _i1.ColumnInt(
      'resultsCount',
      this,
    );
    clickedCaptureId = _i1.ColumnInt(
      'clickedCaptureId',
      this,
    );
    searchedAt = _i1.ColumnDateTime(
      'searchedAt',
      this,
    );
  }

  /// Foreign key to user
  late final _i1.ColumnInt userId;

  /// The search query string
  late final _i1.ColumnString query;

  /// Number of results returned
  late final _i1.ColumnInt resultsCount;

  /// ID of capture that was clicked (if any)
  late final _i1.ColumnInt clickedCaptureId;

  /// When the search was performed
  late final _i1.ColumnDateTime searchedAt;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        query,
        resultsCount,
        clickedCaptureId,
        searchedAt,
      ];
}

class SearchQueryInclude extends _i1.IncludeObject {
  SearchQueryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => SearchQuery.t;
}

class SearchQueryIncludeList extends _i1.IncludeList {
  SearchQueryIncludeList._({
    _i1.WhereExpressionBuilder<SearchQueryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SearchQuery.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => SearchQuery.t;
}

class SearchQueryRepository {
  const SearchQueryRepository._();

  /// Returns a list of [SearchQuery]s matching the given query parameters.
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
  Future<List<SearchQuery>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SearchQueryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SearchQueryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SearchQueryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<SearchQuery>(
      where: where?.call(SearchQuery.t),
      orderBy: orderBy?.call(SearchQuery.t),
      orderByList: orderByList?.call(SearchQuery.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [SearchQuery] matching the given query parameters.
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
  Future<SearchQuery?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SearchQueryTable>? where,
    int? offset,
    _i1.OrderByBuilder<SearchQueryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SearchQueryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<SearchQuery>(
      where: where?.call(SearchQuery.t),
      orderBy: orderBy?.call(SearchQuery.t),
      orderByList: orderByList?.call(SearchQuery.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [SearchQuery] by its [id] or null if no such row exists.
  Future<SearchQuery?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<SearchQuery>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [SearchQuery]s in the list and returns the inserted rows.
  ///
  /// The returned [SearchQuery]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<SearchQuery>> insert(
    _i1.Session session,
    List<SearchQuery> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<SearchQuery>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [SearchQuery] and returns the inserted row.
  ///
  /// The returned [SearchQuery] will have its `id` field set.
  Future<SearchQuery> insertRow(
    _i1.Session session,
    SearchQuery row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SearchQuery>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SearchQuery]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SearchQuery>> update(
    _i1.Session session,
    List<SearchQuery> rows, {
    _i1.ColumnSelections<SearchQueryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SearchQuery>(
      rows,
      columns: columns?.call(SearchQuery.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SearchQuery]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SearchQuery> updateRow(
    _i1.Session session,
    SearchQuery row, {
    _i1.ColumnSelections<SearchQueryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SearchQuery>(
      row,
      columns: columns?.call(SearchQuery.t),
      transaction: transaction,
    );
  }

  /// Deletes all [SearchQuery]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SearchQuery>> delete(
    _i1.Session session,
    List<SearchQuery> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SearchQuery>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SearchQuery].
  Future<SearchQuery> deleteRow(
    _i1.Session session,
    SearchQuery row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SearchQuery>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SearchQuery>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SearchQueryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SearchQuery>(
      where: where(SearchQuery.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SearchQueryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SearchQuery>(
      where: where?.call(SearchQuery.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

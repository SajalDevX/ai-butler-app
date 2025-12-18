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

/// TokenUsageHistory - Tracks token usage for adaptive learning
abstract class TokenUsageHistory
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  TokenUsageHistory._({
    this.id,
    required this.contentType,
    required this.complexityBucket,
    this.complexityScore,
    required this.tokensAllocated,
    required this.tokensUsed,
    required this.wasComplete,
    required this.isQuickAnalysis,
    required this.createdAt,
  });

  factory TokenUsageHistory({
    int? id,
    required String contentType,
    required String complexityBucket,
    double? complexityScore,
    required int tokensAllocated,
    required int tokensUsed,
    required bool wasComplete,
    required bool isQuickAnalysis,
    required DateTime createdAt,
  }) = _TokenUsageHistoryImpl;

  factory TokenUsageHistory.fromJson(Map<String, dynamic> jsonSerialization) {
    return TokenUsageHistory(
      id: jsonSerialization['id'] as int?,
      contentType: jsonSerialization['contentType'] as String,
      complexityBucket: jsonSerialization['complexityBucket'] as String,
      complexityScore:
          (jsonSerialization['complexityScore'] as num?)?.toDouble(),
      tokensAllocated: jsonSerialization['tokensAllocated'] as int,
      tokensUsed: jsonSerialization['tokensUsed'] as int,
      wasComplete: jsonSerialization['wasComplete'] as bool,
      isQuickAnalysis: jsonSerialization['isQuickAnalysis'] as bool,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = TokenUsageHistoryTable();

  static const db = TokenUsageHistoryRepository._();

  @override
  int? id;

  /// Content type detected (document, photo, recipe, etc.)
  String contentType;

  /// Complexity bucket (simple, medium, complex)
  String complexityBucket;

  /// Exact complexity score 0.0-1.0
  double? complexityScore;

  /// Tokens allocated for this request
  int tokensAllocated;

  /// Actual tokens used in response
  int tokensUsed;

  /// Whether the response was complete (not truncated)
  bool wasComplete;

  /// Whether this was quick analysis (sync) or deep analysis (async)
  bool isQuickAnalysis;

  /// Timestamp for tracking
  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [TokenUsageHistory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TokenUsageHistory copyWith({
    int? id,
    String? contentType,
    String? complexityBucket,
    double? complexityScore,
    int? tokensAllocated,
    int? tokensUsed,
    bool? wasComplete,
    bool? isQuickAnalysis,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'contentType': contentType,
      'complexityBucket': complexityBucket,
      if (complexityScore != null) 'complexityScore': complexityScore,
      'tokensAllocated': tokensAllocated,
      'tokensUsed': tokensUsed,
      'wasComplete': wasComplete,
      'isQuickAnalysis': isQuickAnalysis,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'contentType': contentType,
      'complexityBucket': complexityBucket,
      if (complexityScore != null) 'complexityScore': complexityScore,
      'tokensAllocated': tokensAllocated,
      'tokensUsed': tokensUsed,
      'wasComplete': wasComplete,
      'isQuickAnalysis': isQuickAnalysis,
      'createdAt': createdAt.toJson(),
    };
  }

  static TokenUsageHistoryInclude include() {
    return TokenUsageHistoryInclude._();
  }

  static TokenUsageHistoryIncludeList includeList({
    _i1.WhereExpressionBuilder<TokenUsageHistoryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TokenUsageHistoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TokenUsageHistoryTable>? orderByList,
    TokenUsageHistoryInclude? include,
  }) {
    return TokenUsageHistoryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TokenUsageHistory.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(TokenUsageHistory.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TokenUsageHistoryImpl extends TokenUsageHistory {
  _TokenUsageHistoryImpl({
    int? id,
    required String contentType,
    required String complexityBucket,
    double? complexityScore,
    required int tokensAllocated,
    required int tokensUsed,
    required bool wasComplete,
    required bool isQuickAnalysis,
    required DateTime createdAt,
  }) : super._(
          id: id,
          contentType: contentType,
          complexityBucket: complexityBucket,
          complexityScore: complexityScore,
          tokensAllocated: tokensAllocated,
          tokensUsed: tokensUsed,
          wasComplete: wasComplete,
          isQuickAnalysis: isQuickAnalysis,
          createdAt: createdAt,
        );

  /// Returns a shallow copy of this [TokenUsageHistory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TokenUsageHistory copyWith({
    Object? id = _Undefined,
    String? contentType,
    String? complexityBucket,
    Object? complexityScore = _Undefined,
    int? tokensAllocated,
    int? tokensUsed,
    bool? wasComplete,
    bool? isQuickAnalysis,
    DateTime? createdAt,
  }) {
    return TokenUsageHistory(
      id: id is int? ? id : this.id,
      contentType: contentType ?? this.contentType,
      complexityBucket: complexityBucket ?? this.complexityBucket,
      complexityScore:
          complexityScore is double? ? complexityScore : this.complexityScore,
      tokensAllocated: tokensAllocated ?? this.tokensAllocated,
      tokensUsed: tokensUsed ?? this.tokensUsed,
      wasComplete: wasComplete ?? this.wasComplete,
      isQuickAnalysis: isQuickAnalysis ?? this.isQuickAnalysis,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class TokenUsageHistoryTable extends _i1.Table<int?> {
  TokenUsageHistoryTable({super.tableRelation})
      : super(tableName: 'token_usage_history') {
    contentType = _i1.ColumnString(
      'contentType',
      this,
    );
    complexityBucket = _i1.ColumnString(
      'complexityBucket',
      this,
    );
    complexityScore = _i1.ColumnDouble(
      'complexityScore',
      this,
    );
    tokensAllocated = _i1.ColumnInt(
      'tokensAllocated',
      this,
    );
    tokensUsed = _i1.ColumnInt(
      'tokensUsed',
      this,
    );
    wasComplete = _i1.ColumnBool(
      'wasComplete',
      this,
    );
    isQuickAnalysis = _i1.ColumnBool(
      'isQuickAnalysis',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  /// Content type detected (document, photo, recipe, etc.)
  late final _i1.ColumnString contentType;

  /// Complexity bucket (simple, medium, complex)
  late final _i1.ColumnString complexityBucket;

  /// Exact complexity score 0.0-1.0
  late final _i1.ColumnDouble complexityScore;

  /// Tokens allocated for this request
  late final _i1.ColumnInt tokensAllocated;

  /// Actual tokens used in response
  late final _i1.ColumnInt tokensUsed;

  /// Whether the response was complete (not truncated)
  late final _i1.ColumnBool wasComplete;

  /// Whether this was quick analysis (sync) or deep analysis (async)
  late final _i1.ColumnBool isQuickAnalysis;

  /// Timestamp for tracking
  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
        id,
        contentType,
        complexityBucket,
        complexityScore,
        tokensAllocated,
        tokensUsed,
        wasComplete,
        isQuickAnalysis,
        createdAt,
      ];
}

class TokenUsageHistoryInclude extends _i1.IncludeObject {
  TokenUsageHistoryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => TokenUsageHistory.t;
}

class TokenUsageHistoryIncludeList extends _i1.IncludeList {
  TokenUsageHistoryIncludeList._({
    _i1.WhereExpressionBuilder<TokenUsageHistoryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TokenUsageHistory.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => TokenUsageHistory.t;
}

class TokenUsageHistoryRepository {
  const TokenUsageHistoryRepository._();

  /// Returns a list of [TokenUsageHistory]s matching the given query parameters.
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
  Future<List<TokenUsageHistory>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TokenUsageHistoryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TokenUsageHistoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TokenUsageHistoryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<TokenUsageHistory>(
      where: where?.call(TokenUsageHistory.t),
      orderBy: orderBy?.call(TokenUsageHistory.t),
      orderByList: orderByList?.call(TokenUsageHistory.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [TokenUsageHistory] matching the given query parameters.
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
  Future<TokenUsageHistory?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TokenUsageHistoryTable>? where,
    int? offset,
    _i1.OrderByBuilder<TokenUsageHistoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TokenUsageHistoryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<TokenUsageHistory>(
      where: where?.call(TokenUsageHistory.t),
      orderBy: orderBy?.call(TokenUsageHistory.t),
      orderByList: orderByList?.call(TokenUsageHistory.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [TokenUsageHistory] by its [id] or null if no such row exists.
  Future<TokenUsageHistory?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<TokenUsageHistory>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [TokenUsageHistory]s in the list and returns the inserted rows.
  ///
  /// The returned [TokenUsageHistory]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<TokenUsageHistory>> insert(
    _i1.Session session,
    List<TokenUsageHistory> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<TokenUsageHistory>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [TokenUsageHistory] and returns the inserted row.
  ///
  /// The returned [TokenUsageHistory] will have its `id` field set.
  Future<TokenUsageHistory> insertRow(
    _i1.Session session,
    TokenUsageHistory row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<TokenUsageHistory>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [TokenUsageHistory]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<TokenUsageHistory>> update(
    _i1.Session session,
    List<TokenUsageHistory> rows, {
    _i1.ColumnSelections<TokenUsageHistoryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<TokenUsageHistory>(
      rows,
      columns: columns?.call(TokenUsageHistory.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TokenUsageHistory]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TokenUsageHistory> updateRow(
    _i1.Session session,
    TokenUsageHistory row, {
    _i1.ColumnSelections<TokenUsageHistoryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<TokenUsageHistory>(
      row,
      columns: columns?.call(TokenUsageHistory.t),
      transaction: transaction,
    );
  }

  /// Deletes all [TokenUsageHistory]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<TokenUsageHistory>> delete(
    _i1.Session session,
    List<TokenUsageHistory> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<TokenUsageHistory>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [TokenUsageHistory].
  Future<TokenUsageHistory> deleteRow(
    _i1.Session session,
    TokenUsageHistory row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TokenUsageHistory>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<TokenUsageHistory>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TokenUsageHistoryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<TokenUsageHistory>(
      where: where(TokenUsageHistory.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TokenUsageHistoryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<TokenUsageHistory>(
      where: where?.call(TokenUsageHistory.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

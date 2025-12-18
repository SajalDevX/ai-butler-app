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

/// Google OAuth Token Storage
/// Stores encrypted OAuth tokens for Google API access
abstract class GoogleToken
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  GoogleToken._({
    this.id,
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.scope,
    required this.gmailEnabled,
    required this.calendarEnabled,
    this.lastGmailSync,
    this.lastCalendarSync,
    this.gmailHistoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GoogleToken({
    int? id,
    required int userId,
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
    required String scope,
    required bool gmailEnabled,
    required bool calendarEnabled,
    DateTime? lastGmailSync,
    DateTime? lastCalendarSync,
    String? gmailHistoryId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _GoogleTokenImpl;

  factory GoogleToken.fromJson(Map<String, dynamic> jsonSerialization) {
    return GoogleToken(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      accessToken: jsonSerialization['accessToken'] as String,
      refreshToken: jsonSerialization['refreshToken'] as String,
      expiresAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      scope: jsonSerialization['scope'] as String,
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
      gmailHistoryId: jsonSerialization['gmailHistoryId'] as String?,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = GoogleTokenTable();

  static const db = GoogleTokenRepository._();

  @override
  int? id;

  int userId;

  String accessToken;

  String refreshToken;

  DateTime expiresAt;

  String scope;

  bool gmailEnabled;

  bool calendarEnabled;

  DateTime? lastGmailSync;

  DateTime? lastCalendarSync;

  String? gmailHistoryId;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [GoogleToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  GoogleToken copyWith({
    int? id,
    int? userId,
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    String? scope,
    bool? gmailEnabled,
    bool? calendarEnabled,
    DateTime? lastGmailSync,
    DateTime? lastCalendarSync,
    String? gmailHistoryId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toJson(),
      'scope': scope,
      'gmailEnabled': gmailEnabled,
      'calendarEnabled': calendarEnabled,
      if (lastGmailSync != null) 'lastGmailSync': lastGmailSync?.toJson(),
      if (lastCalendarSync != null)
        'lastCalendarSync': lastCalendarSync?.toJson(),
      if (gmailHistoryId != null) 'gmailHistoryId': gmailHistoryId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toJson(),
      'scope': scope,
      'gmailEnabled': gmailEnabled,
      'calendarEnabled': calendarEnabled,
      if (lastGmailSync != null) 'lastGmailSync': lastGmailSync?.toJson(),
      if (lastCalendarSync != null)
        'lastCalendarSync': lastCalendarSync?.toJson(),
      if (gmailHistoryId != null) 'gmailHistoryId': gmailHistoryId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static GoogleTokenInclude include() {
    return GoogleTokenInclude._();
  }

  static GoogleTokenIncludeList includeList({
    _i1.WhereExpressionBuilder<GoogleTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GoogleTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GoogleTokenTable>? orderByList,
    GoogleTokenInclude? include,
  }) {
    return GoogleTokenIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GoogleToken.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(GoogleToken.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GoogleTokenImpl extends GoogleToken {
  _GoogleTokenImpl({
    int? id,
    required int userId,
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
    required String scope,
    required bool gmailEnabled,
    required bool calendarEnabled,
    DateTime? lastGmailSync,
    DateTime? lastCalendarSync,
    String? gmailHistoryId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
          id: id,
          userId: userId,
          accessToken: accessToken,
          refreshToken: refreshToken,
          expiresAt: expiresAt,
          scope: scope,
          gmailEnabled: gmailEnabled,
          calendarEnabled: calendarEnabled,
          lastGmailSync: lastGmailSync,
          lastCalendarSync: lastCalendarSync,
          gmailHistoryId: gmailHistoryId,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Returns a shallow copy of this [GoogleToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  GoogleToken copyWith({
    Object? id = _Undefined,
    int? userId,
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    String? scope,
    bool? gmailEnabled,
    bool? calendarEnabled,
    Object? lastGmailSync = _Undefined,
    Object? lastCalendarSync = _Undefined,
    Object? gmailHistoryId = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GoogleToken(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      scope: scope ?? this.scope,
      gmailEnabled: gmailEnabled ?? this.gmailEnabled,
      calendarEnabled: calendarEnabled ?? this.calendarEnabled,
      lastGmailSync:
          lastGmailSync is DateTime? ? lastGmailSync : this.lastGmailSync,
      lastCalendarSync: lastCalendarSync is DateTime?
          ? lastCalendarSync
          : this.lastCalendarSync,
      gmailHistoryId:
          gmailHistoryId is String? ? gmailHistoryId : this.gmailHistoryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class GoogleTokenTable extends _i1.Table<int?> {
  GoogleTokenTable({super.tableRelation}) : super(tableName: 'google_tokens') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    accessToken = _i1.ColumnString(
      'accessToken',
      this,
    );
    refreshToken = _i1.ColumnString(
      'refreshToken',
      this,
    );
    expiresAt = _i1.ColumnDateTime(
      'expiresAt',
      this,
    );
    scope = _i1.ColumnString(
      'scope',
      this,
    );
    gmailEnabled = _i1.ColumnBool(
      'gmailEnabled',
      this,
    );
    calendarEnabled = _i1.ColumnBool(
      'calendarEnabled',
      this,
    );
    lastGmailSync = _i1.ColumnDateTime(
      'lastGmailSync',
      this,
    );
    lastCalendarSync = _i1.ColumnDateTime(
      'lastCalendarSync',
      this,
    );
    gmailHistoryId = _i1.ColumnString(
      'gmailHistoryId',
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

  late final _i1.ColumnString accessToken;

  late final _i1.ColumnString refreshToken;

  late final _i1.ColumnDateTime expiresAt;

  late final _i1.ColumnString scope;

  late final _i1.ColumnBool gmailEnabled;

  late final _i1.ColumnBool calendarEnabled;

  late final _i1.ColumnDateTime lastGmailSync;

  late final _i1.ColumnDateTime lastCalendarSync;

  late final _i1.ColumnString gmailHistoryId;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        accessToken,
        refreshToken,
        expiresAt,
        scope,
        gmailEnabled,
        calendarEnabled,
        lastGmailSync,
        lastCalendarSync,
        gmailHistoryId,
        createdAt,
        updatedAt,
      ];
}

class GoogleTokenInclude extends _i1.IncludeObject {
  GoogleTokenInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => GoogleToken.t;
}

class GoogleTokenIncludeList extends _i1.IncludeList {
  GoogleTokenIncludeList._({
    _i1.WhereExpressionBuilder<GoogleTokenTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(GoogleToken.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => GoogleToken.t;
}

class GoogleTokenRepository {
  const GoogleTokenRepository._();

  /// Returns a list of [GoogleToken]s matching the given query parameters.
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
  Future<List<GoogleToken>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GoogleTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GoogleTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GoogleTokenTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<GoogleToken>(
      where: where?.call(GoogleToken.t),
      orderBy: orderBy?.call(GoogleToken.t),
      orderByList: orderByList?.call(GoogleToken.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [GoogleToken] matching the given query parameters.
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
  Future<GoogleToken?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GoogleTokenTable>? where,
    int? offset,
    _i1.OrderByBuilder<GoogleTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GoogleTokenTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<GoogleToken>(
      where: where?.call(GoogleToken.t),
      orderBy: orderBy?.call(GoogleToken.t),
      orderByList: orderByList?.call(GoogleToken.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [GoogleToken] by its [id] or null if no such row exists.
  Future<GoogleToken?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<GoogleToken>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [GoogleToken]s in the list and returns the inserted rows.
  ///
  /// The returned [GoogleToken]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<GoogleToken>> insert(
    _i1.Session session,
    List<GoogleToken> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<GoogleToken>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [GoogleToken] and returns the inserted row.
  ///
  /// The returned [GoogleToken] will have its `id` field set.
  Future<GoogleToken> insertRow(
    _i1.Session session,
    GoogleToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<GoogleToken>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [GoogleToken]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<GoogleToken>> update(
    _i1.Session session,
    List<GoogleToken> rows, {
    _i1.ColumnSelections<GoogleTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<GoogleToken>(
      rows,
      columns: columns?.call(GoogleToken.t),
      transaction: transaction,
    );
  }

  /// Updates a single [GoogleToken]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<GoogleToken> updateRow(
    _i1.Session session,
    GoogleToken row, {
    _i1.ColumnSelections<GoogleTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<GoogleToken>(
      row,
      columns: columns?.call(GoogleToken.t),
      transaction: transaction,
    );
  }

  /// Deletes all [GoogleToken]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<GoogleToken>> delete(
    _i1.Session session,
    List<GoogleToken> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<GoogleToken>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [GoogleToken].
  Future<GoogleToken> deleteRow(
    _i1.Session session,
    GoogleToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<GoogleToken>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<GoogleToken>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<GoogleTokenTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<GoogleToken>(
      where: where(GoogleToken.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GoogleTokenTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<GoogleToken>(
      where: where?.call(GoogleToken.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

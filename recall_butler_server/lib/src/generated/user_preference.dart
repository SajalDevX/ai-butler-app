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

/// UserPreference - user settings and preferences
abstract class UserPreference
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = UserPreferenceTable();

  static const db = UserPreferenceRepository._();

  @override
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

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static UserPreferenceInclude include() {
    return UserPreferenceInclude._();
  }

  static UserPreferenceIncludeList includeList({
    _i1.WhereExpressionBuilder<UserPreferenceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserPreferenceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserPreferenceTable>? orderByList,
    UserPreferenceInclude? include,
  }) {
    return UserPreferenceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserPreference.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserPreference.t),
      include: include,
    );
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

class UserPreferenceTable extends _i1.Table<int?> {
  UserPreferenceTable({super.tableRelation})
      : super(tableName: 'user_preference') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    timezone = _i1.ColumnString(
      'timezone',
      this,
    );
    notificationTime = _i1.ColumnString(
      'notificationTime',
      this,
    );
    overlayEnabled = _i1.ColumnBool(
      'overlayEnabled',
      this,
    );
    weeklyDigestEnabled = _i1.ColumnBool(
      'weeklyDigestEnabled',
      this,
    );
    proactiveRemindersEnabled = _i1.ColumnBool(
      'proactiveRemindersEnabled',
      this,
    );
    theme = _i1.ColumnString(
      'theme',
      this,
    );
  }

  /// Foreign key to user
  late final _i1.ColumnInt userId;

  /// User's timezone
  late final _i1.ColumnString timezone;

  /// Preferred notification time (HH:mm format)
  late final _i1.ColumnString notificationTime;

  /// Whether floating overlay is enabled
  late final _i1.ColumnBool overlayEnabled;

  /// Whether weekly digest is enabled
  late final _i1.ColumnBool weeklyDigestEnabled;

  /// Whether proactive reminders are enabled
  late final _i1.ColumnBool proactiveRemindersEnabled;

  /// Theme preference: dark, light, system
  late final _i1.ColumnString theme;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        timezone,
        notificationTime,
        overlayEnabled,
        weeklyDigestEnabled,
        proactiveRemindersEnabled,
        theme,
      ];
}

class UserPreferenceInclude extends _i1.IncludeObject {
  UserPreferenceInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UserPreference.t;
}

class UserPreferenceIncludeList extends _i1.IncludeList {
  UserPreferenceIncludeList._({
    _i1.WhereExpressionBuilder<UserPreferenceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserPreference.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserPreference.t;
}

class UserPreferenceRepository {
  const UserPreferenceRepository._();

  /// Returns a list of [UserPreference]s matching the given query parameters.
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
  Future<List<UserPreference>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserPreferenceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserPreferenceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserPreferenceTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UserPreference>(
      where: where?.call(UserPreference.t),
      orderBy: orderBy?.call(UserPreference.t),
      orderByList: orderByList?.call(UserPreference.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UserPreference] matching the given query parameters.
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
  Future<UserPreference?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserPreferenceTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserPreferenceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserPreferenceTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UserPreference>(
      where: where?.call(UserPreference.t),
      orderBy: orderBy?.call(UserPreference.t),
      orderByList: orderByList?.call(UserPreference.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UserPreference] by its [id] or null if no such row exists.
  Future<UserPreference?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UserPreference>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UserPreference]s in the list and returns the inserted rows.
  ///
  /// The returned [UserPreference]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserPreference>> insert(
    _i1.Session session,
    List<UserPreference> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserPreference>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserPreference] and returns the inserted row.
  ///
  /// The returned [UserPreference] will have its `id` field set.
  Future<UserPreference> insertRow(
    _i1.Session session,
    UserPreference row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserPreference>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserPreference]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserPreference>> update(
    _i1.Session session,
    List<UserPreference> rows, {
    _i1.ColumnSelections<UserPreferenceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserPreference>(
      rows,
      columns: columns?.call(UserPreference.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserPreference]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserPreference> updateRow(
    _i1.Session session,
    UserPreference row, {
    _i1.ColumnSelections<UserPreferenceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserPreference>(
      row,
      columns: columns?.call(UserPreference.t),
      transaction: transaction,
    );
  }

  /// Deletes all [UserPreference]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserPreference>> delete(
    _i1.Session session,
    List<UserPreference> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserPreference>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserPreference].
  Future<UserPreference> deleteRow(
    _i1.Session session,
    UserPreference row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserPreference>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserPreference>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserPreferenceTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserPreference>(
      where: where(UserPreference.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserPreferenceTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserPreference>(
      where: where?.call(UserPreference.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

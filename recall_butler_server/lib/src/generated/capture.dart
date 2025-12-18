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

/// Capture model - stores all captured content (screenshots, photos, voice, links)
abstract class Capture
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Capture._({
    this.id,
    required this.userId,
    required this.type,
    this.originalUrl,
    this.thumbnailUrl,
    this.quickDescription,
    this.quickType,
    this.extractedText,
    this.aiSummary,
    this.tags,
    required this.category,
    required this.createdAt,
    required this.isReminder,
    this.sourceApp,
    required this.processingStatus,
    this.processingProgress,
    this.processedAt,
    this.errorMessage,
  });

  factory Capture({
    int? id,
    required int userId,
    required String type,
    String? originalUrl,
    String? thumbnailUrl,
    String? quickDescription,
    String? quickType,
    String? extractedText,
    String? aiSummary,
    String? tags,
    required String category,
    required DateTime createdAt,
    required bool isReminder,
    String? sourceApp,
    required String processingStatus,
    int? processingProgress,
    DateTime? processedAt,
    String? errorMessage,
  }) = _CaptureImpl;

  factory Capture.fromJson(Map<String, dynamic> jsonSerialization) {
    return Capture(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      type: jsonSerialization['type'] as String,
      originalUrl: jsonSerialization['originalUrl'] as String?,
      thumbnailUrl: jsonSerialization['thumbnailUrl'] as String?,
      quickDescription: jsonSerialization['quickDescription'] as String?,
      quickType: jsonSerialization['quickType'] as String?,
      extractedText: jsonSerialization['extractedText'] as String?,
      aiSummary: jsonSerialization['aiSummary'] as String?,
      tags: jsonSerialization['tags'] as String?,
      category: jsonSerialization['category'] as String,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      isReminder: jsonSerialization['isReminder'] as bool,
      sourceApp: jsonSerialization['sourceApp'] as String?,
      processingStatus: jsonSerialization['processingStatus'] as String,
      processingProgress: jsonSerialization['processingProgress'] as int?,
      processedAt: jsonSerialization['processedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['processedAt']),
      errorMessage: jsonSerialization['errorMessage'] as String?,
    );
  }

  static final t = CaptureTable();

  static const db = CaptureRepository._();

  @override
  int? id;

  /// Foreign key to user
  int userId;

  /// Type of capture: screenshot, photo, voice, link
  String type;

  /// File storage URL for original file
  String? originalUrl;

  /// Compressed thumbnail URL
  String? thumbnailUrl;

  /// Quick analysis (populated immediately in sync phase)
  String? quickDescription;

  String? quickType;

  /// Full analysis (populated by background worker)
  String? extractedText;

  /// AI-generated description/summary
  String? aiSummary;

  /// JSON array of AI-generated tags
  String? tags;

  /// Category: Work, Personal, Recipe, Shopping, Travel, Health, Finance, Learning, Other
  String category;

  /// Capture timestamp
  DateTime createdAt;

  /// Whether this is a reminder-type capture
  bool isReminder;

  /// Source app or URL where content was captured from
  String? sourceApp;

  /// Processing status: pending, analyzing, processing, completed, failed
  String processingStatus;

  /// Processing progress 0-100
  int? processingProgress;

  /// When full processing completed
  DateTime? processedAt;

  /// Error message if failed
  String? errorMessage;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Capture]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Capture copyWith({
    int? id,
    int? userId,
    String? type,
    String? originalUrl,
    String? thumbnailUrl,
    String? quickDescription,
    String? quickType,
    String? extractedText,
    String? aiSummary,
    String? tags,
    String? category,
    DateTime? createdAt,
    bool? isReminder,
    String? sourceApp,
    String? processingStatus,
    int? processingProgress,
    DateTime? processedAt,
    String? errorMessage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'type': type,
      if (originalUrl != null) 'originalUrl': originalUrl,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      if (quickDescription != null) 'quickDescription': quickDescription,
      if (quickType != null) 'quickType': quickType,
      if (extractedText != null) 'extractedText': extractedText,
      if (aiSummary != null) 'aiSummary': aiSummary,
      if (tags != null) 'tags': tags,
      'category': category,
      'createdAt': createdAt.toJson(),
      'isReminder': isReminder,
      if (sourceApp != null) 'sourceApp': sourceApp,
      'processingStatus': processingStatus,
      if (processingProgress != null) 'processingProgress': processingProgress,
      if (processedAt != null) 'processedAt': processedAt?.toJson(),
      if (errorMessage != null) 'errorMessage': errorMessage,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'type': type,
      if (originalUrl != null) 'originalUrl': originalUrl,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      if (quickDescription != null) 'quickDescription': quickDescription,
      if (quickType != null) 'quickType': quickType,
      if (extractedText != null) 'extractedText': extractedText,
      if (aiSummary != null) 'aiSummary': aiSummary,
      if (tags != null) 'tags': tags,
      'category': category,
      'createdAt': createdAt.toJson(),
      'isReminder': isReminder,
      if (sourceApp != null) 'sourceApp': sourceApp,
      'processingStatus': processingStatus,
      if (processingProgress != null) 'processingProgress': processingProgress,
      if (processedAt != null) 'processedAt': processedAt?.toJson(),
      if (errorMessage != null) 'errorMessage': errorMessage,
    };
  }

  static CaptureInclude include() {
    return CaptureInclude._();
  }

  static CaptureIncludeList includeList({
    _i1.WhereExpressionBuilder<CaptureTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CaptureTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CaptureTable>? orderByList,
    CaptureInclude? include,
  }) {
    return CaptureIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Capture.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Capture.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CaptureImpl extends Capture {
  _CaptureImpl({
    int? id,
    required int userId,
    required String type,
    String? originalUrl,
    String? thumbnailUrl,
    String? quickDescription,
    String? quickType,
    String? extractedText,
    String? aiSummary,
    String? tags,
    required String category,
    required DateTime createdAt,
    required bool isReminder,
    String? sourceApp,
    required String processingStatus,
    int? processingProgress,
    DateTime? processedAt,
    String? errorMessage,
  }) : super._(
          id: id,
          userId: userId,
          type: type,
          originalUrl: originalUrl,
          thumbnailUrl: thumbnailUrl,
          quickDescription: quickDescription,
          quickType: quickType,
          extractedText: extractedText,
          aiSummary: aiSummary,
          tags: tags,
          category: category,
          createdAt: createdAt,
          isReminder: isReminder,
          sourceApp: sourceApp,
          processingStatus: processingStatus,
          processingProgress: processingProgress,
          processedAt: processedAt,
          errorMessage: errorMessage,
        );

  /// Returns a shallow copy of this [Capture]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Capture copyWith({
    Object? id = _Undefined,
    int? userId,
    String? type,
    Object? originalUrl = _Undefined,
    Object? thumbnailUrl = _Undefined,
    Object? quickDescription = _Undefined,
    Object? quickType = _Undefined,
    Object? extractedText = _Undefined,
    Object? aiSummary = _Undefined,
    Object? tags = _Undefined,
    String? category,
    DateTime? createdAt,
    bool? isReminder,
    Object? sourceApp = _Undefined,
    String? processingStatus,
    Object? processingProgress = _Undefined,
    Object? processedAt = _Undefined,
    Object? errorMessage = _Undefined,
  }) {
    return Capture(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      originalUrl: originalUrl is String? ? originalUrl : this.originalUrl,
      thumbnailUrl: thumbnailUrl is String? ? thumbnailUrl : this.thumbnailUrl,
      quickDescription: quickDescription is String?
          ? quickDescription
          : this.quickDescription,
      quickType: quickType is String? ? quickType : this.quickType,
      extractedText:
          extractedText is String? ? extractedText : this.extractedText,
      aiSummary: aiSummary is String? ? aiSummary : this.aiSummary,
      tags: tags is String? ? tags : this.tags,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      isReminder: isReminder ?? this.isReminder,
      sourceApp: sourceApp is String? ? sourceApp : this.sourceApp,
      processingStatus: processingStatus ?? this.processingStatus,
      processingProgress: processingProgress is int?
          ? processingProgress
          : this.processingProgress,
      processedAt: processedAt is DateTime? ? processedAt : this.processedAt,
      errorMessage: errorMessage is String? ? errorMessage : this.errorMessage,
    );
  }
}

class CaptureTable extends _i1.Table<int?> {
  CaptureTable({super.tableRelation}) : super(tableName: 'capture') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    type = _i1.ColumnString(
      'type',
      this,
    );
    originalUrl = _i1.ColumnString(
      'originalUrl',
      this,
    );
    thumbnailUrl = _i1.ColumnString(
      'thumbnailUrl',
      this,
    );
    quickDescription = _i1.ColumnString(
      'quickDescription',
      this,
    );
    quickType = _i1.ColumnString(
      'quickType',
      this,
    );
    extractedText = _i1.ColumnString(
      'extractedText',
      this,
    );
    aiSummary = _i1.ColumnString(
      'aiSummary',
      this,
    );
    tags = _i1.ColumnString(
      'tags',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    isReminder = _i1.ColumnBool(
      'isReminder',
      this,
    );
    sourceApp = _i1.ColumnString(
      'sourceApp',
      this,
    );
    processingStatus = _i1.ColumnString(
      'processingStatus',
      this,
    );
    processingProgress = _i1.ColumnInt(
      'processingProgress',
      this,
    );
    processedAt = _i1.ColumnDateTime(
      'processedAt',
      this,
    );
    errorMessage = _i1.ColumnString(
      'errorMessage',
      this,
    );
  }

  /// Foreign key to user
  late final _i1.ColumnInt userId;

  /// Type of capture: screenshot, photo, voice, link
  late final _i1.ColumnString type;

  /// File storage URL for original file
  late final _i1.ColumnString originalUrl;

  /// Compressed thumbnail URL
  late final _i1.ColumnString thumbnailUrl;

  /// Quick analysis (populated immediately in sync phase)
  late final _i1.ColumnString quickDescription;

  late final _i1.ColumnString quickType;

  /// Full analysis (populated by background worker)
  late final _i1.ColumnString extractedText;

  /// AI-generated description/summary
  late final _i1.ColumnString aiSummary;

  /// JSON array of AI-generated tags
  late final _i1.ColumnString tags;

  /// Category: Work, Personal, Recipe, Shopping, Travel, Health, Finance, Learning, Other
  late final _i1.ColumnString category;

  /// Capture timestamp
  late final _i1.ColumnDateTime createdAt;

  /// Whether this is a reminder-type capture
  late final _i1.ColumnBool isReminder;

  /// Source app or URL where content was captured from
  late final _i1.ColumnString sourceApp;

  /// Processing status: pending, analyzing, processing, completed, failed
  late final _i1.ColumnString processingStatus;

  /// Processing progress 0-100
  late final _i1.ColumnInt processingProgress;

  /// When full processing completed
  late final _i1.ColumnDateTime processedAt;

  /// Error message if failed
  late final _i1.ColumnString errorMessage;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        type,
        originalUrl,
        thumbnailUrl,
        quickDescription,
        quickType,
        extractedText,
        aiSummary,
        tags,
        category,
        createdAt,
        isReminder,
        sourceApp,
        processingStatus,
        processingProgress,
        processedAt,
        errorMessage,
      ];
}

class CaptureInclude extends _i1.IncludeObject {
  CaptureInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Capture.t;
}

class CaptureIncludeList extends _i1.IncludeList {
  CaptureIncludeList._({
    _i1.WhereExpressionBuilder<CaptureTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Capture.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Capture.t;
}

class CaptureRepository {
  const CaptureRepository._();

  /// Returns a list of [Capture]s matching the given query parameters.
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
  Future<List<Capture>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CaptureTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CaptureTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CaptureTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Capture>(
      where: where?.call(Capture.t),
      orderBy: orderBy?.call(Capture.t),
      orderByList: orderByList?.call(Capture.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Capture] matching the given query parameters.
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
  Future<Capture?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CaptureTable>? where,
    int? offset,
    _i1.OrderByBuilder<CaptureTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CaptureTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Capture>(
      where: where?.call(Capture.t),
      orderBy: orderBy?.call(Capture.t),
      orderByList: orderByList?.call(Capture.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Capture] by its [id] or null if no such row exists.
  Future<Capture?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Capture>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Capture]s in the list and returns the inserted rows.
  ///
  /// The returned [Capture]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Capture>> insert(
    _i1.Session session,
    List<Capture> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Capture>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Capture] and returns the inserted row.
  ///
  /// The returned [Capture] will have its `id` field set.
  Future<Capture> insertRow(
    _i1.Session session,
    Capture row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Capture>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Capture]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Capture>> update(
    _i1.Session session,
    List<Capture> rows, {
    _i1.ColumnSelections<CaptureTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Capture>(
      rows,
      columns: columns?.call(Capture.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Capture]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Capture> updateRow(
    _i1.Session session,
    Capture row, {
    _i1.ColumnSelections<CaptureTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Capture>(
      row,
      columns: columns?.call(Capture.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Capture]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Capture>> delete(
    _i1.Session session,
    List<Capture> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Capture>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Capture].
  Future<Capture> deleteRow(
    _i1.Session session,
    Capture row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Capture>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Capture>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CaptureTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Capture>(
      where: where(Capture.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CaptureTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Capture>(
      where: where?.call(Capture.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

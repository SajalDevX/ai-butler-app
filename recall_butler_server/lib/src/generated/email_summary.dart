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

/// Email Summary - AI-processed email data
/// Stores email metadata and AI analysis results
abstract class EmailSummary
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  EmailSummary._({
    this.id,
    required this.userId,
    required this.gmailId,
    required this.threadId,
    required this.subject,
    required this.fromEmail,
    this.fromName,
    required this.toEmails,
    this.ccEmails,
    required this.receivedAt,
    this.snippet,
    this.bodyText,
    required this.hasAttachments,
    this.attachmentNames,
    this.aiSummary,
    required this.importanceScore,
    this.importanceReason,
    required this.category,
    this.sentiment,
    required this.requiresAction,
    this.suggestedActions,
    this.deadlineDetected,
    this.draftReply,
    this.draftTone,
    required this.isRead,
    required this.isArchived,
    required this.isProcessed,
    this.processingError,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmailSummary({
    int? id,
    required int userId,
    required String gmailId,
    required String threadId,
    required String subject,
    required String fromEmail,
    String? fromName,
    required String toEmails,
    String? ccEmails,
    required DateTime receivedAt,
    String? snippet,
    String? bodyText,
    required bool hasAttachments,
    String? attachmentNames,
    String? aiSummary,
    required int importanceScore,
    String? importanceReason,
    required String category,
    String? sentiment,
    required bool requiresAction,
    String? suggestedActions,
    DateTime? deadlineDetected,
    String? draftReply,
    String? draftTone,
    required bool isRead,
    required bool isArchived,
    required bool isProcessed,
    String? processingError,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _EmailSummaryImpl;

  factory EmailSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmailSummary(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      gmailId: jsonSerialization['gmailId'] as String,
      threadId: jsonSerialization['threadId'] as String,
      subject: jsonSerialization['subject'] as String,
      fromEmail: jsonSerialization['fromEmail'] as String,
      fromName: jsonSerialization['fromName'] as String?,
      toEmails: jsonSerialization['toEmails'] as String,
      ccEmails: jsonSerialization['ccEmails'] as String?,
      receivedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['receivedAt']),
      snippet: jsonSerialization['snippet'] as String?,
      bodyText: jsonSerialization['bodyText'] as String?,
      hasAttachments: jsonSerialization['hasAttachments'] as bool,
      attachmentNames: jsonSerialization['attachmentNames'] as String?,
      aiSummary: jsonSerialization['aiSummary'] as String?,
      importanceScore: jsonSerialization['importanceScore'] as int,
      importanceReason: jsonSerialization['importanceReason'] as String?,
      category: jsonSerialization['category'] as String,
      sentiment: jsonSerialization['sentiment'] as String?,
      requiresAction: jsonSerialization['requiresAction'] as bool,
      suggestedActions: jsonSerialization['suggestedActions'] as String?,
      deadlineDetected: jsonSerialization['deadlineDetected'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['deadlineDetected']),
      draftReply: jsonSerialization['draftReply'] as String?,
      draftTone: jsonSerialization['draftTone'] as String?,
      isRead: jsonSerialization['isRead'] as bool,
      isArchived: jsonSerialization['isArchived'] as bool,
      isProcessed: jsonSerialization['isProcessed'] as bool,
      processingError: jsonSerialization['processingError'] as String?,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = EmailSummaryTable();

  static const db = EmailSummaryRepository._();

  @override
  int? id;

  int userId;

  String gmailId;

  String threadId;

  String subject;

  String fromEmail;

  String? fromName;

  String toEmails;

  String? ccEmails;

  DateTime receivedAt;

  String? snippet;

  String? bodyText;

  bool hasAttachments;

  String? attachmentNames;

  String? aiSummary;

  int importanceScore;

  String? importanceReason;

  String category;

  String? sentiment;

  bool requiresAction;

  String? suggestedActions;

  DateTime? deadlineDetected;

  String? draftReply;

  String? draftTone;

  bool isRead;

  bool isArchived;

  bool isProcessed;

  String? processingError;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [EmailSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailSummary copyWith({
    int? id,
    int? userId,
    String? gmailId,
    String? threadId,
    String? subject,
    String? fromEmail,
    String? fromName,
    String? toEmails,
    String? ccEmails,
    DateTime? receivedAt,
    String? snippet,
    String? bodyText,
    bool? hasAttachments,
    String? attachmentNames,
    String? aiSummary,
    int? importanceScore,
    String? importanceReason,
    String? category,
    String? sentiment,
    bool? requiresAction,
    String? suggestedActions,
    DateTime? deadlineDetected,
    String? draftReply,
    String? draftTone,
    bool? isRead,
    bool? isArchived,
    bool? isProcessed,
    String? processingError,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'gmailId': gmailId,
      'threadId': threadId,
      'subject': subject,
      'fromEmail': fromEmail,
      if (fromName != null) 'fromName': fromName,
      'toEmails': toEmails,
      if (ccEmails != null) 'ccEmails': ccEmails,
      'receivedAt': receivedAt.toJson(),
      if (snippet != null) 'snippet': snippet,
      if (bodyText != null) 'bodyText': bodyText,
      'hasAttachments': hasAttachments,
      if (attachmentNames != null) 'attachmentNames': attachmentNames,
      if (aiSummary != null) 'aiSummary': aiSummary,
      'importanceScore': importanceScore,
      if (importanceReason != null) 'importanceReason': importanceReason,
      'category': category,
      if (sentiment != null) 'sentiment': sentiment,
      'requiresAction': requiresAction,
      if (suggestedActions != null) 'suggestedActions': suggestedActions,
      if (deadlineDetected != null)
        'deadlineDetected': deadlineDetected?.toJson(),
      if (draftReply != null) 'draftReply': draftReply,
      if (draftTone != null) 'draftTone': draftTone,
      'isRead': isRead,
      'isArchived': isArchived,
      'isProcessed': isProcessed,
      if (processingError != null) 'processingError': processingError,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'gmailId': gmailId,
      'threadId': threadId,
      'subject': subject,
      'fromEmail': fromEmail,
      if (fromName != null) 'fromName': fromName,
      'toEmails': toEmails,
      if (ccEmails != null) 'ccEmails': ccEmails,
      'receivedAt': receivedAt.toJson(),
      if (snippet != null) 'snippet': snippet,
      if (bodyText != null) 'bodyText': bodyText,
      'hasAttachments': hasAttachments,
      if (attachmentNames != null) 'attachmentNames': attachmentNames,
      if (aiSummary != null) 'aiSummary': aiSummary,
      'importanceScore': importanceScore,
      if (importanceReason != null) 'importanceReason': importanceReason,
      'category': category,
      if (sentiment != null) 'sentiment': sentiment,
      'requiresAction': requiresAction,
      if (suggestedActions != null) 'suggestedActions': suggestedActions,
      if (deadlineDetected != null)
        'deadlineDetected': deadlineDetected?.toJson(),
      if (draftReply != null) 'draftReply': draftReply,
      if (draftTone != null) 'draftTone': draftTone,
      'isRead': isRead,
      'isArchived': isArchived,
      'isProcessed': isProcessed,
      if (processingError != null) 'processingError': processingError,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static EmailSummaryInclude include() {
    return EmailSummaryInclude._();
  }

  static EmailSummaryIncludeList includeList({
    _i1.WhereExpressionBuilder<EmailSummaryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailSummaryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailSummaryTable>? orderByList,
    EmailSummaryInclude? include,
  }) {
    return EmailSummaryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailSummary.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EmailSummary.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailSummaryImpl extends EmailSummary {
  _EmailSummaryImpl({
    int? id,
    required int userId,
    required String gmailId,
    required String threadId,
    required String subject,
    required String fromEmail,
    String? fromName,
    required String toEmails,
    String? ccEmails,
    required DateTime receivedAt,
    String? snippet,
    String? bodyText,
    required bool hasAttachments,
    String? attachmentNames,
    String? aiSummary,
    required int importanceScore,
    String? importanceReason,
    required String category,
    String? sentiment,
    required bool requiresAction,
    String? suggestedActions,
    DateTime? deadlineDetected,
    String? draftReply,
    String? draftTone,
    required bool isRead,
    required bool isArchived,
    required bool isProcessed,
    String? processingError,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
          id: id,
          userId: userId,
          gmailId: gmailId,
          threadId: threadId,
          subject: subject,
          fromEmail: fromEmail,
          fromName: fromName,
          toEmails: toEmails,
          ccEmails: ccEmails,
          receivedAt: receivedAt,
          snippet: snippet,
          bodyText: bodyText,
          hasAttachments: hasAttachments,
          attachmentNames: attachmentNames,
          aiSummary: aiSummary,
          importanceScore: importanceScore,
          importanceReason: importanceReason,
          category: category,
          sentiment: sentiment,
          requiresAction: requiresAction,
          suggestedActions: suggestedActions,
          deadlineDetected: deadlineDetected,
          draftReply: draftReply,
          draftTone: draftTone,
          isRead: isRead,
          isArchived: isArchived,
          isProcessed: isProcessed,
          processingError: processingError,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Returns a shallow copy of this [EmailSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailSummary copyWith({
    Object? id = _Undefined,
    int? userId,
    String? gmailId,
    String? threadId,
    String? subject,
    String? fromEmail,
    Object? fromName = _Undefined,
    String? toEmails,
    Object? ccEmails = _Undefined,
    DateTime? receivedAt,
    Object? snippet = _Undefined,
    Object? bodyText = _Undefined,
    bool? hasAttachments,
    Object? attachmentNames = _Undefined,
    Object? aiSummary = _Undefined,
    int? importanceScore,
    Object? importanceReason = _Undefined,
    String? category,
    Object? sentiment = _Undefined,
    bool? requiresAction,
    Object? suggestedActions = _Undefined,
    Object? deadlineDetected = _Undefined,
    Object? draftReply = _Undefined,
    Object? draftTone = _Undefined,
    bool? isRead,
    bool? isArchived,
    bool? isProcessed,
    Object? processingError = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EmailSummary(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      gmailId: gmailId ?? this.gmailId,
      threadId: threadId ?? this.threadId,
      subject: subject ?? this.subject,
      fromEmail: fromEmail ?? this.fromEmail,
      fromName: fromName is String? ? fromName : this.fromName,
      toEmails: toEmails ?? this.toEmails,
      ccEmails: ccEmails is String? ? ccEmails : this.ccEmails,
      receivedAt: receivedAt ?? this.receivedAt,
      snippet: snippet is String? ? snippet : this.snippet,
      bodyText: bodyText is String? ? bodyText : this.bodyText,
      hasAttachments: hasAttachments ?? this.hasAttachments,
      attachmentNames:
          attachmentNames is String? ? attachmentNames : this.attachmentNames,
      aiSummary: aiSummary is String? ? aiSummary : this.aiSummary,
      importanceScore: importanceScore ?? this.importanceScore,
      importanceReason: importanceReason is String?
          ? importanceReason
          : this.importanceReason,
      category: category ?? this.category,
      sentiment: sentiment is String? ? sentiment : this.sentiment,
      requiresAction: requiresAction ?? this.requiresAction,
      suggestedActions: suggestedActions is String?
          ? suggestedActions
          : this.suggestedActions,
      deadlineDetected: deadlineDetected is DateTime?
          ? deadlineDetected
          : this.deadlineDetected,
      draftReply: draftReply is String? ? draftReply : this.draftReply,
      draftTone: draftTone is String? ? draftTone : this.draftTone,
      isRead: isRead ?? this.isRead,
      isArchived: isArchived ?? this.isArchived,
      isProcessed: isProcessed ?? this.isProcessed,
      processingError:
          processingError is String? ? processingError : this.processingError,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class EmailSummaryTable extends _i1.Table<int?> {
  EmailSummaryTable({super.tableRelation})
      : super(tableName: 'email_summaries') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    gmailId = _i1.ColumnString(
      'gmailId',
      this,
    );
    threadId = _i1.ColumnString(
      'threadId',
      this,
    );
    subject = _i1.ColumnString(
      'subject',
      this,
    );
    fromEmail = _i1.ColumnString(
      'fromEmail',
      this,
    );
    fromName = _i1.ColumnString(
      'fromName',
      this,
    );
    toEmails = _i1.ColumnString(
      'toEmails',
      this,
    );
    ccEmails = _i1.ColumnString(
      'ccEmails',
      this,
    );
    receivedAt = _i1.ColumnDateTime(
      'receivedAt',
      this,
    );
    snippet = _i1.ColumnString(
      'snippet',
      this,
    );
    bodyText = _i1.ColumnString(
      'bodyText',
      this,
    );
    hasAttachments = _i1.ColumnBool(
      'hasAttachments',
      this,
    );
    attachmentNames = _i1.ColumnString(
      'attachmentNames',
      this,
    );
    aiSummary = _i1.ColumnString(
      'aiSummary',
      this,
    );
    importanceScore = _i1.ColumnInt(
      'importanceScore',
      this,
    );
    importanceReason = _i1.ColumnString(
      'importanceReason',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    sentiment = _i1.ColumnString(
      'sentiment',
      this,
    );
    requiresAction = _i1.ColumnBool(
      'requiresAction',
      this,
    );
    suggestedActions = _i1.ColumnString(
      'suggestedActions',
      this,
    );
    deadlineDetected = _i1.ColumnDateTime(
      'deadlineDetected',
      this,
    );
    draftReply = _i1.ColumnString(
      'draftReply',
      this,
    );
    draftTone = _i1.ColumnString(
      'draftTone',
      this,
    );
    isRead = _i1.ColumnBool(
      'isRead',
      this,
    );
    isArchived = _i1.ColumnBool(
      'isArchived',
      this,
    );
    isProcessed = _i1.ColumnBool(
      'isProcessed',
      this,
    );
    processingError = _i1.ColumnString(
      'processingError',
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

  late final _i1.ColumnString gmailId;

  late final _i1.ColumnString threadId;

  late final _i1.ColumnString subject;

  late final _i1.ColumnString fromEmail;

  late final _i1.ColumnString fromName;

  late final _i1.ColumnString toEmails;

  late final _i1.ColumnString ccEmails;

  late final _i1.ColumnDateTime receivedAt;

  late final _i1.ColumnString snippet;

  late final _i1.ColumnString bodyText;

  late final _i1.ColumnBool hasAttachments;

  late final _i1.ColumnString attachmentNames;

  late final _i1.ColumnString aiSummary;

  late final _i1.ColumnInt importanceScore;

  late final _i1.ColumnString importanceReason;

  late final _i1.ColumnString category;

  late final _i1.ColumnString sentiment;

  late final _i1.ColumnBool requiresAction;

  late final _i1.ColumnString suggestedActions;

  late final _i1.ColumnDateTime deadlineDetected;

  late final _i1.ColumnString draftReply;

  late final _i1.ColumnString draftTone;

  late final _i1.ColumnBool isRead;

  late final _i1.ColumnBool isArchived;

  late final _i1.ColumnBool isProcessed;

  late final _i1.ColumnString processingError;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        gmailId,
        threadId,
        subject,
        fromEmail,
        fromName,
        toEmails,
        ccEmails,
        receivedAt,
        snippet,
        bodyText,
        hasAttachments,
        attachmentNames,
        aiSummary,
        importanceScore,
        importanceReason,
        category,
        sentiment,
        requiresAction,
        suggestedActions,
        deadlineDetected,
        draftReply,
        draftTone,
        isRead,
        isArchived,
        isProcessed,
        processingError,
        createdAt,
        updatedAt,
      ];
}

class EmailSummaryInclude extends _i1.IncludeObject {
  EmailSummaryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => EmailSummary.t;
}

class EmailSummaryIncludeList extends _i1.IncludeList {
  EmailSummaryIncludeList._({
    _i1.WhereExpressionBuilder<EmailSummaryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EmailSummary.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => EmailSummary.t;
}

class EmailSummaryRepository {
  const EmailSummaryRepository._();

  /// Returns a list of [EmailSummary]s matching the given query parameters.
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
  Future<List<EmailSummary>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailSummaryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailSummaryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailSummaryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<EmailSummary>(
      where: where?.call(EmailSummary.t),
      orderBy: orderBy?.call(EmailSummary.t),
      orderByList: orderByList?.call(EmailSummary.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [EmailSummary] matching the given query parameters.
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
  Future<EmailSummary?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailSummaryTable>? where,
    int? offset,
    _i1.OrderByBuilder<EmailSummaryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailSummaryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<EmailSummary>(
      where: where?.call(EmailSummary.t),
      orderBy: orderBy?.call(EmailSummary.t),
      orderByList: orderByList?.call(EmailSummary.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [EmailSummary] by its [id] or null if no such row exists.
  Future<EmailSummary?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<EmailSummary>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [EmailSummary]s in the list and returns the inserted rows.
  ///
  /// The returned [EmailSummary]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<EmailSummary>> insert(
    _i1.Session session,
    List<EmailSummary> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<EmailSummary>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [EmailSummary] and returns the inserted row.
  ///
  /// The returned [EmailSummary] will have its `id` field set.
  Future<EmailSummary> insertRow(
    _i1.Session session,
    EmailSummary row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailSummary>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [EmailSummary]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<EmailSummary>> update(
    _i1.Session session,
    List<EmailSummary> rows, {
    _i1.ColumnSelections<EmailSummaryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EmailSummary>(
      rows,
      columns: columns?.call(EmailSummary.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailSummary]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmailSummary> updateRow(
    _i1.Session session,
    EmailSummary row, {
    _i1.ColumnSelections<EmailSummaryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmailSummary>(
      row,
      columns: columns?.call(EmailSummary.t),
      transaction: transaction,
    );
  }

  /// Deletes all [EmailSummary]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<EmailSummary>> delete(
    _i1.Session session,
    List<EmailSummary> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmailSummary>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [EmailSummary].
  Future<EmailSummary> deleteRow(
    _i1.Session session,
    EmailSummary row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailSummary>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<EmailSummary>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EmailSummaryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EmailSummary>(
      where: where(EmailSummary.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailSummaryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EmailSummary>(
      where: where?.call(EmailSummary.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

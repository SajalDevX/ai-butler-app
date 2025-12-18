/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Email Summary - AI-processed email data
/// Stores email metadata and AI analysis results
abstract class EmailSummary implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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

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

/// Capture model - stores all captured content (screenshots, photos, voice, links)
abstract class Capture implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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

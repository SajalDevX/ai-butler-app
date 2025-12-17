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

/// AIProcessingResult - result from Gemini AI processing
abstract class AIProcessingResult
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  AIProcessingResult._({
    this.extractedText,
    this.description,
    required this.tags,
    required this.category,
    required this.isReminder,
    this.actionItems,
  });

  factory AIProcessingResult({
    String? extractedText,
    String? description,
    required List<String> tags,
    required String category,
    required bool isReminder,
    List<String>? actionItems,
  }) = _AIProcessingResultImpl;

  factory AIProcessingResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return AIProcessingResult(
      extractedText: jsonSerialization['extractedText'] as String?,
      description: jsonSerialization['description'] as String?,
      tags:
          (jsonSerialization['tags'] as List).map((e) => e as String).toList(),
      category: jsonSerialization['category'] as String,
      isReminder: jsonSerialization['isReminder'] as bool,
      actionItems: (jsonSerialization['actionItems'] as List?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  /// Extracted text from the content
  String? extractedText;

  /// AI-generated description
  String? description;

  /// List of relevant tags
  List<String> tags;

  /// Detected category
  String category;

  /// Whether this appears to be a reminder
  bool isReminder;

  /// Detected action items (for voice notes)
  List<String>? actionItems;

  /// Returns a shallow copy of this [AIProcessingResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AIProcessingResult copyWith({
    String? extractedText,
    String? description,
    List<String>? tags,
    String? category,
    bool? isReminder,
    List<String>? actionItems,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (extractedText != null) 'extractedText': extractedText,
      if (description != null) 'description': description,
      'tags': tags.toJson(),
      'category': category,
      'isReminder': isReminder,
      if (actionItems != null) 'actionItems': actionItems?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (extractedText != null) 'extractedText': extractedText,
      if (description != null) 'description': description,
      'tags': tags.toJson(),
      'category': category,
      'isReminder': isReminder,
      if (actionItems != null) 'actionItems': actionItems?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AIProcessingResultImpl extends AIProcessingResult {
  _AIProcessingResultImpl({
    String? extractedText,
    String? description,
    required List<String> tags,
    required String category,
    required bool isReminder,
    List<String>? actionItems,
  }) : super._(
          extractedText: extractedText,
          description: description,
          tags: tags,
          category: category,
          isReminder: isReminder,
          actionItems: actionItems,
        );

  /// Returns a shallow copy of this [AIProcessingResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AIProcessingResult copyWith({
    Object? extractedText = _Undefined,
    Object? description = _Undefined,
    List<String>? tags,
    String? category,
    bool? isReminder,
    Object? actionItems = _Undefined,
  }) {
    return AIProcessingResult(
      extractedText:
          extractedText is String? ? extractedText : this.extractedText,
      description: description is String? ? description : this.description,
      tags: tags ?? this.tags.map((e0) => e0).toList(),
      category: category ?? this.category,
      isReminder: isReminder ?? this.isReminder,
      actionItems: actionItems is List<String>?
          ? actionItems
          : this.actionItems?.map((e0) => e0).toList(),
    );
  }
}

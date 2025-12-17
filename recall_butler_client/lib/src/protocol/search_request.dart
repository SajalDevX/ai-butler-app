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

/// SearchRequest - DTO for search queries
abstract class SearchRequest implements _i1.SerializableModel {
  SearchRequest._({
    required this.query,
    this.category,
    this.type,
    this.fromDate,
    this.toDate,
    this.limit,
    this.offset,
  });

  factory SearchRequest({
    required String query,
    String? category,
    String? type,
    DateTime? fromDate,
    DateTime? toDate,
    int? limit,
    int? offset,
  }) = _SearchRequestImpl;

  factory SearchRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return SearchRequest(
      query: jsonSerialization['query'] as String,
      category: jsonSerialization['category'] as String?,
      type: jsonSerialization['type'] as String?,
      fromDate: jsonSerialization['fromDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['fromDate']),
      toDate: jsonSerialization['toDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['toDate']),
      limit: jsonSerialization['limit'] as int?,
      offset: jsonSerialization['offset'] as int?,
    );
  }

  /// Natural language search query
  String query;

  /// Optional category filter
  String? category;

  /// Optional type filter
  String? type;

  /// Optional date range start
  DateTime? fromDate;

  /// Optional date range end
  DateTime? toDate;

  /// Number of results to return
  int? limit;

  /// Offset for pagination
  int? offset;

  /// Returns a shallow copy of this [SearchRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SearchRequest copyWith({
    String? query,
    String? category,
    String? type,
    DateTime? fromDate,
    DateTime? toDate,
    int? limit,
    int? offset,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'query': query,
      if (category != null) 'category': category,
      if (type != null) 'type': type,
      if (fromDate != null) 'fromDate': fromDate?.toJson(),
      if (toDate != null) 'toDate': toDate?.toJson(),
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SearchRequestImpl extends SearchRequest {
  _SearchRequestImpl({
    required String query,
    String? category,
    String? type,
    DateTime? fromDate,
    DateTime? toDate,
    int? limit,
    int? offset,
  }) : super._(
          query: query,
          category: category,
          type: type,
          fromDate: fromDate,
          toDate: toDate,
          limit: limit,
          offset: offset,
        );

  /// Returns a shallow copy of this [SearchRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SearchRequest copyWith({
    String? query,
    Object? category = _Undefined,
    Object? type = _Undefined,
    Object? fromDate = _Undefined,
    Object? toDate = _Undefined,
    Object? limit = _Undefined,
    Object? offset = _Undefined,
  }) {
    return SearchRequest(
      query: query ?? this.query,
      category: category is String? ? category : this.category,
      type: type is String? ? type : this.type,
      fromDate: fromDate is DateTime? ? fromDate : this.fromDate,
      toDate: toDate is DateTime? ? toDate : this.toDate,
      limit: limit is int? ? limit : this.limit,
      offset: offset is int? ? offset : this.offset,
    );
  }
}

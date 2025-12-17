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

/// SearchQuery - analytics tracking for user searches
abstract class SearchQuery implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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

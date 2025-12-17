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

/// CaptureCollection - join table for many-to-many relationship
abstract class CaptureCollection implements _i1.SerializableModel {
  CaptureCollection._({
    this.id,
    required this.captureId,
    required this.collectionId,
    required this.addedAt,
  });

  factory CaptureCollection({
    int? id,
    required int captureId,
    required int collectionId,
    required DateTime addedAt,
  }) = _CaptureCollectionImpl;

  factory CaptureCollection.fromJson(Map<String, dynamic> jsonSerialization) {
    return CaptureCollection(
      id: jsonSerialization['id'] as int?,
      captureId: jsonSerialization['captureId'] as int,
      collectionId: jsonSerialization['collectionId'] as int,
      addedAt: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['addedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Foreign key to capture
  int captureId;

  /// Foreign key to collection
  int collectionId;

  /// When the capture was added to the collection
  DateTime addedAt;

  /// Returns a shallow copy of this [CaptureCollection]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CaptureCollection copyWith({
    int? id,
    int? captureId,
    int? collectionId,
    DateTime? addedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'captureId': captureId,
      'collectionId': collectionId,
      'addedAt': addedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CaptureCollectionImpl extends CaptureCollection {
  _CaptureCollectionImpl({
    int? id,
    required int captureId,
    required int collectionId,
    required DateTime addedAt,
  }) : super._(
          id: id,
          captureId: captureId,
          collectionId: collectionId,
          addedAt: addedAt,
        );

  /// Returns a shallow copy of this [CaptureCollection]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CaptureCollection copyWith({
    Object? id = _Undefined,
    int? captureId,
    int? collectionId,
    DateTime? addedAt,
  }) {
    return CaptureCollection(
      id: id is int? ? id : this.id,
      captureId: captureId ?? this.captureId,
      collectionId: collectionId ?? this.collectionId,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}

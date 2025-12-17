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

/// CaptureRequest - DTO for creating a new capture
abstract class CaptureRequest
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  CaptureRequest._({
    required this.type,
    this.fileData,
    this.url,
    this.sourceApp,
  });

  factory CaptureRequest({
    required String type,
    String? fileData,
    String? url,
    String? sourceApp,
  }) = _CaptureRequestImpl;

  factory CaptureRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return CaptureRequest(
      type: jsonSerialization['type'] as String,
      fileData: jsonSerialization['fileData'] as String?,
      url: jsonSerialization['url'] as String?,
      sourceApp: jsonSerialization['sourceApp'] as String?,
    );
  }

  /// Type of capture: screenshot, photo, voice, link
  String type;

  /// Base64 encoded file data (for images/voice)
  String? fileData;

  /// URL for link captures
  String? url;

  /// Source app where capture originated
  String? sourceApp;

  /// Returns a shallow copy of this [CaptureRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CaptureRequest copyWith({
    String? type,
    String? fileData,
    String? url,
    String? sourceApp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      if (fileData != null) 'fileData': fileData,
      if (url != null) 'url': url,
      if (sourceApp != null) 'sourceApp': sourceApp,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'type': type,
      if (fileData != null) 'fileData': fileData,
      if (url != null) 'url': url,
      if (sourceApp != null) 'sourceApp': sourceApp,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CaptureRequestImpl extends CaptureRequest {
  _CaptureRequestImpl({
    required String type,
    String? fileData,
    String? url,
    String? sourceApp,
  }) : super._(
          type: type,
          fileData: fileData,
          url: url,
          sourceApp: sourceApp,
        );

  /// Returns a shallow copy of this [CaptureRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CaptureRequest copyWith({
    String? type,
    Object? fileData = _Undefined,
    Object? url = _Undefined,
    Object? sourceApp = _Undefined,
  }) {
    return CaptureRequest(
      type: type ?? this.type,
      fileData: fileData is String? ? fileData : this.fileData,
      url: url is String? ? url : this.url,
      sourceApp: sourceApp is String? ? sourceApp : this.sourceApp,
    );
  }
}

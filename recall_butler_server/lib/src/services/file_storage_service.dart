import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:serverpod/serverpod.dart';

/// Service for handling file storage operations
class FileStorageService {
  static const String _storagePath = 'public';
  static const int _thumbnailSize = 300;

  /// Upload a capture file and return URLs for original and thumbnail
  static Future<Map<String, String>> uploadCaptureFile(
    Session session,
    int captureId,
    Uint8List bytes,
    String type,
  ) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = _getExtension(type);

    // Upload original file
    final originalPath = 'captures/$captureId/original_$timestamp$extension';
    await session.storage.storeFile(
      storageId: _storagePath,
      path: originalPath,
      byteData: ByteData.view(bytes.buffer),
    );

    final originalUri = await session.storage.getPublicUrl(
      storageId: _storagePath,
      path: originalPath,
    );
    final originalUrl = originalUri?.toString();

    String? thumbnailUrl;

    // Create thumbnail for images
    if (type == 'screenshot' || type == 'photo') {
      try {
        final thumbnail = await _createThumbnail(bytes);
        if (thumbnail != null) {
          final thumbPath = 'captures/$captureId/thumb_$timestamp.jpg';
          await session.storage.storeFile(
            storageId: _storagePath,
            path: thumbPath,
            byteData: ByteData.view(thumbnail.buffer),
          );

          final thumbUri = await session.storage.getPublicUrl(
            storageId: _storagePath,
            path: thumbPath,
          );
          thumbnailUrl = thumbUri?.toString();
        }
      } catch (e) {
        session.log('Failed to create thumbnail: $e', level: LogLevel.warning);
      }
    }

    return {
      'original': originalUrl ?? '',
      'thumbnail': thumbnailUrl ?? originalUrl ?? '',
    };
  }

  /// Create a thumbnail from image bytes
  static Future<Uint8List?> _createThumbnail(Uint8List bytes) async {
    try {
      final image = img.decodeImage(bytes);
      if (image == null) return null;

      // Calculate new dimensions maintaining aspect ratio
      int width, height;
      if (image.width > image.height) {
        width = _thumbnailSize;
        height = (image.height * _thumbnailSize / image.width).round();
      } else {
        height = _thumbnailSize;
        width = (image.width * _thumbnailSize / image.height).round();
      }

      // Resize image
      final resized = img.copyResize(image, width: width, height: height);

      // Encode as JPEG with quality 80
      return Uint8List.fromList(img.encodeJpg(resized, quality: 80));
    } catch (e) {
      return null;
    }
  }

  /// Delete a file from storage
  static Future<void> deleteFile(Session session, String url) async {
    try {
      // Extract path from URL
      final uri = Uri.parse(url);
      final path = uri.pathSegments.skip(1).join('/');

      await session.storage.deleteFile(
        storageId: _storagePath,
        path: path,
      );
    } catch (e) {
      session.log('Failed to delete file: $e', level: LogLevel.warning);
    }
  }

  /// Get file extension based on capture type
  static String _getExtension(String type) {
    switch (type) {
      case 'screenshot':
      case 'photo':
        return '.jpg';
      case 'voice':
        return '.wav';
      default:
        return '';
    }
  }

  /// Check if a file exists in storage
  static Future<bool> fileExists(Session session, String path) async {
    try {
      return await session.storage.fileExists(
        storageId: _storagePath,
        path: path,
      );
    } catch (e) {
      return false;
    }
  }
}

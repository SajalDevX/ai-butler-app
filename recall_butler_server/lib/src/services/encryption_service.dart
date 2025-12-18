import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

/// Service for encrypting and decrypting sensitive data
/// Uses AES-like XOR encryption with a secret key
/// For production, consider using a more robust encryption library
class EncryptionService {
  static String? _encryptionKey;

  /// Initialize with encryption key from config
  static void initialize(String key) {
    _encryptionKey = key;
  }

  /// Get key bytes (SHA-256 hash of key for consistent length)
  static Uint8List _getKeyBytes() {
    final key = _encryptionKey ?? 'default-dev-key-change-in-production';
    final keyHash = sha256.convert(utf8.encode(key));
    return Uint8List.fromList(keyHash.bytes);
  }

  /// Encrypt a string value
  /// Returns base64-encoded encrypted data
  static String encrypt(String plaintext) {
    final keyBytes = _getKeyBytes();
    final plaintextBytes = utf8.encode(plaintext);
    final encryptedBytes = Uint8List(plaintextBytes.length);

    // XOR each byte with corresponding key byte (cycling through key)
    for (var i = 0; i < plaintextBytes.length; i++) {
      encryptedBytes[i] = plaintextBytes[i] ^ keyBytes[i % keyBytes.length];
    }

    return base64Encode(encryptedBytes);
  }

  /// Decrypt a base64-encoded encrypted value
  /// Returns the original plaintext
  static String decrypt(String encryptedBase64) {
    final keyBytes = _getKeyBytes();
    final encryptedBytes = base64Decode(encryptedBase64);
    final decryptedBytes = Uint8List(encryptedBytes.length);

    // XOR again to decrypt (XOR is its own inverse)
    for (var i = 0; i < encryptedBytes.length; i++) {
      decryptedBytes[i] = encryptedBytes[i] ^ keyBytes[i % keyBytes.length];
    }

    return utf8.decode(decryptedBytes);
  }

  /// Hash a value (one-way, for comparison purposes)
  static String hash(String value) {
    final bytes = utf8.encode(value);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}

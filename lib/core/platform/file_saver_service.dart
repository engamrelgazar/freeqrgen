import 'dart:typed_data';

/// Abstract interface for file saver service
abstract class FileSaverService {
  /// Save file to device
  /// Returns true if successful, false otherwise
  Future<bool> saveFile({
    required Uint8List bytes,
    required String fileName,
    String? mimeType,
  });

  /// Check if storage permission is granted
  Future<bool> hasStoragePermission();

  /// Request storage permission
  Future<bool> requestStoragePermission();

  /// Get default save directory (if applicable)
  Future<String?> getDefaultSaveDirectory();
}

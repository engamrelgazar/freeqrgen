import 'dart:typed_data';

/// Abstract interface for file picker service
abstract class FilePickerService {
  /// Pick an image file from gallery or file system
  Future<Uint8List?> pickImage();

  /// Pick multiple image files
  Future<List<Uint8List>?> pickMultipleImages();

  /// Pick any file
  Future<Uint8List?> pickFile({List<String>? allowedExtensions});
}

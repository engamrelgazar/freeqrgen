import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:freeqrgen/core/platform/file_picker_service.dart';

/// Implementation of file picker service using file_picker package
class FilePickerServiceImpl implements FilePickerService {
  @override
  Future<Uint8List?> pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        return file.bytes ?? await _readFileBytes(file);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Uint8List>?> pickMultipleImages() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final List<Uint8List> images = [];
        for (final file in result.files) {
          final bytes = file.bytes ?? await _readFileBytes(file);
          if (bytes != null) {
            images.add(bytes);
          }
        }
        return images.isNotEmpty ? images : null;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Uint8List?> pickFile({List<String>? allowedExtensions}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: allowedExtensions != null
            ? FileType.custom
            : FileType.any,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        return file.bytes ?? await _readFileBytes(file);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Read file bytes (for platforms that don't provide bytes directly)
  Future<Uint8List?> _readFileBytes(PlatformFile file) async {
    try {
      if (file.path != null) {
        // For mobile/desktop platforms
        final fileData = await file.xFile.readAsBytes();
        return fileData;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

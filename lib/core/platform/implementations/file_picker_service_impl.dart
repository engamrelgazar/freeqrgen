import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:freeqrgen/core/platform/file_picker_service.dart';

/// Implementation of file picker service using file_picker package
class FilePickerServiceImpl implements FilePickerService {
  @override
  Future<Uint8List?> pickImage() async {
    try {
      print('FilePickerServiceImpl.pickImage: Opening file picker...');
      
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      print('FilePickerServiceImpl.pickImage: Result = ${result != null ? "got files" : "null"}');

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        print('FilePickerServiceImpl.pickImage: File name = ${file.name}, size = ${file.size}');
        
        final bytes = file.bytes ?? await _readFileBytes(file);
        print('FilePickerServiceImpl.pickImage: Got ${bytes?.length ?? 0} bytes');
        return bytes;
      }
      print('FilePickerServiceImpl.pickImage: User cancelled or no file selected');
      return null;
    } catch (e) {
      print('FilePickerServiceImpl.pickImage error: $e');
      rethrow;
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
      print('_readFileBytes: Reading from path = ${file.path}');
      
      if (file.path != null) {
        // For mobile/desktop platforms
        final fileData = await file.xFile.readAsBytes();
        print('_readFileBytes: Read ${fileData.length} bytes');
        return fileData;
      }
      print('_readFileBytes: No path available');
      return null;
    } catch (e) {
      print('_readFileBytes error: $e');
      rethrow;
    }
  }
}

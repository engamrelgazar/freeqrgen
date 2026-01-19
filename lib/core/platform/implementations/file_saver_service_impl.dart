import 'dart:typed_data';
import 'dart:io' show File;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:freeqrgen/core/platform/file_saver_service.dart';
import 'package:freeqrgen/core/utils/platform_utils.dart';

/// Implementation of file saver service
class FileSaverServiceImpl implements FileSaverService {
  @override
  Future<bool> saveFile({
    required Uint8List bytes,
    required String fileName,
    String? mimeType,
  }) async {
    try {
      if (PlatformUtils.isWeb) {
        return await _saveFileWeb(bytes, fileName);
      } else if (PlatformUtils.isMobile) {
        return await _saveFileMobile(bytes, fileName);
      } else if (PlatformUtils.isDesktop) {
        return await _saveFileDesktop(bytes, fileName);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> hasStoragePermission() async {
    if (!PlatformUtils.requiresStoragePermission) {
      return true;
    }

    final status = await Permission.storage.status;
    return status.isGranted;
  }

  @override
  Future<bool> requestStoragePermission() async {
    if (!PlatformUtils.requiresStoragePermission) {
      return true;
    }

    final status = await Permission.storage.request();
    return status.isGranted;
  }

  @override
  Future<String?> getDefaultSaveDirectory() async {
    if (PlatformUtils.isWeb) {
      return null; // Web doesn't have a file system
    }

    try {
      if (PlatformUtils.isMobile) {
        // For mobile, use downloads directory
        final directory = await getApplicationDocumentsDirectory();
        return directory.path;
      } else if (PlatformUtils.isDesktop) {
        // For desktop, use downloads directory
        final directory = await getDownloadsDirectory();
        return directory?.path;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Save file on web (download via browser)
  Future<bool> _saveFileWeb(Uint8List bytes, String fileName) async {
    try {
      // On web, file_picker can save files via browser download
      final result = await FilePicker.platform.saveFile(
        fileName: fileName,
        bytes: bytes,
      );
      return result != null;
    } catch (e) {
      return false;
    }
  }

  /// Save file on mobile
  Future<bool> _saveFileMobile(Uint8List bytes, String fileName) async {
    try {
      // Check and request permission
      if (!await hasStoragePermission()) {
        final granted = await requestStoragePermission();
        if (!granted) {
          return false;
        }
      }

      // Use file picker to let user choose save location
      final path = await FilePicker.platform.saveFile(
        fileName: fileName,
        bytes: bytes,
      );

      return path != null;
    } catch (e) {
      return false;
    }
  }

  /// Save file on desktop
  Future<bool> _saveFileDesktop(Uint8List bytes, String fileName) async {
    try {
      // Use file picker to show save dialog
      final path = await FilePicker.platform.saveFile(
        fileName: fileName,
        bytes: bytes,
      );

      if (path != null) {
        // Write file to selected path
        final file = File(path);
        await file.writeAsBytes(bytes);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}

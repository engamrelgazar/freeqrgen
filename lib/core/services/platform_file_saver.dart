import 'dart:typed_data';
import 'dart:io' show File;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';
import 'package:freeqrgen/core/utils/platform_utils.dart';
import 'package:freeqrgen/core/constants/export_constants.dart';

/// Platform-aware file saver
/// - Mobile (iOS/Android): Saves to gallery
/// - Desktop (macOS/Windows): Shows file picker dialog
/// - Web: Triggers browser download
class PlatformFileSaver {
  /// Save PNG to appropriate location based on platform
  Future<bool> savePNG({
    required Uint8List bytes,
    String fileName = ExportConstants.defaultPNGFileName,
  }) async {
    try {
      if (PlatformUtils.isWeb) {
        return await _saveFileWeb(bytes, fileName);
      } else if (PlatformUtils.isMobile) {
        return await _saveToGallery(bytes, fileName);
      } else if (PlatformUtils.isDesktop) {
        return await _saveFileDesktop(bytes, fileName, 'PNG Files (*.png)');
      }
      return false;
    } catch (e) {
      print('PlatformFileSaver.savePNG error: $e');
      rethrow;
    }
  }

  /// Save PDF to appropriate location based on platform
  Future<bool> savePDF({
    required Uint8List bytes,
    String fileName = ExportConstants.defaultPDFFileName,
  }) async {
    try {
      if (PlatformUtils.isWeb) {
        return await _saveFileWeb(bytes, fileName);
      } else if (PlatformUtils.isMobile) {
        return await _saveToGallery(bytes, fileName);
      } else if (PlatformUtils.isDesktop) {
        return await _saveFileDesktop(bytes, fileName, 'PDF Files (*.pdf)');
      }
      return false;
    } catch (e) {
      print('PlatformFileSaver.savePDF error: $e');
      rethrow;
    }
  }

  /// Save file on web (browser download)
  Future<bool> _saveFileWeb(Uint8List bytes, String fileName) async {
    try {
      final result = await FilePicker.platform.saveFile(
        fileName: fileName,
        bytes: bytes,
      );
      return result != null;
    } catch (e) {
      return false;
    }
  }

  /// Save to gallery on mobile (iOS/Android)
  Future<bool> _saveToGallery(Uint8List bytes, String fileName) async {
    try {
      print('_saveToGallery: Starting for $fileName');

      // Check if we have permission
      final hasAccess = await Gal.hasAccess();
      print('_saveToGallery: hasAccess = $hasAccess');

      if (!hasAccess) {
        final granted = await Gal.requestAccess();
        print('_saveToGallery: permission granted = $granted');
        if (!granted) {
          throw Exception('Gallery permission denied');
        }
      }

      // Save to temporary file first
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$fileName');
      print('_saveToGallery: Writing to temp file: ${tempFile.path}');
      await tempFile.writeAsBytes(bytes);

      // Save to gallery
      print('_saveToGallery: Saving to gallery...');
      await Gal.putImage(tempFile.path);
      print('_saveToGallery: Successfully saved to gallery');

      // Clean up temp file
      await tempFile.delete();

      return true;
    } catch (e) {
      print('_saveToGallery error: $e');
      rethrow;
    }
  }

  /// Save file on desktop (macOS/Windows) with file picker
  Future<bool> _saveFileDesktop(
    Uint8List bytes,
    String fileName,
    String fileTypeLabel,
  ) async {
    try {
      print('_saveFileDesktop: Opening file picker for $fileName');

      // On desktop, saveFile doesn't work reliably
      // Use getDirectoryPath instead and let user choose directory
      final directoryPath = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Choose where to save QR Code',
      );

      print('_saveFileDesktop: Selected directory = $directoryPath');

      if (directoryPath != null) {
        final file = File('$directoryPath/$fileName');
        print(
          '_saveFileDesktop: Writing ${bytes.length} bytes to ${file.path}',
        );
        await file.writeAsBytes(bytes);
        print('_saveFileDesktop: Successfully saved to ${file.path}');
        return true;
      }
      print('_saveFileDesktop: User cancelled');
      return false;
    } catch (e) {
      print('_saveFileDesktop error: $e');
      rethrow;
    }
  }
}

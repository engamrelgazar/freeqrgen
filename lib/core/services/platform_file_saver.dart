import 'dart:typed_data';
import 'dart:io' show File;
import 'dart:ui' show Rect;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';
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
        // PDF cannot be saved to gallery, save to Documents/Downloads instead
        return await _savePDFToDocuments(bytes, fileName);
      } else if (PlatformUtils.isDesktop) {
        return await _saveFileDesktop(bytes, fileName, 'PDF Files (*.pdf)');
      }
      return false;
    } catch (e) {
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

  /// Save to gallery on mobile (iOS/Android) - Images only
  Future<bool> _saveToGallery(Uint8List bytes, String fileName) async {
    try {
      // Check if we have permission
      final hasAccess = await Gal.hasAccess();

      if (!hasAccess) {
        final granted = await Gal.requestAccess();
        if (!granted) {
          throw Exception('Gallery permission denied');
        }
      }

      // Save to temporary file first
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$fileName');
      await tempFile.writeAsBytes(bytes);

      // Save to gallery (images only)
      await Gal.putImage(tempFile.path);

      // Clean up temp file
      await tempFile.delete();

      return true;
    } catch (e) {
      rethrow;
    }
  }

  /// Save/Share PDF on mobile (iOS/Android)
  /// PDFs cannot be saved to gallery, so we share them using the system share sheet
  /// User can then save to Files app, iCloud, Google Drive, etc.
  Future<bool> _savePDFToDocuments(Uint8List bytes, String fileName) async {
    try {
      // Save to temporary directory first
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/$fileName';

      // Save file
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      // Share the file using system share sheet
      final result = await Share.shareXFiles(
        [XFile(filePath, mimeType: 'application/pdf')],
        text: 'QR Code PDF',
        // Add share position for iPad compatibility
        sharePositionOrigin: const Rect.fromLTWH(0, 0, 1, 1),
      );

      // Return true if shared or dismissed (user saw the options)
      return result.status == ShareResultStatus.success ||
          result.status == ShareResultStatus.dismissed;
    } catch (e) {
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
      // On desktop, saveFile doesn't work reliably
      // Use getDirectoryPath instead and let user choose directory
      final directoryPath = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Choose where to save QR Code',
      );

      if (directoryPath != null) {
        final file = File('$directoryPath/$fileName');
        await file.writeAsBytes(bytes);
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }
}

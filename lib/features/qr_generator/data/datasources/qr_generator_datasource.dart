import 'package:qr/qr.dart';
import 'package:freeqrgen/core/errors/exceptions.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_content.dart';

/// Data source for QR code generation
class QRGeneratorDataSource {
  /// Generate QR code data
  QrCode generateQRData({
    required String data,
    required int errorCorrectionLevel,
  }) {
    try {
      final qrCode = QrCode.fromData(
        data: data,
        errorCorrectLevel: errorCorrectionLevel,
      );
      return qrCode;
    } catch (e) {
      throw QRGenerationException(
        message: 'Failed to generate QR code: ${e.toString()}',
      );
    }
  }

  /// Validate that content can be encoded
  bool validateContent(QRContent content) {
    try {
      final qrString = content.toQRString();
      if (qrString.isEmpty) {
        return false;
      }
      
      // Try to create QR code to ensure it's valid
      QrCode.fromData(
        data: qrString,
        errorCorrectLevel: QrErrorCorrectLevel.M,
      );
      
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Calculate optimal QR version for data
  int calculateOptimalVersion(String data, int errorCorrectionLevel) {
    try {
      final qrCode = QrCode.fromData(
        data: data,
        errorCorrectLevel: errorCorrectionLevel,
      );
      return qrCode.typeNumber;
    } catch (e) {
      return 1;
    }
  }

  /// Get maximum data capacity for given error correction level
  int getMaxDataCapacity(int errorCorrectionLevel) {
    switch (errorCorrectionLevel) {
      case QrErrorCorrectLevel.L:
        return 2953; // Low
      case QrErrorCorrectLevel.M:
        return 2331; // Medium
      case QrErrorCorrectLevel.Q:
        return 1663; // Quartile
      case QrErrorCorrectLevel.H:
        return 1273; // High
      default:
        return 2331;
    }
  }
}

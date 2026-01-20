import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_customization.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_result.dart';

/// Service for exporting QR codes to PNG and PDF
class QRExportService {
  /// Convert QR code to PNG bytes
  Future<Uint8List> exportToPNG({
    required QRResult qrResult,
    required QRCustomization customization,
    int size = 1024,
  }) async {
    try {
      // Decode logo image if present
      ui.Image? logoImage;
      if (customization.hasLogo) {
        logoImage = await decodeImageFromList(customization.logoBytes!);
      }

      // Create QR painter
      final qrPainter = QrPainter(
        data: qrResult.qrString,
        version: QrVersions.auto,
        errorCorrectionLevel: customization.errorCorrectionLevel,
        eyeStyle: QrEyeStyle(
          eyeShape: _mapEyeShape(customization.eyeShape),
          color: customization.effectiveEyeColor,
        ),
        dataModuleStyle: QrDataModuleStyle(
          dataModuleShape: _mapModuleShape(customization.moduleShape),
          color: customization.foregroundColor,
        ),
        embeddedImage: logoImage,
        embeddedImageStyle: logoImage != null
            ? QrEmbeddedImageStyle(
                size: Size(
                  size.toDouble() * customization.logoSizePercent / 100,
                  size.toDouble() * customization.logoSizePercent / 100,
                ),
              )
            : null,
      );

      // Create a picture recorder
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      // Fill background with the customization background color
      final paint = Paint()..color = customization.backgroundColor;
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        paint,
      );

      // Paint QR code
      qrPainter.paint(canvas, Size(size.toDouble(), size.toDouble()));

      // Convert to image
      final picture = recorder.endRecording();
      final uiImage = await picture.toImage(size, size);
      final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception('Failed to convert image to PNG bytes');
      }

      final bytes = byteData.buffer.asUint8List();
      return bytes;
    } catch (e) {
      throw Exception('Failed to export PNG: $e');
    }
  }

  /// Map eye shape
  QrEyeShape _mapEyeShape(QREyeShape eyeShape) {
    switch (eyeShape) {
      case QREyeShape.square:
        return QrEyeShape.square;
      case QREyeShape.rounded:
      case QREyeShape.circular:
        return QrEyeShape.circle;
    }
  }

  /// Map module shape
  QrDataModuleShape _mapModuleShape(QRModuleShape moduleShape) {
    switch (moduleShape) {
      case QRModuleShape.square:
        return QrDataModuleShape.square;
      case QRModuleShape.rounded:
      case QRModuleShape.dots:
        return QrDataModuleShape.circle;
      case QRModuleShape.diamond:
        return QrDataModuleShape.square;
    }
  }

  /// Convert QR code to PDF bytes
  Future<Uint8List> exportToPDF({
    required QRResult qrResult,
    required QRCustomization customization,
  }) async {
    try {
      final pdf = pw.Document();

      // First, generate PNG
      final pngBytes = await exportToPNG(
        qrResult: qrResult,
        customization: customization,
        size: 2048, // High resolution for PDF
      );

      // Create PDF page
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Image(pw.MemoryImage(pngBytes), width: 400, height: 400),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'QR Code',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text('QR Code', style: const pw.TextStyle(fontSize: 12)),
                ],
              ),
            );
          },
        ),
      );

      final pdfBytes = await pdf.save();
      return pdfBytes;
    } catch (e) {
      throw Exception('Failed to export PDF: $e');
    }
  }
}

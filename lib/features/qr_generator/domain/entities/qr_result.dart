import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_content.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_customization.dart';

/// Result of QR code generation
class QRResult extends Equatable {
  final QRContent content;
  final QRCustomization customization;
  final String qrString;
  final Uint8List? imageBytes;

  const QRResult({
    required this.content,
    required this.customization,
    required this.qrString,
    this.imageBytes,
  });

  QRResult copyWith({
    QRContent? content,
    QRCustomization? customization,
    String? qrString,
    Uint8List? imageBytes,
  }) {
    return QRResult(
      content: content ?? this.content,
      customization: customization ?? this.customization,
      qrString: qrString ?? this.qrString,
      imageBytes: imageBytes ?? this.imageBytes,
    );
  }

  @override
  List<Object?> get props => [content, customization, qrString, imageBytes];
}

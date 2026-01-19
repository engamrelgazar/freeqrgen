import 'dart:typed_data';
import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:freeqrgen/core/constants/qr_constants.dart';

/// QR code customization options
class QRCustomization extends Equatable {
  final double size;
  final Color foregroundColor;
  final Color backgroundColor;
  final Color? eyeColor;
  final int errorCorrectionLevel;
  final int margin;
  final QRModuleShape moduleShape;
  final QREyeShape eyeShape;
  final Uint8List? logoBytes;
  final double logoSizePercent;
  final LogoShape logoShape;
  final bool logoContrastBackground;

  const QRCustomization({
    this.size = QRConstants.defaultQRSize,
    this.foregroundColor = const Color(0xFF000000),
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.eyeColor,
    this.errorCorrectionLevel = QRConstants.defaultErrorCorrection,
    this.margin = QRConstants.defaultMargin,
    this.moduleShape = QRModuleShape.square,
    this.eyeShape = QREyeShape.square,
    this.logoBytes,
    this.logoSizePercent = QRConstants.defaultLogoSizePercent,
    this.logoShape = LogoShape.square,
    this.logoContrastBackground = true,
  });

  /// Create a copy with updated fields
  QRCustomization copyWith({
    double? size,
    Color? foregroundColor,
    Color? backgroundColor,
    Color? eyeColor,
    int? errorCorrectionLevel,
    int? margin,
    QRModuleShape? moduleShape,
    QREyeShape? eyeShape,
    Uint8List? logoBytes,
    double? logoSizePercent,
    LogoShape? logoShape,
    bool? logoContrastBackground,
    bool clearLogo = false,
  }) {
    return QRCustomization(
      size: size ?? this.size,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      eyeColor: eyeColor ?? this.eyeColor,
      errorCorrectionLevel: errorCorrectionLevel ?? this.errorCorrectionLevel,
      margin: margin ?? this.margin,
      moduleShape: moduleShape ?? this.moduleShape,
      eyeShape: eyeShape ?? this.eyeShape,
      logoBytes: clearLogo ? null : (logoBytes ?? this.logoBytes),
      logoSizePercent: logoSizePercent ?? this.logoSizePercent,
      logoShape: logoShape ?? this.logoShape,
      logoContrastBackground: logoContrastBackground ?? this.logoContrastBackground,
    );
  }

  /// Check if logo is present
  bool get hasLogo => logoBytes != null;

  /// Get effective eye color (falls back to foreground color)
  Color get effectiveEyeColor => eyeColor ?? foregroundColor;

  @override
  List<Object?> get props => [
        size,
        foregroundColor,
        backgroundColor,
        eyeColor,
        errorCorrectionLevel,
        margin,
        moduleShape,
        eyeShape,
        logoBytes,
        logoSizePercent,
        logoShape,
        logoContrastBackground,
      ];
}

/// QR module (data point) shapes
enum QRModuleShape {
  square,
  rounded,
  dots,
  diamond,
}

extension QRModuleShapeExtension on QRModuleShape {
  String get displayName {
    switch (this) {
      case QRModuleShape.square:
        return 'Square';
      case QRModuleShape.rounded:
        return 'Rounded';
      case QRModuleShape.dots:
        return 'Dots';
      case QRModuleShape.diamond:
        return 'Diamond';
    }
  }
}

/// QR eye (finder pattern) shapes
enum QREyeShape {
  square,
  rounded,
  circular,
}

extension QREyeShapeExtension on QREyeShape {
  String get displayName {
    switch (this) {
      case QREyeShape.square:
        return 'Square';
      case QREyeShape.rounded:
        return 'Rounded';
      case QREyeShape.circular:
        return 'Circular';
    }
  }
}

/// Logo shapes
enum LogoShape {
  square,
  rounded,
  circular,
}

extension LogoShapeExtension on LogoShape {
  String get displayName {
    switch (this) {
      case LogoShape.square:
        return 'Square';
      case LogoShape.rounded:
        return 'Rounded';
      case LogoShape.circular:
        return 'Circular';
    }
  }
}

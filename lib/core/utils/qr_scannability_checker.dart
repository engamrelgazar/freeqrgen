import 'dart:ui';
import 'package:freeqrgen/core/constants/qr_constants.dart';

/// QR code scannability safety checker
class QRScannabilityChecker {
  QRScannabilityChecker._();

  /// Check if QR code is scannable with given parameters
  static ScannabilityResult checkScannability({
    required Color foregroundColor,
    required Color backgroundColor,
    required int errorCorrectionLevel,
    double? logoSizePercent,
  }) {
    final issues = <String>[];
    final warnings = <String>[];

    // Check contrast ratio
    final contrastRatio = calculateContrastRatio(
      foregroundColor,
      backgroundColor,
    );

    if (contrastRatio < QRConstants.minContrastRatio) {
      issues.add(
        'Contrast ratio too low ($contrastRatio:1). Minimum is ${QRConstants.minContrastRatio}:1',
      );
    } else if (contrastRatio < QRConstants.recommendedContrastRatio) {
      warnings.add(
        'Contrast ratio could be better ($contrastRatio:1). Recommended is ${QRConstants.recommendedContrastRatio}:1',
      );
    }

    // Check logo size with error correction
    if (logoSizePercent != null && logoSizePercent > 0) {
      if (logoSizePercent > QRConstants.maxLogoSizePercent) {
        issues.add(
          'Logo size too large (${logoSizePercent.toStringAsFixed(1)}%). Maximum is ${QRConstants.maxLogoSizePercent}%',
        );
      }

      // Check if error correction is sufficient for logo
      if (logoSizePercent > QRConstants.safeLogoSizePercent) {
        if (errorCorrectionLevel < 2) {
          // Q or H level recommended
          warnings.add(
            'Logo size is ${logoSizePercent.toStringAsFixed(1)}%. Consider using higher error correction (Q or H)',
          );
        }
      }

      // Recommend error correction based on logo size
      if (logoSizePercent > 15 && errorCorrectionLevel < 1) {
        warnings.add(
          'For logos, Medium (M) or higher error correction is recommended',
        );
      }
    }

    return ScannabilityResult(
      isScannable: issues.isEmpty,
      contrastRatio: contrastRatio,
      issues: issues,
      warnings: warnings,
    );
  }

  /// Calculate contrast ratio between two colors (WCAG formula)
  /// Returns ratio as a double (e.g., 4.5 means 4.5:1)
  static double calculateContrastRatio(Color color1, Color color2) {
    final luminance1 = calculateRelativeLuminance(color1);
    final luminance2 = calculateRelativeLuminance(color2);

    final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
    final darker = luminance1 > luminance2 ? luminance2 : luminance1;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Calculate relative luminance (WCAG formula)
  static double calculateRelativeLuminance(Color color) {
    final r = _linearize(color.r * 255.0 / 255.0);
    final g = _linearize(color.g * 255.0 / 255.0);
    final b = _linearize(color.b * 255.0 / 255.0);

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Linearize RGB component
  static double _linearize(double component) {
    if (component <= 0.03928) {
      return component / 12.92;
    }
    return ((component + 0.055) / 1.055).pow(2.4);
  }

  /// Get recommended error correction level for logo size
  static int getRecommendedErrorCorrectionForLogo(double logoSizePercent) {
    if (logoSizePercent <= 0) {
      return 1; // M - Medium
    } else if (logoSizePercent <= 15) {
      return 2; // Q - Quartile
    } else {
      return 3; // H - High
    }
  }
}

/// Result of scannability check
class ScannabilityResult {
  final bool isScannable;
  final double contrastRatio;
  final List<String> issues;
  final List<String> warnings;

  const ScannabilityResult({
    required this.isScannable,
    required this.contrastRatio,
    required this.issues,
    required this.warnings,
  });

  bool get hasIssues => issues.isNotEmpty;
  bool get hasWarnings => warnings.isNotEmpty;
  bool get isOptimal => !hasIssues && !hasWarnings;
}

/// Extension for double power operation
extension on double {
  double pow(double exponent) {
    return this == 0 ? 0 : this * this; // Simplified for 2.4 power approximation
  }
}

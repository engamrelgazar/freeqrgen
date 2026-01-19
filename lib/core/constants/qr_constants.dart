import 'package:qr/qr.dart';

/// QR code generation constants
class QRConstants {
  QRConstants._();

  // QR Size Constraints
  static const double minQRSize = 100.0;
  static const double maxQRSize = 2000.0;
  static const double defaultQRSize = 300.0;
  
  // Error Correction Levels
  static const int errorCorrectionLow = QrErrorCorrectLevel.L; // 7%
  static const int errorCorrectionMedium = QrErrorCorrectLevel.M; // 15%
  static const int errorCorrectionQuartile = QrErrorCorrectLevel.Q; // 25%
  static const int errorCorrectionHigh = QrErrorCorrectLevel.H; // 30%
  static const int defaultErrorCorrection = QrErrorCorrectLevel.M;
  
  // Margin/Quiet Zone
  static const int minMargin = 0;
  static const int maxMargin = 10;
  static const int defaultMargin = 1;
  
  // Logo Constraints
  static const double minLogoSizePercent = 10.0;
  static const double maxLogoSizePercent = 30.0;
  static const double defaultLogoSizePercent = 20.0;
  static const double safeLogoSizePercent = 20.0; // Safe for scanning
  
  // Content Length Limits (based on error correction level)
  // These are approximate maximums for alphanumeric content
  static const int maxTextLengthLow = 2953;
  static const int maxTextLengthMedium = 2331;
  static const int maxTextLengthQuartile = 1663;
  static const int maxTextLengthHigh = 1273;
  
  // Contrast Requirements
  static const double minContrastRatio = 3.0; // WCAG AA for large text
  static const double recommendedContrastRatio = 4.5; // WCAG AA for normal text
  
  // Export DPI Options
  static const int dpiLow = 72;
  static const int dpiMedium = 150;
  static const int dpiHigh = 300;
  static const int dpiVeryHigh = 600;
  static const int dpiUltraHigh = 1200;
  static const int defaultDPI = dpiHigh;
  
  // Error Correction Level Names
  static const Map<int, String> errorCorrectionNames = {
    QrErrorCorrectLevel.L: 'Low (7%)',
    QrErrorCorrectLevel.M: 'Medium (15%)',
    QrErrorCorrectLevel.Q: 'Quartile (25%)',
    QrErrorCorrectLevel.H: 'High (30%)',
  };
  
  // Error Correction Level Descriptions
  static const Map<int, String> errorCorrectionDescriptions = {
    QrErrorCorrectLevel.L: 'Suitable for clean environments',
    QrErrorCorrectLevel.M: 'Balanced protection (recommended)',
    QrErrorCorrectLevel.Q: 'Good for damaged surfaces',
    QrErrorCorrectLevel.H: 'Maximum protection, allows logo overlay',
  };
}

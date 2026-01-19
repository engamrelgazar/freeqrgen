/// Export and file operation constants
class ExportConstants {
  ExportConstants._();

  // File Extensions
  static const String pngExtension = '.png';
  static const String pdfExtension = '.pdf';
  
  // Default File Names
  static const String defaultQRFileName = 'qr_code';
  static const String defaultPNGFileName = 'qr_code.png';
  static const String defaultPDFFileName = 'qr_code.pdf';
  
  // MIME Types
  static const String pngMimeType = 'image/png';
  static const String pdfMimeType = 'application/pdf';
  
  // PDF Page Dimensions (A4 in points: 72 points = 1 inch)
  static const double pdfPageWidth = 595.0; // A4 width in points (210mm)
  static const double pdfPageHeight = 842.0; // A4 height in points (297mm)
  static const double pdfMargin = 50.0;
  
  // Export Quality
  static const int pngCompressionQuality = 100; // No compression
  
  // Share Dialog
  static const String shareSubject = 'QR Code';
  static const String shareText = 'Generated with QR Generator';
  
  // Permission Messages
  static const String storagePermissionTitle = 'Storage Permission Required';
  static const String storagePermissionMessage = 
      'Please grant storage permission to save QR codes to your device.';
  static const String storagePermissionDenied = 
      'Storage permission denied. Cannot save file.';
  
  // Success Messages
  static const String exportSuccessMessage = 'QR code exported successfully';
  static const String saveSuccessMessage = 'QR code saved successfully';
  static const String shareSuccessMessage = 'QR code shared successfully';
  
  // Error Messages
  static const String exportErrorMessage = 'Failed to export QR code';
  static const String saveErrorMessage = 'Failed to save QR code';
  static const String shareErrorMessage = 'Failed to share QR code';
}

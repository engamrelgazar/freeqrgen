/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Free Qr Gen';
  static const String appVersion = '1.0.0';

  // Responsive Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Border Radius
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXL = 16.0;
  static const double radiusRound = 999.0;

  // Touch Targets (Accessibility)
  static const double minTouchTarget = 44.0;

  // Layout Dimensions
  static const double maxContentWidth = 1200.0;
  static const double sidebarWidth = 300.0;
  static const double customizationPanelWidth = 350.0;
}

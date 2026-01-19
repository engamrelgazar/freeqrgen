import 'package:flutter/material.dart';

/// Premium Material 3 color schemes for light and dark themes
class AppColorSchemes {
  AppColorSchemes._();

  // Premium Light Theme Color Scheme - Brand blue #1956B4
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF1956B4), // Brand blue - main color
    onPrimary: Color(0xFFFFFFFF), // White text on primary
    primaryContainer: Color(0xFFD6E4F5), // Light blue container
    onPrimaryContainer: Color(0xFF001D3D), // Dark blue for contrast
    secondary: Color(0xFF2563EB), // Complementary blue
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFDBEAFE), // Light blue
    onSecondaryContainer: Color(0xFF1E3A8A), // Dark blue
    tertiary: Color(0xFF0EA5E9), // Sky blue - Accent
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFE0F2FE), // Sky blue light
    onTertiaryContainer: Color(0xFF0C4A6E), // Sky blue dark
    error: Color(0xFFEF4444), // Red-500
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFEE2E2), // Red-100
    onErrorContainer: Color(0xFF7F1D1D), // Red-900
    surface: Color(0xFFFAFAFA), // Gray-50 - Subtle background
    onSurface: Color(0xFF18181B), // Gray-900
    onSurfaceVariant: Color(0xFF52525B), // Gray-600
    outline: Color(0xFFD4D4D8), // Gray-300
    outlineVariant: Color(0xFFE4E4E7), // Gray-200
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF27272A), // Gray-800
    onInverseSurface: Color(0xFFFAFAFA),
    inversePrimary: Color(0xFFA5B4FC), // Indigo-300
    surfaceTint: Color(0xFF6366F1),
  );

  // Premium Dark Theme Color Scheme - Brand blue adapted for dark mode
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF5B9BDF), // Lighter brand blue for dark mode
    onPrimary: Color(0xFFFFFFFF), // White text on primary
    primaryContainer: Color(0xFF1956B4), // Original brand blue
    onPrimaryContainer: Color(0xFFFFFFFF), // White text
    secondary: Color(0xFF60A5FA), // Light blue
    onSecondary: Color(0xFF001D3D), // Dark blue
    secondaryContainer: Color(0xFF1E40AF), // Medium blue
    onSecondaryContainer: Color(0xFFDBEAFE), // Light blue
    tertiary: Color(0xFF38BDF8), // Sky blue
    onTertiary: Color(0xFF0C4A6E), // Dark sky blue
    tertiaryContainer: Color(0xFF0284C7), // Sky blue medium
    onTertiaryContainer: Color(0xFFE0F2FE), // Sky blue light
    error: Color(0xFFFCA5A5), // Red-300
    onError: Color(0xFF7F1D1D), // Red-900
    errorContainer: Color(0xFFDC2626), // Red-600
    onErrorContainer: Color(0xFFFEE2E2), // Red-100
    surface: Color(0xFF18181B), // Gray-900 - Rich dark
    onSurface: Color(0xFFFAFAFA), // Gray-50
    onSurfaceVariant: Color(0xFFA1A1AA), // Gray-400
    outline: Color(0xFF52525B), // Gray-600
    outlineVariant: Color(0xFF3F3F46), // Gray-700
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFFAFAFA), // Gray-50
    onInverseSurface: Color(0xFF18181B), // Gray-900
    inversePrimary: Color(0xFF6366F1), // Indigo-500
    surfaceTint: Color(0xFFA5B4FC),
  );

  // Additional semantic colors
  static const Color success = Color(0xFF10B981); // Emerald-500
  static const Color successLight = Color(0xFFD1FAE5); // Emerald-100
  static const Color successDark = Color(0xFF065F46); // Emerald-800

  static const Color warning = Color(0xFFF59E0B); // Amber-500
  static const Color warningLight = Color(0xFFFEF3C7); // Amber-100
  static const Color warningDark = Color(0xFF92400E); // Amber-800

  static const Color info = Color(0xFF3B82F6); // Blue-500
  static const Color infoLight = Color(0xFFDBEAFE); // Blue-100
  static const Color infoDark = Color(0xFF1E3A8A); // Blue-900

  // Gradient colors for premium effects - based on brand blue
  static const List<Color> primaryGradient = [
    Color(0xFF1956B4), // Brand blue
    Color(0xFF2563EB), // Lighter blue
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFF2563EB), // Blue-600
    Color(0xFF0EA5E9), // Sky-500
  ];

  static const List<Color> accentGradient = [
    Color(0xFF0EA5E9), // Sky-500
    Color(0xFF06B6D4), // Cyan-500
  ];

  // Surface gradients for cards/panels (subtle)
  static const List<Color> surfaceGradientLight = [
    Color(0xFFFFFFFF),
    Color(0xFFFAFAFA),
  ];

  static const List<Color> surfaceGradientDark = [
    Color(0xFF27272A), // Gray-800
    Color(0xFF18181B), // Gray-900
  ];
}

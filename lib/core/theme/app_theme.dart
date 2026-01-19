import 'package:flutter/material.dart';
import 'package:freeqrgen/core/constants/app_constants.dart';
import 'package:freeqrgen/core/theme/color_schemes.dart';
import 'package:freeqrgen/core/theme/theme_extensions.dart';

/// Application theme configuration
class AppTheme {
  AppTheme._();

  /// Light theme with brand color #1956B4
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColorSchemes.lightColorScheme,
      brightness: Brightness.light,

      // Theme extensions for gradients, animations, spacing
      extensions: <ThemeExtension<dynamic>>[
        GradientTheme.light(),
        AnimationTheme.standard(),
        SpacingTheme.standard(),
      ],

      // App Bar Theme - Brand blue background with white text
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: Color(0xFF1956B4), // Brand blue
        foregroundColor: Color(0xFFFFFFFF), // White text/icons
        iconTheme: IconThemeData(color: Color(0xFFFFFFFF)), // White icons
        titleTextStyle: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingM,
          vertical: AppConstants.spacingM,
        ),
      ),

      // Elevated Button Theme - Brand blue background with white text
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1956B4), // Brand blue
          foregroundColor: const Color(0xFFFFFFFF), // White text
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.15),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingL,
            vertical: AppConstants.spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
          minimumSize: const Size(
            AppConstants.minTouchTarget,
            AppConstants.minTouchTarget,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF1956B4), // Brand blue text
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingM,
            vertical: AppConstants.spacingS,
          ),
          minimumSize: const Size(
            AppConstants.minTouchTarget,
            AppConstants.minTouchTarget,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF1956B4), // Brand blue text
          side: const BorderSide(color: Color(0xFF1956B4)), // Brand blue border
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingL,
            vertical: AppConstants.spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
          minimumSize: const Size(
            AppConstants.minTouchTarget,
            AppConstants.minTouchTarget,
          ),
        ),
      ),

      // Icon Button Theme
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(
            AppConstants.minTouchTarget,
            AppConstants.minTouchTarget,
          ),
        ),
      ),

      // Floating Action Button Theme - Brand blue
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF1956B4), // Brand blue
        foregroundColor: Color(0xFFFFFFFF), // White icon
        elevation: 3,
        highlightElevation: 6,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusXL),
        ),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.radiusXL),
          ),
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(space: 1, thickness: 1),
    );
  }

  /// Dark theme with brand color adapted for dark mode
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColorSchemes.darkColorScheme,
      brightness: Brightness.dark,

      // Theme extensions for gradients, animations, spacing
      extensions: <ThemeExtension<dynamic>>[
        GradientTheme.dark(),
        AnimationTheme.standard(),
        SpacingTheme.standard(),
      ],

      // App Bar Theme - Brand blue background with white text
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: Color(0xFF1956B4), // Brand blue
        foregroundColor: Color(0xFFFFFFFF), // White text/icons
        iconTheme: IconThemeData(color: Color(0xFFFFFFFF)), // White icons
        titleTextStyle: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingM,
          vertical: AppConstants.spacingM,
        ),
      ),

      // Elevated Button Theme - Brand blue background with white text
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1956B4), // Brand blue
          foregroundColor: const Color(0xFFFFFFFF), // White text
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingL,
            vertical: AppConstants.spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
          minimumSize: const Size(
            AppConstants.minTouchTarget,
            AppConstants.minTouchTarget,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF5B9BDF), // Lighter blue for dark mode
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingM,
            vertical: AppConstants.spacingS,
          ),
          minimumSize: const Size(
            AppConstants.minTouchTarget,
            AppConstants.minTouchTarget,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF5B9BDF), // Lighter blue for dark mode
          side: const BorderSide(color: Color(0xFF5B9BDF)), // Lighter blue border
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingL,
            vertical: AppConstants.spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
          minimumSize: const Size(
            AppConstants.minTouchTarget,
            AppConstants.minTouchTarget,
          ),
        ),
      ),

      // Icon Button Theme
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(
            AppConstants.minTouchTarget,
            AppConstants.minTouchTarget,
          ),
        ),
      ),

      // Floating Action Button Theme - Brand blue
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF1956B4), // Brand blue
        foregroundColor: Color(0xFFFFFFFF), // White icon
        elevation: 3,
        highlightElevation: 6,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusXL),
        ),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.radiusXL),
          ),
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(space: 1, thickness: 1),
    );
  }
}

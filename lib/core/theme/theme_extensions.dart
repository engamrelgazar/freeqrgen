import 'package:flutter/material.dart';
import 'package:freeqrgen/core/theme/color_schemes.dart';

/// Theme extension for gradients
class GradientTheme extends ThemeExtension<GradientTheme> {
  final LinearGradient primaryGradient;
  final LinearGradient secondaryGradient;
  final LinearGradient accentGradient;
  final LinearGradient surfaceGradient;
  final LinearGradient cardGradient;

  const GradientTheme({
    required this.primaryGradient,
    required this.secondaryGradient,
    required this.accentGradient,
    required this.surfaceGradient,
    required this.cardGradient,
  });

  @override
  GradientTheme copyWith({
    LinearGradient? primaryGradient,
    LinearGradient? secondaryGradient,
    LinearGradient? accentGradient,
    LinearGradient? surfaceGradient,
    LinearGradient? cardGradient,
  }) {
    return GradientTheme(
      primaryGradient: primaryGradient ?? this.primaryGradient,
      secondaryGradient: secondaryGradient ?? this.secondaryGradient,
      accentGradient: accentGradient ?? this.accentGradient,
      surfaceGradient: surfaceGradient ?? this.surfaceGradient,
      cardGradient: cardGradient ?? this.cardGradient,
    );
  }

  @override
  GradientTheme lerp(ThemeExtension<GradientTheme>? other, double t) {
    if (other is! GradientTheme) return this;
    return GradientTheme(
      primaryGradient: LinearGradient.lerp(primaryGradient, other.primaryGradient, t)!,
      secondaryGradient: LinearGradient.lerp(secondaryGradient, other.secondaryGradient, t)!,
      accentGradient: LinearGradient.lerp(accentGradient, other.accentGradient, t)!,
      surfaceGradient: LinearGradient.lerp(surfaceGradient, other.surfaceGradient, t)!,
      cardGradient: LinearGradient.lerp(cardGradient, other.cardGradient, t)!,
    );
  }

  /// Light theme gradients
  static GradientTheme light() {
    return const GradientTheme(
      primaryGradient: LinearGradient(
        colors: AppColorSchemes.primaryGradient,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      secondaryGradient: LinearGradient(
        colors: AppColorSchemes.secondaryGradient,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      accentGradient: LinearGradient(
        colors: AppColorSchemes.accentGradient,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      surfaceGradient: LinearGradient(
        colors: AppColorSchemes.surfaceGradientLight,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      cardGradient: LinearGradient(
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFFFAFAFA),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  /// Dark theme gradients
  static GradientTheme dark() {
    return const GradientTheme(
      primaryGradient: LinearGradient(
        colors: AppColorSchemes.primaryGradient,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      secondaryGradient: LinearGradient(
        colors: AppColorSchemes.secondaryGradient,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      accentGradient: LinearGradient(
        colors: AppColorSchemes.accentGradient,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      surfaceGradient: LinearGradient(
        colors: AppColorSchemes.surfaceGradientDark,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      cardGradient: LinearGradient(
        colors: [
          Color(0xFF27272A),
          Color(0xFF18181B),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }
}

/// Theme extension for animation durations
class AnimationTheme extends ThemeExtension<AnimationTheme> {
  final Duration fast;
  final Duration normal;
  final Duration slow;
  final Curve curve;
  final Curve bounceCurve;

  const AnimationTheme({
    required this.fast,
    required this.normal,
    required this.slow,
    required this.curve,
    required this.bounceCurve,
  });

  @override
  AnimationTheme copyWith({
    Duration? fast,
    Duration? normal,
    Duration? slow,
    Curve? curve,
    Curve? bounceCurve,
  }) {
    return AnimationTheme(
      fast: fast ?? this.fast,
      normal: normal ?? this.normal,
      slow: slow ?? this.slow,
      curve: curve ?? this.curve,
      bounceCurve: bounceCurve ?? this.bounceCurve,
    );
  }

  @override
  AnimationTheme lerp(ThemeExtension<AnimationTheme>? other, double t) {
    if (other is! AnimationTheme) return this;
    return AnimationTheme(
      fast: Duration(milliseconds: (fast.inMilliseconds * (1 - t) + other.fast.inMilliseconds * t).round()),
      normal: Duration(milliseconds: (normal.inMilliseconds * (1 - t) + other.normal.inMilliseconds * t).round()),
      slow: Duration(milliseconds: (slow.inMilliseconds * (1 - t) + other.slow.inMilliseconds * t).round()),
      curve: curve,
      bounceCurve: bounceCurve,
    );
  }

  static AnimationTheme standard() {
    return const AnimationTheme(
      fast: Duration(milliseconds: 150),
      normal: Duration(milliseconds: 250),
      slow: Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      bounceCurve: Curves.elasticOut,
    );
  }
}

/// Theme extension for spacing and sizing
class SpacingTheme extends ThemeExtension<SpacingTheme> {
  final double cardElevation;
  final double cardElevationHover;
  final double borderRadiusSmall;
  final double borderRadiusMedium;
  final double borderRadiusLarge;
  final double borderRadiusXLarge;

  const SpacingTheme({
    required this.cardElevation,
    required this.cardElevationHover,
    required this.borderRadiusSmall,
    required this.borderRadiusMedium,
    required this.borderRadiusLarge,
    required this.borderRadiusXLarge,
  });

  @override
  SpacingTheme copyWith({
    double? cardElevation,
    double? cardElevationHover,
    double? borderRadiusSmall,
    double? borderRadiusMedium,
    double? borderRadiusLarge,
    double? borderRadiusXLarge,
  }) {
    return SpacingTheme(
      cardElevation: cardElevation ?? this.cardElevation,
      cardElevationHover: cardElevationHover ?? this.cardElevationHover,
      borderRadiusSmall: borderRadiusSmall ?? this.borderRadiusSmall,
      borderRadiusMedium: borderRadiusMedium ?? this.borderRadiusMedium,
      borderRadiusLarge: borderRadiusLarge ?? this.borderRadiusLarge,
      borderRadiusXLarge: borderRadiusXLarge ?? this.borderRadiusXLarge,
    );
  }

  @override
  SpacingTheme lerp(ThemeExtension<SpacingTheme>? other, double t) {
    if (other is! SpacingTheme) return this;
    return SpacingTheme(
      cardElevation: cardElevation * (1 - t) + other.cardElevation * t,
      cardElevationHover: cardElevationHover * (1 - t) + other.cardElevationHover * t,
      borderRadiusSmall: borderRadiusSmall * (1 - t) + other.borderRadiusSmall * t,
      borderRadiusMedium: borderRadiusMedium * (1 - t) + other.borderRadiusMedium * t,
      borderRadiusLarge: borderRadiusLarge * (1 - t) + other.borderRadiusLarge * t,
      borderRadiusXLarge: borderRadiusXLarge * (1 - t) + other.borderRadiusXLarge * t,
    );
  }

  static SpacingTheme standard() {
    return const SpacingTheme(
      cardElevation: 2,
      cardElevationHover: 6,
      borderRadiusSmall: 8,
      borderRadiusMedium: 12,
      borderRadiusLarge: 16,
      borderRadiusXLarge: 24,
    );
  }
}

/// Extension to easily access theme extensions
extension ThemeExtensions on BuildContext {
  GradientTheme get gradients => Theme.of(this).extension<GradientTheme>()!;
  AnimationTheme get animations => Theme.of(this).extension<AnimationTheme>()!;
  SpacingTheme get spacing => Theme.of(this).extension<SpacingTheme>()!;
}

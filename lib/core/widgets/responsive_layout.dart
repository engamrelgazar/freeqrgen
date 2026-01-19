import 'package:flutter/material.dart';
import 'package:freeqrgen/core/constants/app_constants.dart';

/// Responsive layout builder that adapts to screen size
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppConstants.tabletBreakpoint) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= AppConstants.mobileBreakpoint) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}

/// Get current screen type
enum ScreenType { mobile, tablet, desktop }

/// Extension to get screen type from BuildContext
extension ResponsiveExtension on BuildContext {
  ScreenType get screenType {
    final width = MediaQuery.of(this).size.width;
    if (width >= AppConstants.tabletBreakpoint) {
      return ScreenType.desktop;
    } else if (width >= AppConstants.mobileBreakpoint) {
      return ScreenType.tablet;
    } else {
      return ScreenType.mobile;
    }
  }

  bool get isMobile => screenType == ScreenType.mobile;
  bool get isTablet => screenType == ScreenType.tablet;
  bool get isDesktop => screenType == ScreenType.desktop;
}

import 'package:flutter/material.dart';

/// Application routing configuration
class AppRouter {
  AppRouter._();

  // Route names
  static const String home = '/';
  static const String qrGenerator = '/qr-generator';

  /// Generate routes
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
      case qrGenerator:
        // Will be implemented when we create the QR generator screen
        return MaterialPageRoute(
          builder: (_) => const Placeholder(), // Temporary
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Route not found'),
            ),
          ),
        );
    }
  }
}

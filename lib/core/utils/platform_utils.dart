import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Platform detection utilities
class PlatformUtils {
  PlatformUtils._();

  /// Check if running on web
  static bool get isWeb => kIsWeb;

  /// Check if running on mobile (Android or iOS)
  static bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  /// Check if running on desktop (Windows, macOS, or Linux)
  static bool get isDesktop =>
      !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);

  /// Check if running on Android
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  /// Check if running on iOS
  static bool get isIOS => !kIsWeb && Platform.isIOS;

  /// Check if running on Windows
  static bool get isWindows => !kIsWeb && Platform.isWindows;

  /// Check if running on macOS
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;

  /// Check if running on Linux
  static bool get isLinux => !kIsWeb && Platform.isLinux;

  /// Get platform name
  static String get platformName {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }

  /// Check if platform supports file system access
  static bool get supportsFileSystem => !kIsWeb;

  /// Check if platform supports native share
  static bool get supportsNativeShare => isMobile;

  /// Check if platform requires storage permissions
  static bool get requiresStoragePermission => isAndroid;
}

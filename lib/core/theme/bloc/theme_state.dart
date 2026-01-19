import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Theme state
class ThemeState extends Equatable {
  final ThemeMode themeMode;

  const ThemeState({required this.themeMode});

  /// Initial state with light theme (ensures predictable toggle behavior)
  factory ThemeState.initial() {
    return const ThemeState(themeMode: ThemeMode.light);
  }

  /// Copy with updated fields
  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(themeMode: themeMode ?? this.themeMode);
  }

  /// Check if current theme is light
  bool get isLight => themeMode == ThemeMode.light;

  /// Check if current theme is dark
  bool get isDark => themeMode == ThemeMode.dark;

  /// Check if using system theme
  bool get isSystem => themeMode == ThemeMode.system;

  @override
  List<Object?> get props => [themeMode];
}

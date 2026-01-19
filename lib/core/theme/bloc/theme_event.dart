import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Base class for Theme events
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

/// Event to toggle theme between light and dark
class ToggleTheme extends ThemeEvent {
  const ToggleTheme();
}

/// Event to set specific theme mode
class SetThemeMode extends ThemeEvent {
  final ThemeMode themeMode;

  const SetThemeMode(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

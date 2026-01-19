import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freeqrgen/core/theme/bloc/theme_event.dart';
import 'package:freeqrgen/core/theme/bloc/theme_state.dart';

/// BLoC for managing app theme
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.initial()) {
    on<ToggleTheme>(_onToggleTheme);
    on<SetThemeMode>(_onSetThemeMode);
  }

  /// Handle theme toggle between light and dark
  void _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) {
    final newThemeMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    emit(state.copyWith(themeMode: newThemeMode));
  }

  /// Handle setting specific theme mode
  void _onSetThemeMode(SetThemeMode event, Emitter<ThemeState> emit) {
    emit(state.copyWith(themeMode: event.themeMode));
  }
}

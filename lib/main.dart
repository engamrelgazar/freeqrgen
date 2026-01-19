import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freeqrgen/core/constants/app_constants.dart';
import 'package:freeqrgen/core/di/injection_container.dart';
import 'package:freeqrgen/core/theme/app_theme.dart';
import 'package:freeqrgen/core/theme/bloc/theme_bloc.dart';
import 'package:freeqrgen/core/theme/bloc/theme_state.dart';
import 'package:freeqrgen/features/splash/presentation/views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await initializeDependencies();

  runApp(const MyApp());
}

/// Main application widget - stateless, uses BLoC for all state management
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeBloc>(
      create: (_) => sl<ThemeBloc>(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

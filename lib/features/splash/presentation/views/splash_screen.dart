import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freeqrgen/core/di/injection_container.dart';
import 'package:freeqrgen/core/theme/color_schemes.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_bloc.dart';
import 'package:freeqrgen/features/qr_generator/presentation/views/qr_generator_screen.dart';

/// Animated splash screen with logo - StatelessWidget with implicit animations
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate after animation completes
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                BlocProvider(
                  create: (_) => sl<QRGeneratorBloc>(),
                  child: const QRGeneratorScreen(),
                ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColorSchemes.lightColorScheme.primary,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated logo with scale and fade
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    // Clamp value to ensure it's always in valid range
                    final clampedValue = value.clamp(0.0, 1.0);
                    return Transform.scale(
                      scale: clampedValue,
                      child: Opacity(opacity: clampedValue, child: child),
                    );
                  },
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.2),
                          blurRadius: 30,
                          offset: Offset(0, 15),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(32),
                    child: Image.asset(
                      'assets/imgs/logo/colored_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 80),

                // Animated loading indicator
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeIn,
                  builder: (context, value, child) {
                    final clampedValue = value.clamp(0.0, 1.0);
                    return Opacity(opacity: clampedValue, child: child);
                  },
                  child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromRGBO(255, 255, 255, 0.8),
                      ),
                      strokeWidth: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freeqrgen/core/constants/app_constants.dart';
import 'package:freeqrgen/core/theme/bloc/theme_bloc.dart';
import 'package:freeqrgen/core/theme/bloc/theme_event.dart';
import 'package:freeqrgen/core/theme/bloc/theme_state.dart';
import 'package:freeqrgen/core/widgets/responsive_layout.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_bloc.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_state.dart';
import 'package:freeqrgen/features/qr_generator/presentation/widgets/qr_preview_panel.dart';
import 'package:freeqrgen/features/qr_generator/presentation/widgets/customization_panel.dart';
import 'package:freeqrgen/features/qr_generator/presentation/views/content_type_selector.dart';
import 'package:freeqrgen/features/qr_generator/presentation/widgets/content_input_forms/content_form_selector.dart';

/// Main QR Generator Screen
class QRGeneratorScreen extends StatelessWidget {
  const QRGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return IconButton(
                icon: Icon(
                  themeState.themeMode == ThemeMode.light
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),
                onPressed: () {
                  context.read<ThemeBloc>().add(const ToggleTheme());
                },
                tooltip: 'Toggle theme',
              );
            },
          ),
          const SizedBox(width: AppConstants.spacingS),
        ],
      ),
      body: BlocListener<QRGeneratorBloc, QRGeneratorState>(
        listener: (context, state) {
          // Show error messages
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        child: ResponsiveLayout(
          mobile: _MobileLayout(),
          tablet: _TabletLayout(),
          desktop: _DesktopLayout(),
        ),
      ),
    );
  }
}

/// Mobile layout (single column, scrollable)
class _MobileLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Content Type Selector
          const ContentTypeSelector(),
          const SizedBox(height: AppConstants.spacingL),

          // Content Input Form
          const ContentFormSelector(),
          const SizedBox(height: AppConstants.spacingL),

          // QR Preview
          const QRPreviewPanel(),
          const SizedBox(height: AppConstants.spacingL),

          // Customization Panel
          const CustomizationPanel(),
        ],
      ),
    );
  }
}

/// Tablet layout (two columns)
class _TabletLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left side: Input
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ContentTypeSelector(),
                const SizedBox(height: AppConstants.spacingL),
                const ContentFormSelector(),
                const SizedBox(height: AppConstants.spacingL),
                const CustomizationPanel(),
              ],
            ),
          ),
        ),

        // Right side: Preview
        Expanded(
          flex: 1,
          child: Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            padding: const EdgeInsets.all(AppConstants.spacingL),
            child: const QRPreviewPanel(),
          ),
        ),
      ],
    );
  }
}

/// Desktop layout (three columns)
class _DesktopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left sidebar: Content input
        SizedBox(
          width: AppConstants.sidebarWidth,
          child: Container(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ContentTypeSelector(),
                  const SizedBox(height: AppConstants.spacingL),
                  const ContentFormSelector(),
                ],
              ),
            ),
          ),
        ),

        // Center: Preview
        Expanded(
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.all(AppConstants.spacingXL),
            child: const Center(child: QRPreviewPanel()),
          ),
        ),

        // Right sidebar: Customization
        SizedBox(
          width: AppConstants.customizationPanelWidth,
          child: Container(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: const SingleChildScrollView(
              padding: EdgeInsets.all(AppConstants.spacingM),
              child: CustomizationPanel(),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:freeqrgen/core/constants/app_constants.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_customization.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_bloc.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_event.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_state.dart';

/// Widget to preview generated QR code with animations
class QRPreviewPanel extends StatelessWidget {
  const QRPreviewPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QRGeneratorBloc, QRGeneratorState>(
      buildWhen: (previous, current) {
        // Only rebuild when QR result, customization, or export status changes
        return previous.qrResult != current.qrResult ||
            previous.customization != current.customization ||
            previous.isExporting != current.isExporting;
      },
      builder: (context, state) {
        return Card(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacingL),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.qr_code_2,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: AppConstants.spacingS),
                      Text(
                        'QR Code Preview',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingL),

                  // Animated QR Code or placeholder
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutBack,
                            ),
                          ),
                          child: child,
                        ),
                      );
                    },
                    child: state.qrResult != null
                        ? _buildQRCode(context, state)
                        : _buildPlaceholder(context),
                  ),

                  const SizedBox(height: AppConstants.spacingL),

                  // Export buttons - responsive layout
                  _buildExportButtons(context, state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQRCode(BuildContext context, QRGeneratorState state) {
    final customization = state.customization;

    return Container(
      key: ValueKey(state.qrResult?.qrString ?? 'qr'),
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: customization.backgroundColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      child: QrImageView(
        data: state.qrResult!.qrString,
        version: QrVersions.auto,
        size: 300,
        backgroundColor: customization.backgroundColor,
        errorCorrectionLevel: customization.errorCorrectionLevel,
        padding: EdgeInsets.all(customization.margin.toDouble() * 4),
        eyeStyle: QrEyeStyle(
          eyeShape: _mapEyeShape(customization.eyeShape),
          color: customization.effectiveEyeColor,
        ),
        dataModuleStyle: QrDataModuleStyle(
          dataModuleShape: _mapModuleShape(customization.moduleShape),
          color: customization.foregroundColor,
        ),
        embeddedImage: customization.hasLogo
            ? MemoryImage(customization.logoBytes!)
            : null,
        embeddedImageStyle: customization.hasLogo
            ? QrEmbeddedImageStyle(
                size: Size(
                  300.0 * customization.logoSizePercent / 100,
                  300.0 * customization.logoSizePercent / 100,
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      key: const ValueKey('placeholder'),
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.qr_code_2,
            size: 80,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppConstants.spacingM),
          Text(
            'Enter content to generate QR code',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  QrEyeShape _mapEyeShape(QREyeShape eyeShape) {
    switch (eyeShape) {
      case QREyeShape.square:
        return QrEyeShape.square;
      case QREyeShape.rounded:
        return QrEyeShape.circle;
      case QREyeShape.circular:
        return QrEyeShape.circle;
    }
  }

  QrDataModuleShape _mapModuleShape(QRModuleShape moduleShape) {
    switch (moduleShape) {
      case QRModuleShape.square:
        return QrDataModuleShape.square;
      case QRModuleShape.rounded:
      case QRModuleShape.dots:
        return QrDataModuleShape.circle;
      case QRModuleShape.diamond:
        return QrDataModuleShape
            .square; // qr_flutter doesn't have diamond, use square
    }
  }

  /// Build export buttons with responsive layout and animations
  Widget _buildExportButtons(BuildContext context, QRGeneratorState state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate if buttons will fit in a row
        // Each button needs ~140px + 16px spacing = ~300px total + some margin
        final bool useColumn = constraints.maxWidth < 360;

        final pngButton = _AnimatedButton(
          onPressed: state.qrResult != null && !state.isExporting
              ? () {
                  context.read<QRGeneratorBloc>().add(const ExportPNG());
                }
              : null,
          icon: state.isExporting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.download),
          label: const Text('Export PNG'),
        );

        final pdfButton = _AnimatedButton(
          onPressed: state.qrResult != null && !state.isExporting
              ? () {
                  context.read<QRGeneratorBloc>().add(const ExportPDF());
                }
              : null,
          icon: state.isExporting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.picture_as_pdf),
          label: const Text('Export PDF'),
        );

        if (useColumn) {
          // Stack buttons vertically on narrow screens
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              pngButton,
              const SizedBox(height: AppConstants.spacingS),
              pdfButton,
            ],
          );
        } else {
          // Display buttons horizontally on wider screens
          return Wrap(
            alignment: WrapAlignment.center,
            spacing: AppConstants.spacingM,
            runSpacing: AppConstants.spacingS,
            children: [pngButton, pdfButton],
          );
        }
      },
    );
  }
}

/// Animated button with press effect
class _AnimatedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final Widget label;

  const _AnimatedButton({
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed != null ? (_) => _controller.forward() : null,
      onTapUp: widget.onPressed != null
          ? (_) {
              _controller.reverse();
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: widget.onPressed != null
          ? () => _controller.reverse()
          : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: ElevatedButton.icon(
          onPressed: widget.onPressed,
          icon: widget.icon,
          label: widget.label,
        ),
      ),
    );
  }
}

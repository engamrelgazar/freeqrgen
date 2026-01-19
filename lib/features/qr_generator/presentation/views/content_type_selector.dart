import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freeqrgen/core/constants/app_constants.dart';
import 'package:freeqrgen/core/theme/theme_extensions.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_content_type.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_bloc.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_event.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_state.dart';

/// Widget to select QR content type with animations
class ContentTypeSelector extends StatelessWidget {
  const ContentTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QRGeneratorBloc, QRGeneratorState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.category,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: AppConstants.spacingS),
                    Text(
                      'Select Content Type',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingM),
                Wrap(
                  spacing: AppConstants.spacingS,
                  runSpacing: AppConstants.spacingS,
                  children: QRContentType.values.map((type) {
                    final isSelected = state.selectedContentType == type;
                    return _AnimatedChoiceChip(
                      label: type.displayName,
                      icon: type.icon,
                      isSelected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          context.read<QRGeneratorBloc>().add(
                                ChangeContentType(type),
                              );
                        }
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Animated choice chip with scale and color transitions
class _AnimatedChoiceChip extends StatefulWidget {
  final String label;
  final String icon;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const _AnimatedChoiceChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  State<_AnimatedChoiceChip> createState() => _AnimatedChoiceChipState();
}

class _AnimatedChoiceChipState extends State<_AnimatedChoiceChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: context.animations.normal,
          curve: context.animations.curve,
          child: ChoiceChip(
            label: Text(widget.label),
            selected: widget.isSelected,
            onSelected: widget.onSelected,
            avatar: widget.isSelected
                ? Icon(
                    Icons.check_circle,
                    size: 18,
                    color: Theme.of(context).colorScheme.onPrimary,
                  )
                : Text(widget.icon),
            selectedColor: Theme.of(context).colorScheme.primary,
            labelStyle: TextStyle(
              color: widget.isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
            elevation: widget.isSelected ? 2 : 0,
            pressElevation: 4,
          ),
        ),
      ),
    );
  }
}

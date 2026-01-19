import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:freeqrgen/core/constants/app_constants.dart';
import 'package:freeqrgen/core/constants/qr_constants.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_customization.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_bloc.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_event.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_state.dart';

/// Widget for QR customization options
class CustomizationPanel extends StatelessWidget {
  const CustomizationPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QRGeneratorBloc, QRGeneratorState>(
      buildWhen: (previous, current) {
        // Only rebuild when customization or logo picking status changes
        return previous.customization != current.customization ||
            previous.isPickingLogo != current.isPickingLogo;
      },
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customization',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppConstants.spacingL),

                // Size slider
                _buildSizeSlider(context, state),
                const SizedBox(height: AppConstants.spacingL),

                // Colors
                _buildColorPickers(context, state),
                const SizedBox(height: AppConstants.spacingL),

                // Error correction
                _buildErrorCorrectionSelector(context, state),
                const SizedBox(height: AppConstants.spacingL),

                // Eye shape
                _buildEyeShapeSelector(context, state),
                const SizedBox(height: AppConstants.spacingL),

                // Module shape
                _buildModuleShapeSelector(context, state),
                const SizedBox(height: AppConstants.spacingL),

                // Eye color
                _buildEyeColorPicker(context, state),
                const SizedBox(height: AppConstants.spacingL),

                // Logo
                _buildLogoSection(context, state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSizeSlider(BuildContext context, QRGeneratorState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Size: ${state.customization.size.toInt()}px',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Slider(
          value: state.customization.size,
          min: QRConstants.minQRSize,
          max: QRConstants.maxQRSize,
          divisions: 38,
          label: '${state.customization.size.toInt()}px',
          onChanged: (value) {
            final updatedCustomization = state.customization.copyWith(
              size: value,
            );
            context.read<QRGeneratorBloc>().add(
              UpdateCustomization(updatedCustomization),
            );
          },
        ),
      ],
    );
  }

  Widget _buildColorPickers(BuildContext context, QRGeneratorState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Colors', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: AppConstants.spacingS),

        // Foreground color
        ListTile(
          title: const Text('Foreground'),
          trailing: ColorIndicator(
            width: 44,
            height: 44,
            borderRadius: AppConstants.radiusM,
            color: state.customization.foregroundColor,
            onSelectFocus: false,
            onSelect: () async {
              final color = await _showColorPicker(
                context,
                state.customization.foregroundColor,
                'Foreground Color',
              );
              if (color != null && context.mounted) {
                final updatedCustomization = state.customization.copyWith(
                  foregroundColor: color,
                );
                context.read<QRGeneratorBloc>().add(
                  UpdateCustomization(updatedCustomization),
                );
              }
            },
          ),
        ),

        // Background color
        ListTile(
          title: const Text('Background'),
          trailing: ColorIndicator(
            width: 44,
            height: 44,
            borderRadius: AppConstants.radiusM,
            color: state.customization.backgroundColor,
            onSelectFocus: false,
            onSelect: () async {
              final color = await _showColorPicker(
                context,
                state.customization.backgroundColor,
                'Background Color',
              );
              if (color != null && context.mounted) {
                final updatedCustomization = state.customization.copyWith(
                  backgroundColor: color,
                );
                context.read<QRGeneratorBloc>().add(
                  UpdateCustomization(updatedCustomization),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildErrorCorrectionSelector(
    BuildContext context,
    QRGeneratorState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Error Correction', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: AppConstants.spacingS),
        LayoutBuilder(
          builder: (context, constraints) {
            // Use compact labels on narrow screens
            final useCompactLabels = constraints.maxWidth < 300;

            return Wrap(
              spacing: AppConstants.spacingS,
              runSpacing: AppConstants.spacingS,
              children: QRConstants.errorCorrectionNames.entries.map((entry) {
                final isSelected =
                    state.customization.errorCorrectionLevel == entry.key;
                final label = useCompactLabels
                    ? entry.value.split(' ')[0] // Just "L", "M", "Q", "H"
                    : entry.value.split(
                        ' (',
                      )[0]; // "Low", "Medium", "Quartile", "High"

                return ChoiceChip(
                  label: Text(label),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      final updatedCustomization = state.customization.copyWith(
                        errorCorrectionLevel: entry.key,
                      );
                      context.read<QRGeneratorBloc>().add(
                        UpdateCustomization(updatedCustomization),
                      );
                    }
                  },
                  tooltip: entry.value, // Show full name on hover
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEyeShapeSelector(BuildContext context, QRGeneratorState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Eye Shape', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: AppConstants.spacingS),
        Wrap(
          spacing: AppConstants.spacingS,
          runSpacing: AppConstants.spacingS,
          children: QREyeShape.values.map((shape) {
            final isSelected = state.customization.eyeShape == shape;
            return ChoiceChip(
              label: Text(shape.displayName),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  final updatedCustomization = state.customization.copyWith(
                    eyeShape: shape,
                  );
                  context.read<QRGeneratorBloc>().add(
                    UpdateCustomization(updatedCustomization),
                  );
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildModuleShapeSelector(
    BuildContext context,
    QRGeneratorState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dot Shape', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: AppConstants.spacingS),
        Wrap(
          spacing: AppConstants.spacingS,
          runSpacing: AppConstants.spacingS,
          children: QRModuleShape.values.map((shape) {
            final isSelected = state.customization.moduleShape == shape;
            return ChoiceChip(
              label: Text(shape.displayName),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  final updatedCustomization = state.customization.copyWith(
                    moduleShape: shape,
                  );
                  context.read<QRGeneratorBloc>().add(
                    UpdateCustomization(updatedCustomization),
                  );
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEyeColorPicker(BuildContext context, QRGeneratorState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Eye Color', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: AppConstants.spacingS),
        Row(
          children: [
            Expanded(
              child: Text(
                state.customization.eyeColor != null
                    ? 'Custom eye color'
                    : 'Same as foreground',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            ColorIndicator(
              width: 44,
              height: 44,
              borderRadius: AppConstants.radiusM,
              color: state.customization.effectiveEyeColor,
              onSelectFocus: false,
              onSelect: () async {
                final color = await _showColorPicker(
                  context,
                  state.customization.effectiveEyeColor,
                  'Eye Color',
                );
                if (color != null && context.mounted) {
                  final updatedCustomization = state.customization.copyWith(
                    eyeColor: color,
                  );
                  context.read<QRGeneratorBloc>().add(
                    UpdateCustomization(updatedCustomization),
                  );
                }
              },
            ),
            if (state.customization.eyeColor != null) ...[
              const SizedBox(width: AppConstants.spacingS),
              IconButton(
                icon: const Icon(Icons.clear, size: 20),
                tooltip: 'Reset to foreground color',
                onPressed: () {
                  final updatedCustomization = state.customization.copyWith(
                    eyeColor: null,
                  );
                  context.read<QRGeneratorBloc>().add(
                    UpdateCustomization(updatedCustomization),
                  );
                },
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildLogoSection(BuildContext context, QRGeneratorState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Logo', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: AppConstants.spacingS),

        if (state.customization.hasLogo) ...[
          // Show logo preview and remove button
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  child: Image.memory(
                    state.customization.logoBytes!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Logo Size: ${state.customization.logoSizePercent.toInt()}%',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Slider(
                      value: state.customization.logoSizePercent,
                      min: QRConstants.minLogoSizePercent,
                      max: QRConstants.maxLogoSizePercent,
                      divisions: 20,
                      label: '${state.customization.logoSizePercent.toInt()}%',
                      onChanged: (value) {
                        final updatedCustomization = state.customization
                            .copyWith(logoSizePercent: value);
                        context.read<QRGeneratorBloc>().add(
                          UpdateCustomization(updatedCustomization),
                        );
                      },
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  context.read<QRGeneratorBloc>().add(const RemoveLogo());
                },
              ),
            ],
          ),
        ] else ...[
          // Show add logo button
          OutlinedButton.icon(
            onPressed: state.isPickingLogo
                ? null
                : () {
                    context.read<QRGeneratorBloc>().add(const PickLogoImage());
                  },
            icon: state.isPickingLogo
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.add_photo_alternate),
            label: Text(state.isPickingLogo ? 'Picking...' : 'Add Logo'),
          ),
        ],
      ],
    );
  }

  Future<Color?> _showColorPicker(
    BuildContext context,
    Color currentColor,
    String title,
  ) async {
    return showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        Color selectedColor = currentColor;
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ColorPicker(
              color: currentColor,
              onColorChanged: (Color color) {
                selectedColor = color;
              },
              width: 40,
              height: 40,
              borderRadius: AppConstants.radiusM,
              spacing: 5,
              runSpacing: 5,
              wheelDiameter: 200,
              heading: Text(
                'Select color',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              subheading: Text(
                'Select color shade',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              wheelSubheading: Text(
                'Selected color and its shades',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              showMaterialName: true,
              showColorName: true,
              showColorCode: true,
              copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                longPressMenu: true,
              ),
              materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
              colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
              colorCodeTextStyle: Theme.of(context).textTheme.bodySmall,
              pickersEnabled: const <ColorPickerType, bool>{
                ColorPickerType.both: false,
                ColorPickerType.primary: true,
                ColorPickerType.accent: true,
                ColorPickerType.bw: false,
                ColorPickerType.custom: false,
                ColorPickerType.wheel: true,
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Select'),
              onPressed: () {
                Navigator.of(context).pop(selectedColor);
              },
            ),
          ],
        );
      },
    );
  }
}

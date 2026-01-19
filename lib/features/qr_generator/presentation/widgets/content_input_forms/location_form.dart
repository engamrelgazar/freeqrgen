import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freeqrgen/core/constants/app_constants.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_content.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_bloc.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_event.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_state.dart';

/// Form for location content input with BLoC-managed validation
class LocationForm extends StatelessWidget {
  const LocationForm({super.key});

  void _updateContent(BuildContext context, QRGeneratorState state) {
    final latField = state.getFieldState('latitude');
    final lngField = state.getFieldState('longitude');

    if (latField.isValid && lngField.isValid && 
        latField.value.isNotEmpty && lngField.value.isNotEmpty) {
      final content = LocationContent(
        latitude: double.parse(latField.value),
        longitude: double.parse(lngField.value),
      );
      context.read<QRGeneratorBloc>().add(UpdateContent(content));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QRGeneratorBloc, QRGeneratorState>(
      builder: (context, state) {
        final latField = state.getFieldState('latitude');
        final lngField = state.getFieldState('longitude');
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: AppConstants.spacingS),
                    Text(
                      'Enter Location',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingM),
                TextField(
                  key: const ValueKey('latitude_field'),
                  decoration: InputDecoration(
                    labelText: 'Latitude *',
                    hintText: '37.7749',
                    helperText: 'Range: -90 to 90',
                    errorText: latField.errorMessage,
                    prefixIcon: const Icon(Icons.north),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  onChanged: (value) {
                    context.read<QRGeneratorBloc>().add(
                      ValidateFormField('latitude', value),
                    );
                    _updateContent(context, state);
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppConstants.spacingM),
                TextField(
                  key: const ValueKey('longitude_field'),
                  decoration: InputDecoration(
                    labelText: 'Longitude *',
                    hintText: '-122.4194',
                    helperText: 'Range: -180 to 180',
                    errorText: lngField.errorMessage,
                    prefixIcon: const Icon(Icons.east),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  onChanged: (value) {
                    context.read<QRGeneratorBloc>().add(
                      ValidateFormField('longitude', value),
                    );
                    _updateContent(context, state);
                  },
                  textInputAction: TextInputAction.done,
                ),
                if (latField.value.isNotEmpty &&
                    lngField.value.isNotEmpty &&
                    latField.isValid &&
                    lngField.isValid)
                  Padding(
                    padding: const EdgeInsets.only(top: AppConstants.spacingM),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                          size: 16,
                        ),
                        const SizedBox(width: AppConstants.spacingXS),
                        Text(
                          'Valid location coordinates',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freeqrgen/core/constants/app_constants.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_content.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_bloc.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_event.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_state.dart';

/// Form for phone content input with BLoC-managed validation
class PhoneForm extends StatelessWidget {
  const PhoneForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QRGeneratorBloc, QRGeneratorState>(
      builder: (context, state) {
        final fieldState = state.getFieldState('phone');
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: AppConstants.spacingS),
                    Text(
                      'Enter Phone Number',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingM),
                TextField(
                  key: const ValueKey('phone_field'),
                  decoration: InputDecoration(
                    labelText: 'Phone Number *',
                    hintText: '+1234567890',
                    helperText: fieldState.errorMessage == null 
                        ? 'Enter phone with country code (+ will be added automatically)'
                        : null,
                    errorText: fieldState.errorMessage,
                    prefixIcon: const Icon(Icons.phone_android),
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    context.read<QRGeneratorBloc>().add(
                      ValidateFormField('phone', value),
                    );
                    
                    final currentState = context.read<QRGeneratorBloc>().state;
                    final phoneField = currentState.getFieldState('phone');
                    if (phoneField.isValid && value.isNotEmpty) {
                      final normalizedPhone = value.startsWith('+') ? value : '+$value';
                      final content = PhoneContent(phone: normalizedPhone);
                      context.read<QRGeneratorBloc>().add(UpdateContent(content));
                    }
                  },
                  textInputAction: TextInputAction.done,
                ),
                if (fieldState.value.isNotEmpty && fieldState.isValid)
                  Padding(
                    padding: const EdgeInsets.only(top: AppConstants.spacingS),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                          size: 16,
                        ),
                        const SizedBox(width: AppConstants.spacingXS),
                        Text(
                          'Valid phone number',
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

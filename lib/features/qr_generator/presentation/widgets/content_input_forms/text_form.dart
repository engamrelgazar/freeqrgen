import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freeqrgen/core/constants/app_constants.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_content.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_bloc.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_event.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_state.dart';

/// Form for text content input with BLoC-managed validation
class TextForm extends StatelessWidget {
  const TextForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QRGeneratorBloc, QRGeneratorState>(
      builder: (context, state) {
        final fieldState = state.getFieldState('text');
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.text_fields,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: AppConstants.spacingS),
                    Text(
                      'Enter Text',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingM),
                TextField(
                  key: const ValueKey('text_field'),
                  decoration: InputDecoration(
                    labelText: 'Text',
                    hintText: 'Enter any text...',
                    helperText: fieldState.errorMessage == null 
                        ? 'This text will be encoded in the QR code (max 500 characters)'
                        : null,
                    errorText: fieldState.errorMessage,
                    prefixIcon: const Icon(Icons.edit),
                  ),
                  maxLines: 5,
                  maxLength: 500,
                  onChanged: (value) {
                    context.read<QRGeneratorBloc>().add(
                      ValidateFormField('text', value),
                    );
                    
                    if (value.isNotEmpty && value.length <= 500) {
                      final content = TextContent(text: value);
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
                          'Valid text input',
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

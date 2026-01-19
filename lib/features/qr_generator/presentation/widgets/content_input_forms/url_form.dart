import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freeqrgen/core/constants/app_constants.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_content.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_bloc.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_event.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_state.dart';

/// Form for URL content input with BLoC-managed validation
class URLForm extends StatelessWidget {
  const URLForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QRGeneratorBloc, QRGeneratorState>(
      builder: (context, state) {
        final fieldState = state.getFieldState('url');
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.link,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: AppConstants.spacingS),
                    Text(
                      'Enter URL',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingM),
                TextField(
                  key: const ValueKey('url_field'),
                  decoration: InputDecoration(
                    labelText: 'URL *',
                    hintText: 'https://example.com',
                    helperText: fieldState.errorMessage == null 
                        ? 'Enter a valid URL (https:// will be added automatically)'
                        : null,
                    errorText: fieldState.errorMessage,
                    prefixIcon: const Icon(Icons.public),
                  ),
                  keyboardType: TextInputType.url,
                  onChanged: (value) {
                    context.read<QRGeneratorBloc>().add(
                      ValidateFormField('url', value),
                    );
                    
                    // Auto-update content if valid
                    final currentState = context.read<QRGeneratorBloc>().state;
                    final urlField = currentState.getFieldState('url');
                    if (urlField.isValid && value.isNotEmpty) {
                      final normalizedUrl = value.startsWith('http') ? value : 'https://$value';
                      final content = URLContent(url: normalizedUrl);
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
                          'Valid URL',
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

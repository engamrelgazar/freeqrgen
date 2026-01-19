import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freeqrgen/core/constants/app_constants.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_content.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_bloc.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_event.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_state.dart';

/// Form for WhatsApp content input with BLoC-managed validation
class WhatsAppForm extends StatelessWidget {
  const WhatsAppForm({super.key});

  void _updateContent(BuildContext context, QRGeneratorState state) {
    final phoneField = state.getFieldState('whatsapp_phone');
    final messageField = state.getFieldState('whatsapp_message');

    if (phoneField.isValid && phoneField.value.isNotEmpty) {
      final normalizedPhone = phoneField.value.startsWith('+') 
          ? phoneField.value 
          : '+${phoneField.value}';
      final content = WhatsAppContent(
        phone: normalizedPhone,
        message: messageField.value.isNotEmpty ? messageField.value : null,
      );
      context.read<QRGeneratorBloc>().add(UpdateContent(content));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QRGeneratorBloc, QRGeneratorState>(
      builder: (context, state) {
        final phoneField = state.getFieldState('whatsapp_phone');
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.chat,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: AppConstants.spacingS),
                    Text(
                      'Enter WhatsApp Details',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingM),
                TextField(
                  key: const ValueKey('whatsapp_phone_field'),
                  decoration: InputDecoration(
                    labelText: 'Phone Number *',
                    hintText: '+1234567890',
                    helperText: 'Include country code',
                    errorText: phoneField.errorMessage,
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    context.read<QRGeneratorBloc>().add(
                      ValidateFormField('whatsapp_phone', value),
                    );
                    _updateContent(context, state);
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppConstants.spacingM),
                TextField(
                  key: const ValueKey('whatsapp_message_field'),
                  decoration: const InputDecoration(
                    labelText: 'Pre-filled Message (Optional)',
                    hintText: 'Enter message',
                    prefixIcon: Icon(Icons.message),
                  ),
                  maxLines: 3,
                  onChanged: (value) {
                    context.read<QRGeneratorBloc>().add(
                      UpdateFormField('whatsapp_message', value),
                    );
                    _updateContent(context, state);
                  },
                  textInputAction: TextInputAction.done,
                ),
                if (phoneField.value.isNotEmpty && phoneField.isValid)
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
                          'Valid WhatsApp link',
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

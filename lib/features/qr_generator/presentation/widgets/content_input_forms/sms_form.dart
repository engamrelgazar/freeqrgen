import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freeqrgen/core/constants/app_constants.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_content.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_bloc.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_event.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_state.dart';

/// Form for SMS content input with BLoC-managed validation
class SMSForm extends StatelessWidget {
  const SMSForm({super.key});

  void _updateContent(BuildContext context, QRGeneratorState state) {
    final phoneField = state.getFieldState('sms_phone');
    final messageField = state.getFieldState('sms_message');

    if (phoneField.isValid && messageField.isValid && 
        phoneField.value.isNotEmpty && messageField.value.isNotEmpty) {
      final normalizedPhone = phoneField.value.startsWith('+') 
          ? phoneField.value 
          : '+${phoneField.value}';
      final content = SMSContent(
        phone: normalizedPhone,
        message: messageField.value,
      );
      context.read<QRGeneratorBloc>().add(UpdateContent(content));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QRGeneratorBloc, QRGeneratorState>(
      builder: (context, state) {
        final phoneField = state.getFieldState('sms_phone');
        final messageField = state.getFieldState('sms_message');
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.sms,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: AppConstants.spacingS),
                    Text(
                      'Enter SMS Details',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingM),
                TextField(
                  key: const ValueKey('sms_phone_field'),
                  decoration: InputDecoration(
                    labelText: 'Phone Number *',
                    hintText: '+1234567890',
                    errorText: phoneField.errorMessage,
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    context.read<QRGeneratorBloc>().add(
                      ValidateFormField('sms_phone', value),
                    );
                    _updateContent(context, state);
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppConstants.spacingM),
                TextField(
                  key: const ValueKey('sms_message_field'),
                  decoration: InputDecoration(
                    labelText: 'Message *',
                    hintText: 'Enter your message',
                    errorText: messageField.errorMessage,
                    prefixIcon: const Icon(Icons.message),
                    helperText: 'Max 160 characters',
                  ),
                  maxLines: 3,
                  maxLength: 160,
                  onChanged: (value) {
                    context.read<QRGeneratorBloc>().add(
                      ValidateFormField('sms_message', value),
                    );
                    _updateContent(context, state);
                  },
                  textInputAction: TextInputAction.done,
                ),
                if (phoneField.value.isNotEmpty &&
                    messageField.value.isNotEmpty &&
                    phoneField.isValid &&
                    messageField.isValid)
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
                          'Valid SMS',
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

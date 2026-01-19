import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freeqrgen/core/constants/app_constants.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_content.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_bloc.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_event.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_state.dart';

/// Form for email content input with BLoC-managed validation
class EmailForm extends StatelessWidget {
  const EmailForm({super.key});

  void _updateContent(BuildContext context, QRGeneratorState state) {
    final emailField = state.getFieldState('email');
    final subjectField = state.getFieldState('email_subject');
    final bodyField = state.getFieldState('email_body');

    if (emailField.isValid && emailField.value.isNotEmpty) {
      final content = EmailContent(
        email: emailField.value,
        subject: subjectField.value.isNotEmpty ? subjectField.value : null,
        body: bodyField.value.isNotEmpty ? bodyField.value : null,
      );
      context.read<QRGeneratorBloc>().add(UpdateContent(content));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QRGeneratorBloc, QRGeneratorState>(
      builder: (context, state) {
        final emailField = state.getFieldState('email');
        final subjectField = state.getFieldState('email_subject');
        final bodyField = state.getFieldState('email_body');
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.email,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: AppConstants.spacingS),
                    Text(
                      'Enter Email',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingM),
                
                // Email field (required)
                TextField(
                  key: const ValueKey('email_field'),
                  decoration: InputDecoration(
                    labelText: 'Email Address *',
                    hintText: 'user@example.com',
                    errorText: emailField.errorMessage,
                    prefixIcon: const Icon(Icons.alternate_email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    context.read<QRGeneratorBloc>().add(
                      ValidateFormField('email', value),
                    );
                    _updateContent(context, state);
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppConstants.spacingM),
                
                // Subject field (optional)
                TextField(
                  key: const ValueKey('email_subject_field'),
                  decoration: InputDecoration(
                    labelText: 'Subject (Optional)',
                    hintText: 'Email subject',
                    errorText: subjectField.errorMessage,
                    prefixIcon: const Icon(Icons.subject),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      context.read<QRGeneratorBloc>().add(
                        ValidateFormField('email_subject', value),
                      );
                    }
                    _updateContent(context, state);
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppConstants.spacingM),
                
                // Body field (optional)
                TextField(
                  key: const ValueKey('email_body_field'),
                  decoration: InputDecoration(
                    labelText: 'Body (Optional)',
                    hintText: 'Email body',
                    errorText: bodyField.errorMessage,
                    prefixIcon: const Icon(Icons.notes),
                  ),
                  maxLines: 3,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      context.read<QRGeneratorBloc>().add(
                        ValidateFormField('email_body', value),
                      );
                    }
                    _updateContent(context, state);
                  },
                  textInputAction: TextInputAction.done,
                ),
                
                // Success indicator
                if (emailField.value.isNotEmpty &&
                    emailField.isValid &&
                    subjectField.isValid &&
                    bodyField.isValid)
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
                          'Valid email input',
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

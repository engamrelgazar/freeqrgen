import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freeqrgen/core/constants/app_constants.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_content.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_bloc.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_event.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_state.dart';

/// Form for contact (vCard) content input with BLoC-managed validation
class ContactForm extends StatelessWidget {
  const ContactForm({super.key});

  void _updateContent(BuildContext context, QRGeneratorState state) {
    final firstNameField = state.getFieldState('contact_first_name');
    final lastNameField = state.getFieldState('contact_last_name');
    final phoneField = state.getFieldState('contact_phone');
    final emailField = state.getFieldState('contact_email');
    final orgField = state.getFieldState('contact_organization');

    if (firstNameField.isValid && firstNameField.value.isNotEmpty) {
      final content = ContactContent(
        firstName: firstNameField.value,
        lastName: lastNameField.value.isNotEmpty ? lastNameField.value : null,
        phone: phoneField.value.isNotEmpty ? phoneField.value : null,
        email: emailField.value.isNotEmpty ? emailField.value : null,
        organization: orgField.value.isNotEmpty ? orgField.value : null,
      );
      context.read<QRGeneratorBloc>().add(UpdateContent(content));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QRGeneratorBloc, QRGeneratorState>(
      builder: (context, state) {
        final firstNameField = state.getFieldState('contact_first_name');
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.contact_page,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: AppConstants.spacingS),
                      Text(
                        'Enter Contact Details',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingM),
                  TextField(
                    key: const ValueKey('contact_first_name_field'),
                    decoration: InputDecoration(
                      labelText: 'First Name *',
                      hintText: 'John',
                      errorText: firstNameField.errorMessage,
                      prefixIcon: const Icon(Icons.person),
                    ),
                    onChanged: (value) {
                      context.read<QRGeneratorBloc>().add(
                        ValidateFormField('contact_first_name', value),
                      );
                      _updateContent(context, state);
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppConstants.spacingM),
                  TextField(
                    key: const ValueKey('contact_last_name_field'),
                    decoration: const InputDecoration(
                      labelText: 'Last Name (Optional)',
                      hintText: 'Doe',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    onChanged: (value) {
                      context.read<QRGeneratorBloc>().add(
                        UpdateFormField('contact_last_name', value),
                      );
                      _updateContent(context, state);
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppConstants.spacingM),
                  TextField(
                    key: const ValueKey('contact_phone_field'),
                    decoration: const InputDecoration(
                      labelText: 'Phone (Optional)',
                      hintText: '+1234567890',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      context.read<QRGeneratorBloc>().add(
                        UpdateFormField('contact_phone', value),
                      );
                      _updateContent(context, state);
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppConstants.spacingM),
                  TextField(
                    key: const ValueKey('contact_email_field'),
                    decoration: const InputDecoration(
                      labelText: 'Email (Optional)',
                      hintText: 'john@example.com',
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      context.read<QRGeneratorBloc>().add(
                        UpdateFormField('contact_email', value),
                      );
                      _updateContent(context, state);
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppConstants.spacingM),
                  TextField(
                    key: const ValueKey('contact_organization_field'),
                    decoration: const InputDecoration(
                      labelText: 'Organization (Optional)',
                      hintText: 'Company Name',
                      prefixIcon: Icon(Icons.business),
                    ),
                    onChanged: (value) {
                      context.read<QRGeneratorBloc>().add(
                        UpdateFormField('contact_organization', value),
                      );
                      _updateContent(context, state);
                    },
                    textInputAction: TextInputAction.done,
                  ),
                  if (firstNameField.value.isNotEmpty && firstNameField.isValid)
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
                            'Valid contact',
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
          ),
        );
      },
    );
  }
}

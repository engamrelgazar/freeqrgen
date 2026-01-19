import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freeqrgen/core/constants/app_constants.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_content.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_bloc.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_event.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_state.dart';

/// Form for WiFi content input with BLoC-managed validation
class WiFiForm extends StatelessWidget {
  const WiFiForm({super.key});

  void _updateContent(
    BuildContext context,
    QRGeneratorState state,
    String securityType,
    bool hidden,
  ) {
    final ssidField = state.getFieldState('wifi_ssid');
    final passwordField = state.getFieldState('wifi_password');

    if (ssidField.isValid && ssidField.value.isNotEmpty) {
      final content = WiFiContent(
        ssid: ssidField.value,
        password: passwordField.value,
        security: securityType,
        hidden: hidden,
      );
      context.read<QRGeneratorBloc>().add(UpdateContent(content));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QRGeneratorBloc, QRGeneratorState>(
      builder: (context, state) {
        final ssidField = state.getFieldState('wifi_ssid');
        final passwordField = state.getFieldState('wifi_password');
        final securityField = state.getFieldState('wifi_security');
        final hiddenField = state.getFieldState('wifi_hidden');
        
        final securityType = securityField.value.isEmpty ? 'WPA' : securityField.value;
        final hidden = hiddenField.value == 'true';
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.wifi,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: AppConstants.spacingS),
                    Text(
                      'Enter WiFi Details',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingM),
                TextField(
                  key: const ValueKey('wifi_ssid_field'),
                  decoration: InputDecoration(
                    labelText: 'Network Name (SSID) *',
                    hintText: 'MyWiFi',
                    errorText: ssidField.errorMessage,
                    prefixIcon: const Icon(Icons.wifi_tethering),
                  ),
                  onChanged: (value) {
                    context.read<QRGeneratorBloc>().add(
                      ValidateFormField('wifi_ssid', value),
                    );
                    _updateContent(context, state, securityType, hidden);
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppConstants.spacingM),
                DropdownButtonFormField<String>(
                  initialValue: securityType,
                  decoration: const InputDecoration(
                    labelText: 'Security Type',
                    prefixIcon: Icon(Icons.security),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'WPA', child: Text('WPA/WPA2')),
                    DropdownMenuItem(value: 'WEP', child: Text('WEP')),
                    DropdownMenuItem(value: 'nopass', child: Text('None (Open)')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      context.read<QRGeneratorBloc>().add(
                        UpdateFormField('wifi_security', value),
                      );
                      _updateContent(context, state, value, hidden);
                    }
                  },
                ),
                const SizedBox(height: AppConstants.spacingM),
                TextField(
                  key: const ValueKey('wifi_password_field'),
                  decoration: InputDecoration(
                    labelText: securityType == 'nopass' 
                        ? 'Password (Not Required)' 
                        : 'Password *',
                    hintText: 'Enter password',
                    errorText: passwordField.errorMessage,
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  obscureText: true,
                  enabled: securityType != 'nopass',
                  onChanged: (value) {
                    context.read<QRGeneratorBloc>().add(
                      UpdateFormField('wifi_password', value),
                    );
                    _updateContent(context, state, securityType, hidden);
                  },
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: AppConstants.spacingM),
                SwitchListTile(
                  title: const Text('Hidden Network'),
                  subtitle: const Text('Enable if network doesn\'t broadcast SSID'),
                  value: hidden,
                  onChanged: (value) {
                    context.read<QRGeneratorBloc>().add(
                      UpdateFormField('wifi_hidden', value.toString()),
                    );
                    _updateContent(context, state, securityType, value);
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                if (ssidField.value.isNotEmpty && ssidField.isValid)
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
                          'Valid WiFi configuration',
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

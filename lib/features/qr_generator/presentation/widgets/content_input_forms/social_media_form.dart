import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freeqrgen/core/constants/app_constants.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_content.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_content_type.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_bloc.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_event.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_state.dart';

/// Form for social media content input with BLoC-managed validation
class SocialMediaForm extends StatelessWidget {
  final QRContentType contentType;
  
  const SocialMediaForm({
    super.key,
    required this.contentType,
  });

  String get _platformName {
    switch (contentType) {
      case QRContentType.instagram:
        return 'Instagram';
      case QRContentType.telegram:
        return 'Telegram';
      case QRContentType.twitter:
        return 'Twitter';
      default:
        return 'Social Media';
    }
  }

  IconData get _platformIcon {
    switch (contentType) {
      case QRContentType.instagram:
        return Icons.camera_alt;
      case QRContentType.telegram:
        return Icons.send;
      case QRContentType.twitter:
        return Icons.tag;
      default:
        return Icons.share;
    }
  }

  String get _fieldKey {
    switch (contentType) {
      case QRContentType.instagram:
        return 'instagram_username';
      case QRContentType.telegram:
        return 'telegram_username';
      case QRContentType.twitter:
        return 'twitter_username';
      default:
        return 'username';
    }
  }

  void _updateContent(BuildContext context, String username) {
    QRContent content;
    switch (contentType) {
      case QRContentType.instagram:
        content = InstagramContent(username: username);
        break;
      case QRContentType.telegram:
        content = TelegramContent(username: username);
        break;
      case QRContentType.twitter:
        content = TwitterContent(username: username);
        break;
      default:
        return;
    }
    context.read<QRGeneratorBloc>().add(UpdateContent(content));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QRGeneratorBloc, QRGeneratorState>(
      builder: (context, state) {
        final fieldState = state.getFieldState(_fieldKey);
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _platformIcon,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: AppConstants.spacingS),
                    Text(
                      'Enter $_platformName Username',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingM),
                TextField(
                  key: ValueKey('${_fieldKey}_field'),
                  decoration: InputDecoration(
                    labelText: 'Username *',
                    hintText: '@username',
                    helperText: fieldState.errorMessage == null 
                        ? 'Enter your $_platformName username'
                        : null,
                    errorText: fieldState.errorMessage,
                    prefixIcon: const Icon(Icons.person),
                  ),
                  onChanged: (value) {
                    context.read<QRGeneratorBloc>().add(
                      ValidateFormField(_fieldKey, value),
                    );
                    
                    if (value.isNotEmpty) {
                      _updateContent(context, value);
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
                          'Valid $_platformName username',
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

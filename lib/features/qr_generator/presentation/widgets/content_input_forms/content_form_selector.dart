import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_content_type.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_bloc.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_state.dart';
import 'package:freeqrgen/features/qr_generator/presentation/widgets/content_input_forms/text_form.dart';
import 'package:freeqrgen/features/qr_generator/presentation/widgets/content_input_forms/email_form.dart';
import 'package:freeqrgen/features/qr_generator/presentation/widgets/content_input_forms/url_form.dart';
import 'package:freeqrgen/features/qr_generator/presentation/widgets/content_input_forms/phone_form.dart';
import 'package:freeqrgen/features/qr_generator/presentation/widgets/content_input_forms/sms_form.dart';
import 'package:freeqrgen/features/qr_generator/presentation/widgets/content_input_forms/wifi_form.dart';
import 'package:freeqrgen/features/qr_generator/presentation/widgets/content_input_forms/contact_form.dart';
import 'package:freeqrgen/features/qr_generator/presentation/widgets/content_input_forms/location_form.dart';
import 'package:freeqrgen/features/qr_generator/presentation/widgets/content_input_forms/calendar_event_form.dart';
import 'package:freeqrgen/features/qr_generator/presentation/widgets/content_input_forms/whatsapp_form.dart';
import 'package:freeqrgen/features/qr_generator/presentation/widgets/content_input_forms/social_media_form.dart';

/// Widget that selects and displays the appropriate content input form
/// based on the currently selected content type
class ContentFormSelector extends StatelessWidget {
  const ContentFormSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QRGeneratorBloc, QRGeneratorState>(
      buildWhen: (previous, current) =>
          previous.selectedContentType != current.selectedContentType,
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.1),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: _buildFormForContentType(state.selectedContentType),
        );
      },
    );
  }

  Widget _buildFormForContentType(QRContentType contentType) {
    // Use a key to ensure AnimatedSwitcher detects the change
    switch (contentType) {
      case QRContentType.text:
        return const TextForm(key: ValueKey('text'));
      case QRContentType.email:
        return const EmailForm(key: ValueKey('email'));
      case QRContentType.url:
        return const URLForm(key: ValueKey('url'));
      case QRContentType.phone:
        return const PhoneForm(key: ValueKey('phone'));
      case QRContentType.sms:
        return const SMSForm(key: ValueKey('sms'));
      case QRContentType.wifi:
        return const WiFiForm(key: ValueKey('wifi'));
      case QRContentType.contact:
        return const ContactForm(key: ValueKey('contact'));
      case QRContentType.location:
        return const LocationForm(key: ValueKey('location'));
      case QRContentType.calendarEvent:
        return const CalendarEventForm(key: ValueKey('calendarEvent'));
      case QRContentType.whatsapp:
        return const WhatsAppForm(key: ValueKey('whatsapp'));
      case QRContentType.instagram:
        return const SocialMediaForm(
          key: ValueKey('instagram'),
          contentType: QRContentType.instagram,
        );
      case QRContentType.telegram:
        return const SocialMediaForm(
          key: ValueKey('telegram'),
          contentType: QRContentType.telegram,
        );
      case QRContentType.twitter:
        return const SocialMediaForm(
          key: ValueKey('twitter'),
          contentType: QRContentType.twitter,
        );
    }
  }
}

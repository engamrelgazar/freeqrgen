/// Enum representing different QR content types
enum QRContentType {
  text,
  url,
  phone,
  email,
  sms,
  wifi,
  contact,
  location,
  calendarEvent,
  whatsapp,
  instagram,
  telegram,
  twitter,
}

/// Extension for QRContentType
extension QRContentTypeExtension on QRContentType {
  String get displayName {
    switch (this) {
      case QRContentType.text:
        return 'Text';
      case QRContentType.url:
        return 'URL';
      case QRContentType.phone:
        return 'Phone';
      case QRContentType.email:
        return 'Email';
      case QRContentType.sms:
        return 'SMS';
      case QRContentType.wifi:
        return 'Wi-Fi';
      case QRContentType.contact:
        return 'Contact';
      case QRContentType.location:
        return 'Location';
      case QRContentType.calendarEvent:
        return 'Calendar Event';
      case QRContentType.whatsapp:
        return 'WhatsApp';
      case QRContentType.instagram:
        return 'Instagram';
      case QRContentType.telegram:
        return 'Telegram';
      case QRContentType.twitter:
        return 'Twitter/X';
    }
  }

  String get description {
    switch (this) {
      case QRContentType.text:
        return 'Plain text message';
      case QRContentType.url:
        return 'Website link';
      case QRContentType.phone:
        return 'Phone number';
      case QRContentType.email:
        return 'Email address';
      case QRContentType.sms:
        return 'SMS message';
      case QRContentType.wifi:
        return 'Wi-Fi credentials';
      case QRContentType.contact:
        return 'Contact information (vCard)';
      case QRContentType.location:
        return 'Geographic location';
      case QRContentType.calendarEvent:
        return 'Calendar event (iCal)';
      case QRContentType.whatsapp:
        return 'WhatsApp chat';
      case QRContentType.instagram:
        return 'Instagram profile';
      case QRContentType.telegram:
        return 'Telegram profile';
      case QRContentType.twitter:
        return 'Twitter/X profile';
    }
  }

  String get icon {
    switch (this) {
      case QRContentType.text:
        return '📝';
      case QRContentType.url:
        return '🌐';
      case QRContentType.phone:
        return '📞';
      case QRContentType.email:
        return '📧';
      case QRContentType.sms:
        return '💬';
      case QRContentType.wifi:
        return '📶';
      case QRContentType.contact:
        return '👤';
      case QRContentType.location:
        return '📍';
      case QRContentType.calendarEvent:
        return '📅';
      case QRContentType.whatsapp:
        return '💚';
      case QRContentType.instagram:
        return '📷';
      case QRContentType.telegram:
        return '✈️';
      case QRContentType.twitter:
        return '🐦';
    }
  }
}

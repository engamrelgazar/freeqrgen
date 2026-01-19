import 'package:equatable/equatable.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_content_type.dart';

/// Base class for QR content
abstract class QRContent extends Equatable {
  final QRContentType type;

  const QRContent({required this.type});

  /// Convert content to QR string
  String toQRString();

  @override
  List<Object?> get props => [type];
}

/// Text content
class TextContent extends QRContent {
  final String text;

  const TextContent({required this.text}) : super(type: QRContentType.text);

  @override
  String toQRString() => text;

  @override
  List<Object?> get props => [type, text];
}

/// URL content
class URLContent extends QRContent {
  final String url;

  const URLContent({required this.url}) : super(type: QRContentType.url);

  @override
  String toQRString() => url;

  @override
  List<Object?> get props => [type, url];
}

/// Phone content
class PhoneContent extends QRContent {
  final String phone;

  const PhoneContent({required this.phone}) : super(type: QRContentType.phone);

  @override
  String toQRString() => 'tel:$phone';

  @override
  List<Object?> get props => [type, phone];
}

/// Email content
class EmailContent extends QRContent {
  final String email;
  final String? subject;
  final String? body;

  const EmailContent({
    required this.email,
    this.subject,
    this.body,
  }) : super(type: QRContentType.email);

  @override
  String toQRString() {
    final buffer = StringBuffer('mailto:$email');
    final params = <String>[];
    
    if (subject != null && subject!.isNotEmpty) {
      params.add('subject=${Uri.encodeComponent(subject!)}');
    }
    if (body != null && body!.isNotEmpty) {
      params.add('body=${Uri.encodeComponent(body!)}');
    }
    
    if (params.isNotEmpty) {
      buffer.write('?${params.join('&')}');
    }
    
    return buffer.toString();
  }

  @override
  List<Object?> get props => [type, email, subject, body];
}

/// SMS content
class SMSContent extends QRContent {
  final String phone;
  final String? message;

  const SMSContent({
    required this.phone,
    this.message,
  }) : super(type: QRContentType.sms);

  @override
  String toQRString() {
    if (message != null && message!.isNotEmpty) {
      return 'smsto:$phone:$message';
    }
    return 'smsto:$phone';
  }

  @override
  List<Object?> get props => [type, phone, message];
}

/// Wi-Fi content
class WiFiContent extends QRContent {
  final String ssid;
  final String password;
  final String security; // WPA, WEP, or nopass
  final bool hidden;

  const WiFiContent({
    required this.ssid,
    required this.password,
    required this.security,
    this.hidden = false,
  }) : super(type: QRContentType.wifi);

  @override
  String toQRString() {
    return 'WIFI:T:$security;S:${_escape(ssid)};P:${_escape(password)};H:$hidden;;';
  }

  String _escape(String value) {
    return value
        .replaceAll('\\', '\\\\')
        .replaceAll(';', '\\;')
        .replaceAll(',', '\\,')
        .replaceAll(':', '\\:')
        .replaceAll('"', '\\"');
  }

  @override
  List<Object?> get props => [type, ssid, password, security, hidden];
}

/// Contact content (vCard)
class ContactContent extends QRContent {
  final String firstName;
  final String? lastName;
  final String? organization;
  final String? title;
  final String? phone;
  final String? email;
  final String? website;
  final String? address;
  final String? note;

  const ContactContent({
    required this.firstName,
    this.lastName,
    this.organization,
    this.title,
    this.phone,
    this.email,
    this.website,
    this.address,
    this.note,
  }) : super(type: QRContentType.contact);

  @override
  String toQRString() {
    final buffer = StringBuffer();
    buffer.writeln('BEGIN:VCARD');
    buffer.writeln('VERSION:3.0');
    
    final fullName = lastName != null ? '$firstName $lastName' : firstName;
    buffer.writeln('FN:$fullName');
    buffer.writeln('N:${lastName ?? ''};$firstName;;;');
    
    if (organization != null && organization!.isNotEmpty) {
      buffer.writeln('ORG:$organization');
    }
    if (title != null && title!.isNotEmpty) {
      buffer.writeln('TITLE:$title');
    }
    if (phone != null && phone!.isNotEmpty) {
      buffer.writeln('TEL:$phone');
    }
    if (email != null && email!.isNotEmpty) {
      buffer.writeln('EMAIL:$email');
    }
    if (website != null && website!.isNotEmpty) {
      buffer.writeln('URL:$website');
    }
    if (address != null && address!.isNotEmpty) {
      buffer.writeln('ADR:;;$address;;;;');
    }
    if (note != null && note!.isNotEmpty) {
      buffer.writeln('NOTE:$note');
    }
    
    buffer.write('END:VCARD');
    return buffer.toString();
  }

  @override
  List<Object?> get props => [
        type,
        firstName,
        lastName,
        organization,
        title,
        phone,
        email,
        website,
        address,
        note,
      ];
}

/// Location content
class LocationContent extends QRContent {
  final double latitude;
  final double longitude;

  const LocationContent({
    required this.latitude,
    required this.longitude,
  }) : super(type: QRContentType.location);

  @override
  String toQRString() => 'geo:$latitude,$longitude';

  @override
  List<Object?> get props => [type, latitude, longitude];
}

/// Calendar Event content (iCal)
class CalendarEventContent extends QRContent {
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String? location;
  final String? description;

  const CalendarEventContent({
    required this.title,
    required this.startDate,
    required this.endDate,
    this.location,
    this.description,
  }) : super(type: QRContentType.calendarEvent);

  @override
  String toQRString() {
    final buffer = StringBuffer();
    buffer.writeln('BEGIN:VCALENDAR');
    buffer.writeln('VERSION:2.0');
    buffer.writeln('BEGIN:VEVENT');
    buffer.writeln('SUMMARY:$title');
    buffer.writeln('DTSTART:${_formatDateTime(startDate)}');
    buffer.writeln('DTEND:${_formatDateTime(endDate)}');
    
    if (location != null && location!.isNotEmpty) {
      buffer.writeln('LOCATION:$location');
    }
    if (description != null && description!.isNotEmpty) {
      buffer.writeln('DESCRIPTION:$description');
    }
    
    buffer.writeln('END:VEVENT');
    buffer.write('END:VCALENDAR');
    return buffer.toString();
  }

  String _formatDateTime(DateTime dateTime) {
    final year = dateTime.year.toString().padLeft(4, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');
    return '$year$month${day}T$hour$minute$second';
  }

  @override
  List<Object?> get props => [type, title, startDate, endDate, location, description];
}

/// WhatsApp content
class WhatsAppContent extends QRContent {
  final String phone;
  final String? message;

  const WhatsAppContent({
    required this.phone,
    this.message,
  }) : super(type: QRContentType.whatsapp);

  @override
  String toQRString() {
    final cleanedPhone = phone.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
    final buffer = StringBuffer('https://wa.me/$cleanedPhone');
    
    if (message != null && message!.isNotEmpty) {
      buffer.write('?text=${Uri.encodeComponent(message!)}');
    }
    
    return buffer.toString();
  }

  @override
  List<Object?> get props => [type, phone, message];
}

/// Instagram content
class InstagramContent extends QRContent {
  final String username;

  const InstagramContent({required this.username})
      : super(type: QRContentType.instagram);

  @override
  String toQRString() => 'https://instagram.com/$username';

  @override
  List<Object?> get props => [type, username];
}

/// Telegram content
class TelegramContent extends QRContent {
  final String username;

  const TelegramContent({required this.username})
      : super(type: QRContentType.telegram);

  @override
  String toQRString() => 'https://t.me/$username';

  @override
  List<Object?> get props => [type, username];
}

/// Twitter content
class TwitterContent extends QRContent {
  final String username;

  const TwitterContent({required this.username})
      : super(type: QRContentType.twitter);

  @override
  String toQRString() => 'https://twitter.com/$username';

  @override
  List<Object?> get props => [type, username];
}

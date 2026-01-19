/// Content encoding utilities for various QR code formats
class ContentEncoders {
  ContentEncoders._();

  /// Encode Wi-Fi credentials
  /// Format: WIFI:T:WPA;S:SSID;P:password;H:false;;
  static String encodeWiFi({
    required String ssid,
    required String password,
    required String security, // WPA, WEP, or nopass
    bool hidden = false,
  }) {
    return 'WIFI:T:$security;S:${_escape(ssid)};P:${_escape(password)};H:$hidden;;';
  }

  /// Encode vCard (Contact)
  /// Using vCard 3.0 format
  static String encodeVCard({
    required String firstName,
    String? lastName,
    String? organization,
    String? title,
    String? phone,
    String? email,
    String? website,
    String? address,
    String? note,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('BEGIN:VCARD');
    buffer.writeln('VERSION:3.0');
    
    // Full name
    final fullName = lastName != null ? '$firstName $lastName' : firstName;
    buffer.writeln('FN:$fullName');
    
    // Structured name (Last;First)
    buffer.writeln('N:${lastName ?? ''};$firstName;;;');
    
    // Organization
    if (organization != null && organization.isNotEmpty) {
      buffer.writeln('ORG:$organization');
    }
    
    // Title
    if (title != null && title.isNotEmpty) {
      buffer.writeln('TITLE:$title');
    }
    
    // Phone
    if (phone != null && phone.isNotEmpty) {
      buffer.writeln('TEL:$phone');
    }
    
    // Email
    if (email != null && email.isNotEmpty) {
      buffer.writeln('EMAIL:$email');
    }
    
    // Website
    if (website != null && website.isNotEmpty) {
      buffer.writeln('URL:$website');
    }
    
    // Address
    if (address != null && address.isNotEmpty) {
      buffer.writeln('ADR:;;$address;;;;');
    }
    
    // Note
    if (note != null && note.isNotEmpty) {
      buffer.writeln('NOTE:$note');
    }
    
    buffer.write('END:VCARD');
    return buffer.toString();
  }

  /// Encode calendar event (iCalendar)
  /// Using iCal format
  static String encodeCalendarEvent({
    required String title,
    required DateTime startDate,
    required DateTime endDate,
    String? location,
    String? description,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('BEGIN:VCALENDAR');
    buffer.writeln('VERSION:2.0');
    buffer.writeln('BEGIN:VEVENT');
    
    // Summary (title)
    buffer.writeln('SUMMARY:$title');
    
    // Start date/time
    buffer.writeln('DTSTART:${_formatDateTime(startDate)}');
    
    // End date/time
    buffer.writeln('DTEND:${_formatDateTime(endDate)}');
    
    // Location
    if (location != null && location.isNotEmpty) {
      buffer.writeln('LOCATION:$location');
    }
    
    // Description
    if (description != null && description.isNotEmpty) {
      buffer.writeln('DESCRIPTION:$description');
    }
    
    buffer.writeln('END:VEVENT');
    buffer.write('END:VCALENDAR');
    return buffer.toString();
  }

  /// Encode geographic location
  /// Format: geo:latitude,longitude
  static String encodeLocation({
    required double latitude,
    required double longitude,
  }) {
    return 'geo:$latitude,$longitude';
  }

  /// Encode phone number
  /// Format: tel:+1234567890
  static String encodePhone(String phone) {
    // Remove spaces, dashes, and parentheses
    final cleanedPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    return 'tel:$cleanedPhone';
  }

  /// Encode email
  /// Format: mailto:email@example.com?subject=Subject&body=Body
  static String encodeEmail({
    required String email,
    String? subject,
    String? body,
  }) {
    final buffer = StringBuffer('mailto:$email');
    
    final params = <String>[];
    if (subject != null && subject.isNotEmpty) {
      params.add('subject=${Uri.encodeComponent(subject)}');
    }
    if (body != null && body.isNotEmpty) {
      params.add('body=${Uri.encodeComponent(body)}');
    }
    
    if (params.isNotEmpty) {
      buffer.write('?${params.join('&')}');
    }
    
    return buffer.toString();
  }

  /// Encode SMS
  /// Format: smsto:+1234567890:Message
  static String encodeSMS({
    required String phone,
    String? message,
  }) {
    final cleanedPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (message != null && message.isNotEmpty) {
      return 'smsto:$cleanedPhone:$message';
    }
    return 'smsto:$cleanedPhone';
  }

  /// Encode WhatsApp link
  /// Format: https://wa.me/1234567890?text=Message
  static String encodeWhatsApp({
    required String phone,
    String? message,
  }) {
    final cleanedPhone = phone.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
    final buffer = StringBuffer('https://wa.me/$cleanedPhone');
    
    if (message != null && message.isNotEmpty) {
      buffer.write('?text=${Uri.encodeComponent(message)}');
    }
    
    return buffer.toString();
  }

  /// Encode Instagram profile link
  static String encodeInstagram(String username) {
    return 'https://instagram.com/$username';
  }

  /// Encode Telegram link
  static String encodeTelegram(String username) {
    return 'https://t.me/$username';
  }

  /// Encode Twitter/X link
  static String encodeTwitter(String username) {
    return 'https://twitter.com/$username';
  }

  /// Format DateTime for iCalendar (yyyyMMddTHHmmss)
  static String _formatDateTime(DateTime dateTime) {
    final year = dateTime.year.toString().padLeft(4, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');
    return '$year$month${day}T$hour$minute$second';
  }

  /// Escape special characters for Wi-Fi encoding
  static String _escape(String value) {
    return value
        .replaceAll('\\', '\\\\')
        .replaceAll(';', '\\;')
        .replaceAll(',', '\\,')
        .replaceAll(':', '\\:')
        .replaceAll('"', '\\"');
  }
}

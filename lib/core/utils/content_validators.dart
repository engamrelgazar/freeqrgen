/// Comprehensive validation for all QR content types
class ContentValidators {
  ContentValidators._();

  // ==================== TEXT VALIDATION ====================
  static ValidationResult validateText(String text) {
    if (text.trim().isEmpty) {
      return ValidationResult.error('Text cannot be empty');
    }
    if (text.length > 500) {
      return ValidationResult.error('Text must be 500 characters or less (currently ${text.length})');
    }
    return ValidationResult.valid();
  }

  // ==================== URL VALIDATION ====================
  static ValidationResult validateURL(String url) {
    if (url.trim().isEmpty) {
      return ValidationResult.error('URL is required');
    }

    // Auto-add https:// if missing protocol
    String normalizedUrl = url.trim();
    if (!normalizedUrl.startsWith('http://') && !normalizedUrl.startsWith('https://')) {
      normalizedUrl = 'https://$normalizedUrl';
    }

    // Comprehensive URL validation
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
      caseSensitive: false,
    );

    if (!urlRegex.hasMatch(normalizedUrl)) {
      return ValidationResult.error('Invalid URL format (e.g., https://example.com)');
    }

    return ValidationResult.valid(normalizedValue: normalizedUrl);
  }

  // ==================== PHONE VALIDATION ====================
  static ValidationResult validatePhone(String phone) {
    if (phone.trim().isEmpty) {
      return ValidationResult.error('Phone number is required');
    }

    // Remove formatting characters
    final cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)\.]'), '');

    // E.164 format validation (international format)
    // Must start with + (optional) followed by 1-15 digits
    if (!RegExp(r'^\+?[1-9]\d{7,14}$').hasMatch(cleaned)) {
      return ValidationResult.error('Invalid phone number (use international format: +1234567890)');
    }

    // Ensure it has + prefix for international format
    final normalizedPhone = cleaned.startsWith('+') ? cleaned : '+$cleaned';

    return ValidationResult.valid(normalizedValue: normalizedPhone);
  }

  // ==================== EMAIL VALIDATION ====================
  static ValidationResult validateEmail(String email) {
    if (email.trim().isEmpty) {
      return ValidationResult.error('Email is required');
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email.trim())) {
      return ValidationResult.error('Invalid email format (e.g., user@example.com)');
    }

    return ValidationResult.valid(normalizedValue: email.trim().toLowerCase());
  }

  static ValidationResult validateEmailSubject(String subject) {
    if (subject.length > 200) {
      return ValidationResult.error('Subject must be 200 characters or less');
    }
    return ValidationResult.valid();
  }

  static ValidationResult validateEmailBody(String body) {
    if (body.length > 1000) {
      return ValidationResult.error('Body must be 1000 characters or less');
    }
    return ValidationResult.valid();
  }

  // ==================== SMS VALIDATION ====================
  static ValidationResult validateSMSPhone(String phone) {
    return validatePhone(phone); // Same as phone validation
  }

  static ValidationResult validateSMSMessage(String message) {
    if (message.length > 160) {
      return ValidationResult.error('Message must be 160 characters or less (currently ${message.length})');
    }
    return ValidationResult.valid();
  }

  // ==================== WI-FI VALIDATION ====================
  static ValidationResult validateWiFiSSID(String ssid) {
    if (ssid.trim().isEmpty) {
      return ValidationResult.error('Network name (SSID) is required');
    }
    if (ssid.length > 32) {
      return ValidationResult.error('SSID must be 32 characters or less');
    }
    return ValidationResult.valid();
  }

  static ValidationResult validateWiFiPassword(String password, String securityType) {
    if (securityType == 'nopass' || securityType == 'None') {
      return ValidationResult.valid(); // No password needed for open networks
    }

    if (password.isEmpty) {
      return ValidationResult.error('Password is required for secured networks');
    }

    if (securityType == 'WPA' || securityType == 'WPA2') {
      if (password.length < 8) {
        return ValidationResult.error('WPA password must be at least 8 characters');
      }
      if (password.length > 63) {
        return ValidationResult.error('WPA password must be 63 characters or less');
      }
    } else if (securityType == 'WEP') {
      // WEP keys are typically 5, 13, or 16 characters (or 10, 26, 32 hex digits)
      if (password.length != 5 && password.length != 13 && password.length != 16 &&
          password.length != 10 && password.length != 26 && password.length != 32) {
        return ValidationResult.error('WEP key must be 5, 13, or 16 characters');
      }
    }

    return ValidationResult.valid();
  }

  // ==================== CONTACT (vCard) VALIDATION ====================
  static ValidationResult validateContactFirstName(String firstName) {
    if (firstName.trim().isEmpty) {
      return ValidationResult.error('First name is required');
    }
    if (firstName.length > 50) {
      return ValidationResult.error('First name must be 50 characters or less');
    }
    return ValidationResult.valid();
  }

  static ValidationResult validateContactLastName(String lastName) {
    if (lastName.length > 50) {
      return ValidationResult.error('Last name must be 50 characters or less');
    }
    return ValidationResult.valid();
  }

  static ValidationResult validateContactPhone(String phone) {
    if (phone.isEmpty) {
      return ValidationResult.valid(); // Optional field
    }
    return validatePhone(phone);
  }

  static ValidationResult validateContactEmail(String email) {
    if (email.isEmpty) {
      return ValidationResult.valid(); // Optional field
    }
    return validateEmail(email);
  }

  static ValidationResult validateContactOrganization(String org) {
    if (org.length > 100) {
      return ValidationResult.error('Organization must be 100 characters or less');
    }
    return ValidationResult.valid();
  }

  // ==================== LOCATION VALIDATION ====================
  static ValidationResult validateLatitude(String lat) {
    if (lat.trim().isEmpty) {
      return ValidationResult.error('Latitude is required');
    }

    final latValue = double.tryParse(lat.trim());
    if (latValue == null) {
      return ValidationResult.error('Latitude must be a valid number');
    }

    if (latValue < -90 || latValue > 90) {
      return ValidationResult.error('Latitude must be between -90 and 90');
    }

    return ValidationResult.valid();
  }

  static ValidationResult validateLongitude(String lng) {
    if (lng.trim().isEmpty) {
      return ValidationResult.error('Longitude is required');
    }

    final lngValue = double.tryParse(lng.trim());
    if (lngValue == null) {
      return ValidationResult.error('Longitude must be a valid number');
    }

    if (lngValue < -180 || lngValue > 180) {
      return ValidationResult.error('Longitude must be between -180 and 180');
    }

    return ValidationResult.valid();
  }

  // ==================== CALENDAR EVENT VALIDATION ====================
  static ValidationResult validateEventTitle(String title) {
    if (title.trim().isEmpty) {
      return ValidationResult.error('Event title is required');
    }
    if (title.length > 200) {
      return ValidationResult.error('Title must be 200 characters or less');
    }
    return ValidationResult.valid();
  }

  static ValidationResult validateEventDates(DateTime? start, DateTime? end) {
    if (start == null) {
      return ValidationResult.error('Start date is required');
    }
    if (end == null) {
      return ValidationResult.error('End date is required');
    }
    if (end.isBefore(start)) {
      return ValidationResult.error('End date must be after start date');
    }
    if (end.difference(start).inDays > 365) {
      return ValidationResult.error('Event duration cannot exceed 1 year');
    }
    return ValidationResult.valid();
  }

  static ValidationResult validateEventLocation(String location) {
    if (location.length > 200) {
      return ValidationResult.error('Location must be 200 characters or less');
    }
    return ValidationResult.valid();
  }

  static ValidationResult validateEventDescription(String description) {
    if (description.length > 500) {
      return ValidationResult.error('Description must be 500 characters or less');
    }
    return ValidationResult.valid();
  }

  // ==================== WHATSAPP VALIDATION ====================
  static ValidationResult validateWhatsAppPhone(String phone) {
    return validatePhone(phone);
  }

  static ValidationResult validateWhatsAppMessage(String message) {
    if (message.length > 500) {
      return ValidationResult.error('Message must be 500 characters or less');
    }
    return ValidationResult.valid();
  }

  // ==================== SOCIAL MEDIA USERNAME VALIDATION ====================
  static ValidationResult validateUsername(String username, String platform) {
    if (username.trim().isEmpty) {
      return ValidationResult.error('Username is required');
    }

    // Remove @ if present
    final cleaned = username.trim().startsWith('@') 
        ? username.trim().substring(1) 
        : username.trim();

    // Username validation (alphanumeric, underscore, dot, hyphen)
    final usernameRegex = RegExp(r'^[a-zA-Z0-9._-]{1,30}$');
    if (!usernameRegex.hasMatch(cleaned)) {
      return ValidationResult.error(
        'Invalid username format for $platform (use letters, numbers, _, ., -)'
      );
    }

    // Platform-specific rules
    if (platform == 'Instagram' && cleaned.length > 30) {
      return ValidationResult.error('Instagram username must be 30 characters or less');
    }
    if (platform == 'Twitter' && cleaned.length > 15) {
      return ValidationResult.error('Twitter username must be 15 characters or less');
    }
    if (platform == 'Telegram' && cleaned.length < 5) {
      return ValidationResult.error('Telegram username must be at least 5 characters');
    }

    return ValidationResult.valid(normalizedValue: cleaned);
  }

  // ==================== INSTAGRAM VALIDATION ====================
  static ValidationResult validateInstagramUsername(String username) {
    return validateUsername(username, 'Instagram');
  }

  // ==================== TELEGRAM VALIDATION ====================
  static ValidationResult validateTelegramUsername(String username) {
    return validateUsername(username, 'Telegram');
  }

  // ==================== TWITTER VALIDATION ====================
  static ValidationResult validateTwitterUsername(String username) {
    return validateUsername(username, 'Twitter');
  }
}

/// Result of a validation operation
class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  final String? normalizedValue;

  const ValidationResult._({
    required this.isValid,
    this.errorMessage,
    this.normalizedValue,
  });

  /// Create a valid result
  factory ValidationResult.valid({String? normalizedValue}) {
    return ValidationResult._(
      isValid: true,
      normalizedValue: normalizedValue,
    );
  }

  /// Create an error result
  factory ValidationResult.error(String message) {
    return ValidationResult._(
      isValid: false,
      errorMessage: message,
    );
  }

  @override
  String toString() {
    if (isValid) {
      return 'Valid${normalizedValue != null ? ' (normalized: $normalizedValue)' : ''}';
    } else {
      return 'Error: $errorMessage';
    }
  }
}

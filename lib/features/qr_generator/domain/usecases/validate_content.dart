import 'package:freeqrgen/core/errors/failures.dart';
import 'package:freeqrgen/core/utils/content_validators.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_content.dart';
import 'package:freeqrgen/features/qr_generator/domain/repositories/qr_repository.dart';

/// Use case for validating QR content
class ValidateContent {
  final QRRepository repository;

  ValidateContent(this.repository);

  Either<Failure, bool> call(QRContent content) {
    return validateDetailed(content);
  }

  /// Validate specific content types with detailed error messages
  static Either<Failure, bool> validateDetailed(QRContent content) {
    ValidationResult result;

    if (content is TextContent) {
      result = ContentValidators.validateText(content.text);
    } else if (content is URLContent) {
      result = ContentValidators.validateURL(content.url);
    } else if (content is PhoneContent) {
      result = ContentValidators.validatePhone(content.phone);
    } else if (content is EmailContent) {
      result = ContentValidators.validateEmail(content.email);
      if (result.isValid && content.subject != null) {
        result = ContentValidators.validateEmailSubject(content.subject!);
      }
      if (result.isValid && content.body != null) {
        result = ContentValidators.validateEmailBody(content.body!);
      }
    } else if (content is SMSContent) {
      result = ContentValidators.validateSMSPhone(content.phone);
      if (result.isValid && content.message != null) {
        result = ContentValidators.validateSMSMessage(content.message!);
      }
    } else if (content is WiFiContent) {
      result = ContentValidators.validateWiFiSSID(content.ssid);
      if (result.isValid) {
        result = ContentValidators.validateWiFiPassword(
          content.password,
          content.security,
        );
      }
    } else if (content is ContactContent) {
      result = ContentValidators.validateContactFirstName(content.firstName);
      if (result.isValid && content.phone != null) {
        result = ContentValidators.validateContactPhone(content.phone!);
      }
      if (result.isValid && content.email != null) {
        result = ContentValidators.validateContactEmail(content.email!);
      }
    } else if (content is LocationContent) {
      result = ContentValidators.validateLatitude(content.latitude.toString());
      if (result.isValid) {
        result = ContentValidators.validateLongitude(
          content.longitude.toString(),
        );
      }
    } else if (content is CalendarEventContent) {
      result = ContentValidators.validateEventTitle(content.title);
      if (result.isValid) {
        result = ContentValidators.validateEventDates(
          content.startDate,
          content.endDate,
        );
      }
    } else if (content is WhatsAppContent) {
      result = ContentValidators.validateWhatsAppPhone(content.phone);
      if (result.isValid && content.message != null) {
        result = ContentValidators.validateWhatsAppMessage(content.message!);
      }
    } else if (content is InstagramContent) {
      result = ContentValidators.validateInstagramUsername(content.username);
    } else if (content is TelegramContent) {
      result = ContentValidators.validateTelegramUsername(content.username);
    } else if (content is TwitterContent) {
      result = ContentValidators.validateTwitterUsername(content.username);
    } else {
      return const Either.right(true);
    }

    if (result.isValid) {
      return const Either.right(true);
    } else {
      return Either.left(
        ValidationFailure(message: result.errorMessage ?? 'Validation failed'),
      );
    }
  }
}

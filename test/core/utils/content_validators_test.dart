import 'package:flutter_test/flutter_test.dart';
import 'package:freeqrgen/core/utils/content_validators.dart';

void main() {
  group('ContentValidators', () {
    group('validateText', () {
      test('should return valid for non-empty text', () {
        final result = ContentValidators.validateText('Hello World');
        expect(result.isValid, true);
        expect(result.errorMessage, null);
      });

      test('should return error for empty text', () {
        final result = ContentValidators.validateText('');
        expect(result.isValid, false);
        expect(result.errorMessage, 'Text cannot be empty');
      });

      test('should return error for text exceeding 500 characters', () {
        final longText = 'a' * 501;
        final result = ContentValidators.validateText(longText);
        expect(result.isValid, false);
        expect(result.errorMessage, contains('500 characters'));
      });
    });

    group('validateEmail', () {
      test('should return valid for correct email', () {
        final result = ContentValidators.validateEmail('user@example.com');
        expect(result.isValid, true);
      });

      test('should return error for invalid email', () {
        final result = ContentValidators.validateEmail('invalid-email');
        expect(result.isValid, false);
        expect(result.errorMessage, contains('Invalid email format'));
      });

      test('should return error for empty email', () {
        final result = ContentValidators.validateEmail('');
        expect(result.isValid, false);
      });
    });

    group('validateURL', () {
      test('should return valid for correct URL', () {
        final result = ContentValidators.validateURL('https://example.com');
        expect(result.isValid, true);
      });

      test('should normalize URL without protocol', () {
        final result = ContentValidators.validateURL('example.com');
        expect(result.isValid, true);
        expect(result.normalizedValue, 'https://example.com');
      });

      test('should return error for invalid URL', () {
        final result = ContentValidators.validateURL('not a url');
        expect(result.isValid, false);
      });
    });

    group('validatePhone', () {
      test('should return valid for correct phone', () {
        final result = ContentValidators.validatePhone('+1234567890');
        expect(result.isValid, true);
      });

      test('should normalize phone without plus', () {
        final result = ContentValidators.validatePhone('1234567890');
        expect(result.isValid, true);
        expect(result.normalizedValue, '+1234567890');
      });

      test('should return error for too short phone', () {
        final result = ContentValidators.validatePhone('123');
        expect(result.isValid, false);
      });
    });

    group('validateLatitude', () {
      test('should return valid for correct latitude', () {
        final result = ContentValidators.validateLatitude('37.7749');
        expect(result.isValid, true);
      });

      test('should return error for latitude > 90', () {
        final result = ContentValidators.validateLatitude('91');
        expect(result.isValid, false);
      });

      test('should return error for latitude < -90', () {
        final result = ContentValidators.validateLatitude('-91');
        expect(result.isValid, false);
      });
    });

    group('validateLongitude', () {
      test('should return valid for correct longitude', () {
        final result = ContentValidators.validateLongitude('-122.4194');
        expect(result.isValid, true);
      });

      test('should return error for longitude > 180', () {
        final result = ContentValidators.validateLongitude('181');
        expect(result.isValid, false);
      });

      test('should return error for longitude < -180', () {
        final result = ContentValidators.validateLongitude('-181');
        expect(result.isValid, false);
      });
    });
  });
}

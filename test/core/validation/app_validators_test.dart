import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/constants/translation_keys.dart';
import 'package:masarifak/core/constants/validation_rules.dart';
import 'package:masarifak/core/validation/app_validators.dart';

void main() {
  group('required', () {
    test('empty after trim returns validationRequired', () {
      expect(AppValidators.required('   '), TranslationKeys.validationRequired);
      expect(AppValidators.required(null), TranslationKeys.validationRequired);
    });

    test('non-empty value is valid', () {
      expect(AppValidators.required('Ahmed'), isNull);
    });
  });

  group('email', () {
    test('empty returns validationRequired', () {
      expect(AppValidators.email(''), TranslationKeys.validationRequired);
    });

    test('invalid email returns validationEmailInvalid', () {
      expect(
        AppValidators.email('ahmed@example'),
        TranslationKeys.validationEmailInvalid,
      );
    });

    test('valid email is valid', () {
      expect(AppValidators.email('ahmed@example.com'), isNull);
    });
  });

  group('password', () {
    test('empty returns validationRequired', () {
      expect(AppValidators.password(''), TranslationKeys.validationRequired);
    });

    test('below the minimum returns validationPasswordTooShort', () {
      expect(
        AppValidators.password('a' * (ValidationRules.passwordMinLength - 1)),
        TranslationKeys.validationPasswordTooShort,
      );
    });

    test('above the maximum returns validationPasswordTooLong', () {
      expect(
        AppValidators.password('a' * (ValidationRules.passwordMaxLength + 1)),
        TranslationKeys.validationPasswordTooLong,
      );
    });

    test('within the limits is valid', () {
      expect(AppValidators.password('at-least-8-chars'), isNull);
    });
  });

  group('name', () {
    test('empty returns validationRequired', () {
      expect(AppValidators.name(' '), TranslationKeys.validationRequired);
    });

    test('non-empty name is valid', () {
      expect(AppValidators.name('Ahmed'), isNull);
    });
  });
}

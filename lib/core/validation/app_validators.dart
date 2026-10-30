import '../constants/translation_keys.dart';
import '../constants/validation_rules.dart';

abstract final class AppValidators {
  static final RegExp _emailPattern = RegExp(ValidationRules.emailPattern);

  static String? required(String? value) =>
      value == null || value.trim().isEmpty
      ? TranslationKeys.validationRequired
      : null;

  static String? email(String? value) {
    final requiredKey = required(value);
    if (requiredKey != null) return requiredKey;
    if (!_emailPattern.hasMatch(value!.trim())) {
      return TranslationKeys.validationEmailInvalid;
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return TranslationKeys.validationRequired;
    if (value.length < ValidationRules.passwordMinLength) {
      return TranslationKeys.validationPasswordTooShort;
    }
    if (value.length > ValidationRules.passwordMaxLength) {
      return TranslationKeys.validationPasswordTooLong;
    }
    return null;
  }

  static String? name(String? value) => required(value);
}

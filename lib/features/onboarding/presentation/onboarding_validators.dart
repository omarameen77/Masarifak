import '../../../core/constants/translation_keys.dart';
import '../../../core/constants/validation_rules.dart';
import '../../../core/formatting/app_number_format.dart';

abstract final class OnboardingValidators {
  static String? Function(String?) positiveAmount(
    int exponent, {
    String errorKey = TranslationKeys.validationAmountInvalid,
  }) => (value) {
    final minor = AppNumberFormat.parseMinor(value ?? '', exponent: exponent);
    return minor != null && minor > 0 ? null : errorKey;
  };

  static String? Function(String?) optionalAmount(
    int exponent, {
    String errorKey = TranslationKeys.validationAmountOrEmpty,
  }) => (value) {
    if (value == null || value.trim().isEmpty) return null;
    return AppNumberFormat.parseMinor(value, exponent: exponent) == null
        ? errorKey
        : null;
  };

  static String? Function(String?) amountOrZero(int exponent) =>
      optionalAmount(exponent, errorKey: TranslationKeys.validationAmountOrZero);

  static int parseOptionalMinor(String value, {required int exponent}) =>
      AppNumberFormat.parseMinor(value, exponent: exponent) ?? 0;

  static String? dayOfMonth(String? value) =>
      parseDay(value) == null ? TranslationKeys.validationDayInvalid : null;

  static String? obligationName(String? value) =>
      value == null || value.trim().isEmpty
      ? TranslationKeys.validationObligationName
      : null;

  static int? parseDay(String? value) {
    final day = int.tryParse(AppNumberFormat.normalizeDigits(value ?? '').trim());
    if (day == null ||
        day < ValidationRules.dayOfMonthMin ||
        day > ValidationRules.dayOfMonthMax) {
      return null;
    }
    return day;
  }
}

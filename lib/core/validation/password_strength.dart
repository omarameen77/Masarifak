import '../constants/translation_keys.dart';
import '../constants/validation_rules.dart';

enum PasswordStrengthLevel { empty, weak, fair, strong, veryStrong }

final class PasswordStrength {
  const PasswordStrength({required this.level, required this.messageKey});

  factory PasswordStrength.of(String password) {
    if (password.isEmpty) {
      return const PasswordStrength(
        level: PasswordStrengthLevel.empty,
        messageKey: TranslationKeys.passwordStrengthHint,
      );
    }
    final hasMinLength = password.length >= ValidationRules.passwordMinLength;
    final checks = [
      hasMinLength,
      _uppercase.hasMatch(password) && _lowercase.hasMatch(password),
      _digit.hasMatch(password),
      _symbol.hasMatch(password) ||
          password.length >= ValidationRules.passwordStrongLength,
    ];
    var score = checks.where((passed) => passed).length;
    if (!hasMinLength && score > 1) score = 1;
    if (score < 1) score = 1;
    final level = PasswordStrengthLevel.values[score];
    return PasswordStrength(
      level: level,
      messageKey: hasMinLength
          ? _messageKeyFor(level)
          : TranslationKeys.passwordStrengthShort,
    );
  }

  static final RegExp _uppercase = RegExp(ValidationRules.uppercasePattern);
  static final RegExp _lowercase = RegExp(ValidationRules.lowercasePattern);
  static final RegExp _digit = RegExp(ValidationRules.digitPattern);
  static final RegExp _symbol = RegExp(ValidationRules.symbolPattern);

  static String _messageKeyFor(PasswordStrengthLevel level) => switch (level) {
    PasswordStrengthLevel.empty => TranslationKeys.passwordStrengthHint,
    PasswordStrengthLevel.weak => TranslationKeys.passwordStrengthWeak,
    PasswordStrengthLevel.fair => TranslationKeys.passwordStrengthFair,
    PasswordStrengthLevel.strong => TranslationKeys.passwordStrengthStrong,
    PasswordStrengthLevel.veryStrong =>
      TranslationKeys.passwordStrengthVeryStrong,
  };

  final PasswordStrengthLevel level;
  final String messageKey;
}

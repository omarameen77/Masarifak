import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/constants/translation_keys.dart';
import 'package:masarifak/core/validation/password_strength.dart';

void main() {
  void expectStrength(
    String password,
    PasswordStrengthLevel level,
    String messageKey,
  ) {
    final strength = PasswordStrength.of(password);
    expect(strength.level, level);
    expect(strength.messageKey, messageKey);
  }

  test('empty password shows the hint and no bars', () {
    expectStrength(
      '',
      PasswordStrengthLevel.empty,
      TranslationKeys.passwordStrengthHint,
    );
  });

  test('short password is capped at one bar even with digits and symbols', () {
    expectStrength(
      'Ab1!',
      PasswordStrengthLevel.weak,
      TranslationKeys.passwordStrengthShort,
    );
  });

  test('eight lowercase letters are weak', () {
    expectStrength(
      'abcdefgh',
      PasswordStrengthLevel.weak,
      TranslationKeys.passwordStrengthWeak,
    );
  });

  test('length plus mixed case is fair', () {
    expectStrength(
      'Abcdefgh',
      PasswordStrengthLevel.fair,
      TranslationKeys.passwordStrengthFair,
    );
  });

  test('length plus mixed case and a digit is strong', () {
    expectStrength(
      'Abcdefg1',
      PasswordStrengthLevel.strong,
      TranslationKeys.passwordStrengthStrong,
    );
  });

  test('all four checks are very strong', () {
    expectStrength(
      'Abcdefg1!',
      PasswordStrengthLevel.veryStrong,
      TranslationKeys.passwordStrengthVeryStrong,
    );
  });

  test('fourteen characters count as the fourth check without a symbol', () {
    expectStrength(
      'abcdefghijklmn',
      PasswordStrengthLevel.fair,
      TranslationKeys.passwordStrengthFair,
    );
  });
}

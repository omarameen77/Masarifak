import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/constants/translation_keys.dart';
import 'package:masarifak/core/error/failure.dart';
import 'package:masarifak/core/error/failure_messages.dart';
import 'package:masarifak/features/auth/presentation/login/login_failure_message.dart';

void main() {
  test('UnauthorizedFailure maps to the vague invalid credentials key', () {
    expect(
      loginFailureKey(const UnauthorizedFailure()),
      TranslationKeys.errorInvalidCredentials,
    );
  });

  test('NetworkFailure reuses the shared failure message key', () {
    expect(
      loginFailureKey(const NetworkFailure()),
      failureMessageKey(const NetworkFailure()),
    );
    expect(loginFailureKey(const NetworkFailure()), TranslationKeys.errorNetwork);
  });
}

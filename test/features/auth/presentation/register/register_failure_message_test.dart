import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/constants/api_error_codes.dart';
import 'package:masarifak/core/constants/translation_keys.dart';
import 'package:masarifak/core/error/failure.dart';
import 'package:masarifak/core/error/failure_messages.dart';
import 'package:masarifak/features/auth/presentation/register/register_failure_message.dart';

void main() {
  test('email_taken conflict maps to validationEmailTaken', () {
    expect(
      registerFailureKey(const ConflictFailure(ApiErrorCodes.emailTaken)),
      TranslationKeys.validationEmailTaken,
    );
  });

  test('NetworkFailure reuses the shared failure message key', () {
    expect(
      registerFailureKey(const NetworkFailure()),
      failureMessageKey(const NetworkFailure()),
    );
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/constants/api_error_codes.dart';
import 'package:masarifak/core/constants/api_locale_values.dart';
import 'package:masarifak/core/error/failure.dart';
import 'package:masarifak/core/result/result.dart';
import 'package:masarifak/features/auth/domain/entities/auth_session.dart';
import 'package:masarifak/features/auth/domain/entities/auth_user.dart';
import 'package:masarifak/features/auth/domain/entities/feature_flags.dart';
import 'package:masarifak/features/auth/domain/entities/login_result.dart';
import 'package:masarifak/features/auth/domain/usecases/register_usecase.dart';
import 'package:masarifak/features/auth/presentation/register/register_cubit.dart';
import 'package:masarifak/features/auth/presentation/register/register_intent.dart';
import 'package:masarifak/features/auth/presentation/register/register_state.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

void main() {
  const name = 'Ahmed Test';
  const email = 'ahmed@example.com';
  const password = 'at-least-8-chars';
  const submitted = RegisterSubmitted(
    name: name,
    email: email,
    password: password,
    locale: ApiLocaleValues.arabicLocale,
    digits: ApiLocaleValues.arabicDigits,
  );
  const result = LoginResult(
    session: AuthSession(
      accessToken: 'access-token',
      refreshToken: 'refresh-token',
      expiresInSeconds: 900,
      user: AuthUser(id: 'user-id', name: name, emailVerified: false),
    ),
    flags: FeatureFlags.empty(),
    onboarded: false,
  );
  const emailTaken = ConflictFailure(ApiErrorCodes.emailTaken);

  late MockRegisterUseCase useCase;

  setUp(() => useCase = MockRegisterUseCase());

  void givenResult(Result<LoginResult> value) => when(
    () => useCase(
      name: name,
      email: email,
      password: password,
      locale: ApiLocaleValues.arabicLocale,
      digits: ApiLocaleValues.arabicDigits,
    ),
  ).thenAnswer((_) async => value);

  blocTest<RegisterCubit, RegisterState>(
    'submit success emits loading then the result',
    setUp: () => givenResult(const Success(result)),
    build: () => RegisterCubit(useCase),
    act: (cubit) => cubit.doEvent(submitted),
    expect: () => [
      const RegisterState(isSubmitting: true),
      const RegisterState(result: result),
    ],
  );

  blocTest<RegisterCubit, RegisterState>(
    'submit email_taken emits loading then the conflict failure',
    setUp: () => givenResult(const Error(emailTaken)),
    build: () => RegisterCubit(useCase),
    act: (cubit) => cubit.doEvent(submitted),
    expect: () => [
      const RegisterState(isSubmitting: true),
      const RegisterState(failure: emailTaken),
    ],
  );

  blocTest<RegisterCubit, RegisterState>(
    'submit network failure emits the failure and no result',
    setUp: () => givenResult(const Error(NetworkFailure())),
    build: () => RegisterCubit(useCase),
    act: (cubit) => cubit.doEvent(submitted),
    expect: () => [
      const RegisterState(isSubmitting: true),
      const RegisterState(failure: NetworkFailure()),
    ],
    verify: (cubit) => expect(cubit.state.result, isNull),
  );
}

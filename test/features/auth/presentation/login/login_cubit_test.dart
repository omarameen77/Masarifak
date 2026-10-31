import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/constants/translation_keys.dart';
import 'package:masarifak/core/error/failure.dart';
import 'package:masarifak/core/result/result.dart';
import 'package:masarifak/features/auth/domain/entities/auth_session.dart';
import 'package:masarifak/features/auth/domain/entities/auth_user.dart';
import 'package:masarifak/features/auth/domain/entities/feature_flags.dart';
import 'package:masarifak/features/auth/domain/entities/login_result.dart';
import 'package:masarifak/features/auth/domain/usecases/login_usecase.dart';
import 'package:masarifak/features/auth/presentation/login/login_cubit.dart';
import 'package:masarifak/features/auth/presentation/login/login_failure_message.dart';
import 'package:masarifak/features/auth/presentation/login/login_intent.dart';
import 'package:masarifak/features/auth/presentation/login/login_state.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  const email = 'ahmed@example.com';
  const password = 'at-least-8-chars';
  const result = LoginResult(
    session: AuthSession(
      accessToken: 'access-token',
      refreshToken: 'refresh-token',
      expiresInSeconds: 900,
      user: AuthUser(id: 'user-id', name: 'Test User', emailVerified: true),
    ),
    flags: FeatureFlags.empty(),
    onboarded: true,
  );

  late MockLoginUseCase useCase;

  setUp(() => useCase = MockLoginUseCase());

  void givenResult(Result<LoginResult> value) => when(
    () => useCase(email: email, password: password),
  ).thenAnswer((_) async => value);

  blocTest<LoginCubit, LoginState>(
    'submit success emits loading then success with the outcome',
    setUp: () => givenResult(const Success(result)),
    build: () => LoginCubit(useCase),
    act: (cubit) => cubit.doEvent(const LoginSubmitted(email, password)),
    expect: () => [
      const LoginState(isSubmitting: true),
      const LoginState(outcome: result),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'submit 401 emits loading then UnauthorizedFailure shown as invalid credentials',
    setUp: () => givenResult(const Error(UnauthorizedFailure())),
    build: () => LoginCubit(useCase),
    act: (cubit) => cubit.doEvent(const LoginSubmitted(email, password)),
    expect: () => [
      const LoginState(isSubmitting: true),
      const LoginState(failure: UnauthorizedFailure()),
    ],
    verify: (cubit) => expect(
      loginFailureKey(cubit.state.failure!),
      TranslationKeys.errorInvalidCredentials,
    ),
  );

  blocTest<LoginCubit, LoginState>(
    'submit network failure is NetworkFailure, not invalid credentials',
    setUp: () => givenResult(const Error(NetworkFailure())),
    build: () => LoginCubit(useCase),
    act: (cubit) => cubit.doEvent(const LoginSubmitted(email, password)),
    expect: () => [
      const LoginState(isSubmitting: true),
      const LoginState(failure: NetworkFailure()),
    ],
    verify: (cubit) => expect(
      loginFailureKey(cubit.state.failure!),
      isNot(TranslationKeys.errorInvalidCredentials),
    ),
  );

  blocTest<LoginCubit, LoginState>(
    'a new submit clears the previous failure while loading',
    setUp: () => givenResult(const Success(result)),
    build: () => LoginCubit(useCase),
    seed: () => const LoginState(failure: NetworkFailure()),
    act: (cubit) => cubit.doEvent(const LoginSubmitted(email, password)),
    expect: () => [
      const LoginState(isSubmitting: true),
      const LoginState(outcome: result),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'toggle visibility twice flips the flag back to false',
    build: () => LoginCubit(useCase),
    act: (cubit) => cubit
      ..doEvent(const LoginPasswordVisibilityToggled())
      ..doEvent(const LoginPasswordVisibilityToggled()),
    expect: () => [
      const LoginState(isPasswordVisible: true),
      const LoginState(),
    ],
  );

  test('email and password are not kept in the state after submit', () async {
    givenResult(const Error(UnauthorizedFailure()));
    final cubit = LoginCubit(useCase);

    cubit.doEvent(const LoginSubmitted(email, password));
    await cubit.stream.firstWhere((state) => !state.isSubmitting);

    expect(cubit.state.props, isNot(contains(email)));
    expect(cubit.state.props, isNot(contains(password)));
    expect(cubit.state.toString(), isNot(contains(email)));
    expect(cubit.state.toString(), isNot(contains(password)));
    await cubit.close();
  });
}

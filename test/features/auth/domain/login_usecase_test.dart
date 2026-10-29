import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/error/failure.dart';
import 'package:masarifak/core/result/result.dart';
import 'package:masarifak/features/auth/domain/entities/auth_session.dart';
import 'package:masarifak/features/auth/domain/entities/auth_user.dart';
import 'package:masarifak/features/auth/domain/entities/feature_flags.dart';
import 'package:masarifak/features/auth/domain/entities/login_outcome.dart';
import 'package:masarifak/features/auth/domain/entities/login_result.dart';
import 'package:masarifak/features/auth/domain/repositories/auth_repository.dart';
import 'package:masarifak/features/auth/domain/usecases/login_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  const email = 'user@test.invalid';
  const password = 'test-password';
  const user = AuthUser(
    id: 'user-id',
    name: 'Test User',
    email: email,
    emailVerified: true,
  );
  const session = AuthSession(
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
    expiresInSeconds: 900,
    user: user,
  );
  const flags = FeatureFlags({'ask': true});
  const outcome = LoginOutcome(session: session, flags: flags);

  late MockAuthRepository repository;
  late LoginUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = LoginUseCase(repository);
    when(() => repository.clearSession()).thenAnswer((_) async {});
  });

  void givenLogin(Result<LoginOutcome> result) => when(
    () => repository.login(email: email, password: password),
  ).thenAnswer((_) async => result);

  void givenOnboarded(Result<bool> result) =>
      when(() => repository.isOnboarded()).thenAnswer((_) async => result);

  test('success with onboarded true returns session, flags and onboarded', () async {
    givenLogin(const Success(outcome));
    givenOnboarded(const Success(true));

    expect(
      await useCase(email: email, password: password),
      const Success(LoginResult(session: session, flags: flags, onboarded: true)),
    );
  });

  test('success with onboarded false returns onboarded false', () async {
    givenLogin(const Success(outcome));
    givenOnboarded(const Success(false));

    expect(
      await useCase(email: email, password: password),
      const Success(LoginResult(session: session, flags: flags, onboarded: false)),
    );
  });

  test('login failure is returned and isOnboarded is not called', () async {
    givenLogin(const Error(UnauthorizedFailure()));

    expect(
      await useCase(email: email, password: password),
      const Error<LoginResult>(UnauthorizedFailure()),
    );
    verifyNever(() => repository.isOnboarded());
    verifyNever(() => repository.clearSession());
  });

  test('isOnboarded UnauthorizedFailure is returned and the session is cleared', () async {
    givenLogin(const Success(outcome));
    givenOnboarded(const Error(UnauthorizedFailure()));

    expect(
      await useCase(email: email, password: password),
      const Error<LoginResult>(UnauthorizedFailure()),
    );
    verify(() => repository.clearSession()).called(1);
  });

  test('isOnboarded NetworkFailure is returned and the session is cleared', () async {
    givenLogin(const Success(outcome));
    givenOnboarded(const Error(NetworkFailure()));

    expect(
      await useCase(email: email, password: password),
      const Error<LoginResult>(NetworkFailure()),
    );
    verify(() => repository.clearSession()).called(1);
  });
}

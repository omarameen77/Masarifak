import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/result/result.dart';
import 'package:masarifak/features/auth/domain/entities/auth_session.dart';
import 'package:masarifak/features/auth/domain/entities/auth_user.dart';
import 'package:masarifak/features/auth/domain/entities/feature_flags.dart';
import 'package:masarifak/features/auth/domain/entities/login_outcome.dart';
import 'package:masarifak/features/auth/domain/entities/login_result.dart';
import 'package:masarifak/features/auth/domain/repositories/auth_repository.dart';
import 'package:masarifak/features/auth/domain/usecases/register_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  const name = 'Test User';
  const email = 'user@test.invalid';
  const password = 'test-password';
  const locale = 'ar';
  const digits = 'arabic';
  const session = AuthSession(
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
    expiresInSeconds: 900,
    user: AuthUser(id: 'user-id', name: name, emailVerified: false),
  );
  const flags = FeatureFlags.empty();

  test('register success runs the shared post-auth path', () async {
    final repository = MockAuthRepository();
    when(
      () => repository.register(
        name: name,
        email: email,
        password: password,
        locale: locale,
        digits: digits,
      ),
    ).thenAnswer(
      (_) async => const Success(LoginOutcome(session: session, flags: flags)),
    );
    when(() => repository.isOnboarded()).thenAnswer((_) async => const Success(false));

    final result = await RegisterUseCase(repository)(
      name: name,
      email: email,
      password: password,
      locale: locale,
      digits: digits,
    );

    expect(
      result,
      const Success(LoginResult(session: session, flags: flags, onboarded: false)),
    );
    verify(() => repository.isOnboarded()).called(1);
  });
}

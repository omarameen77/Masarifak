import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/result/result.dart';
import 'package:masarifak/features/auth/domain/entities/auth_session.dart';
import 'package:masarifak/features/auth/domain/entities/auth_user.dart';
import 'package:masarifak/features/auth/domain/entities/feature_flags.dart';
import 'package:masarifak/features/auth/domain/entities/login_outcome.dart';
import 'package:masarifak/features/auth/domain/entities/login_result.dart';
import 'package:masarifak/features/auth/domain/repositories/auth_repository.dart';
import 'package:masarifak/features/auth/domain/usecases/restore_account_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  const restoreToken = 'restore-token';
  const session = AuthSession(
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
    expiresInSeconds: 900,
    user: AuthUser(
      id: 'user-id',
      name: 'Test User',
      email: 'user@test.invalid',
      emailVerified: true,
    ),
  );
  const flags = FeatureFlags.empty();

  test('restore success runs the shared post-auth path', () async {
    final repository = MockAuthRepository();
    when(() => repository.restoreAccount(restoreToken: restoreToken)).thenAnswer(
      (_) async => const Success(LoginOutcome(session: session, flags: flags)),
    );
    when(() => repository.isOnboarded()).thenAnswer((_) async => const Success(true));

    final result = await RestoreAccountUseCase(repository)(restoreToken: restoreToken);

    expect(
      result,
      const Success(LoginResult(session: session, flags: flags, onboarded: true)),
    );
    verify(() => repository.isOnboarded()).called(1);
  });
}

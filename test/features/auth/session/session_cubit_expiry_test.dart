import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/result/result.dart';
import 'package:masarifak/core/session/session_expiry_notifier.dart';
import 'package:masarifak/core/storage/token_storage.dart';
import 'package:masarifak/features/auth/presentation/session/profile_onboarded_loader.dart';
import 'package:masarifak/features/auth/presentation/session/session_cubit.dart';
import 'package:masarifak/features/auth/presentation/session/session_state.dart';
import 'package:mocktail/mocktail.dart';

class MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  test('expiry event signs the session out and clears the token once', () async {
    final tokenStorage = MockTokenStorage();
    when(() => tokenStorage.clear()).thenAnswer((_) async {});
    final notifier = SessionExpiryNotifier();
    final cubit = SessionCubit(
      tokenStorage: tokenStorage,
      profileOnboarded: ProfileOnboardedLoader(() async => const Success(true)),
      sessionExpiryNotifier: notifier,
    );

    notifier.notifyExpired();
    await pumpEventQueue();

    expect(cubit.state, const SessionSignedOut());
    verify(() => tokenStorage.clear()).called(1);

    await cubit.close();
    await notifier.dispose();
  });

  test('closing the cubit stops listening to expiry events', () async {
    final tokenStorage = MockTokenStorage();
    when(() => tokenStorage.clear()).thenAnswer((_) async {});
    final notifier = SessionExpiryNotifier();
    final cubit = SessionCubit(
      tokenStorage: tokenStorage,
      profileOnboarded: ProfileOnboardedLoader(() async => const Success(true)),
      sessionExpiryNotifier: notifier,
    );

    await cubit.close();
    notifier.notifyExpired();
    await pumpEventQueue();

    verifyNever(() => tokenStorage.clear());
    await notifier.dispose();
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/error/failure.dart';
import 'package:masarifak/core/result/result.dart';
import 'package:masarifak/core/session/session_expiry_notifier.dart';
import 'package:masarifak/core/storage/token_storage.dart';
import 'package:masarifak/features/auth/domain/entities/auth_session.dart';
import 'package:masarifak/features/auth/domain/entities/auth_user.dart';
import 'package:masarifak/features/auth/domain/entities/feature_flags.dart';
import 'package:masarifak/features/auth/presentation/session/profile_onboarded_loader.dart';
import 'package:masarifak/features/auth/presentation/session/session_cubit.dart';
import 'package:masarifak/features/auth/presentation/session/session_state.dart';
import 'package:mocktail/mocktail.dart';

class MockTokenStorage extends Mock implements TokenStorage {}

enum Call { saveSession, profile }

void main() {
  const accessToken = 'access-token';
  const refreshToken = 'refresh-token';
  const askFlag = 'ask';
  const expiresInSeconds = 900;
  const user = AuthUser(
    id: 'user-id',
    name: 'Test User',
    emailVerified: true,
  );
  const session = AuthSession(
    accessToken: accessToken,
    refreshToken: refreshToken,
    expiresInSeconds: expiresInSeconds,
    user: user,
  );
  const flags = FeatureFlags({askFlag: true});

  late MockTokenStorage tokenStorage;
  late Result<bool> profileResult;
  late List<Call> calls;

  late SessionExpiryNotifier notifier;

  SessionCubit buildCubit() => SessionCubit(
    tokenStorage: tokenStorage,
    profileOnboarded: ProfileOnboardedLoader(() async {
      calls.add(Call.profile);
      return profileResult;
    }),
    sessionExpiryNotifier: notifier,
  );

  tearDown(() => notifier.dispose());

  setUp(() {
    notifier = SessionExpiryNotifier();
    tokenStorage = MockTokenStorage();
    calls = [];
    when(() => tokenStorage.clear()).thenAnswer((_) async {});
    when(
      () => tokenStorage.saveSession(
        accessToken: any(named: 'accessToken'),
        refreshToken: any(named: 'refreshToken'),
      ),
    ).thenAnswer((_) async => calls.add(Call.saveSession));
  });

  void givenToken(String? token) =>
      when(() => tokenStorage.readAccessToken()).thenAnswer((_) async => token);

  test('starts as SessionUnknown', () {
    expect(buildCubit().state, const SessionUnknown());
  });

  group('checkStartup', () {
    blocTest<SessionCubit, SessionState>(
      'no token emits SessionSignedOut without calling profile',
      setUp: () => givenToken(null),
      build: buildCubit,
      act: (cubit) => cubit.checkStartup(),
      expect: () => [const SessionSignedOut()],
      verify: (_) {
        expect(calls, isEmpty);
        verifyNever(() => tokenStorage.clear());
      },
    );

    blocTest<SessionCubit, SessionState>(
      'token and onboarded profile emits SessionSignedIn with empty flags',
      setUp: () {
        givenToken(accessToken);
        profileResult = const Success(true);
      },
      build: buildCubit,
      act: (cubit) => cubit.checkStartup(),
      expect: () => [const SessionSignedIn(FeatureFlags.empty())],
    );

    blocTest<SessionCubit, SessionState>(
      'token and profile not onboarded emits SessionNeedsOnboarding',
      setUp: () {
        givenToken(accessToken);
        profileResult = const Success(false);
      },
      build: buildCubit,
      act: (cubit) => cubit.checkStartup(),
      expect: () => [const SessionNeedsOnboarding()],
    );

    blocTest<SessionCubit, SessionState>(
      'token and UnauthorizedFailure emits SessionSignedOut and clears the token',
      setUp: () {
        givenToken(accessToken);
        profileResult = const Error(UnauthorizedFailure());
      },
      build: buildCubit,
      act: (cubit) => cubit.checkStartup(),
      expect: () => [const SessionSignedOut()],
      verify: (_) => verify(() => tokenStorage.clear()).called(1),
    );

    blocTest<SessionCubit, SessionState>(
      'token and NetworkFailure emits SessionSignedOut and keeps the token',
      setUp: () {
        givenToken(accessToken);
        profileResult = const Error(NetworkFailure());
      },
      build: buildCubit,
      act: (cubit) => cubit.checkStartup(),
      expect: () => [const SessionSignedOut()],
      verify: (_) => verifyNever(() => tokenStorage.clear()),
    );
  });

  group('onSignedIn', () {
    blocTest<SessionCubit, SessionState>(
      'saves the tokens before calling profile',
      setUp: () => profileResult = const Success(true),
      build: buildCubit,
      act: (cubit) => cubit.onSignedIn(session, flags),
      verify: (_) {
        expect(calls, [Call.saveSession, Call.profile]);
        verify(
          () => tokenStorage.saveSession(
            accessToken: accessToken,
            refreshToken: refreshToken,
          ),
        ).called(1);
      },
    );

    blocTest<SessionCubit, SessionState>(
      'onboarded profile emits SessionSignedIn with the login flags',
      setUp: () => profileResult = const Success(true),
      build: buildCubit,
      act: (cubit) => cubit.onSignedIn(session, flags),
      expect: () => [const SessionSignedIn(flags)],
    );

    blocTest<SessionCubit, SessionState>(
      'profile not onboarded emits SessionNeedsOnboarding',
      setUp: () => profileResult = const Success(false),
      build: buildCubit,
      act: (cubit) => cubit.onSignedIn(session, flags),
      expect: () => [const SessionNeedsOnboarding()],
    );

    blocTest<SessionCubit, SessionState>(
      'UnauthorizedFailure emits SessionSignedOut and clears the token',
      setUp: () => profileResult = const Error(UnauthorizedFailure()),
      build: buildCubit,
      act: (cubit) => cubit.onSignedIn(session, flags),
      expect: () => [const SessionSignedOut()],
      verify: (cubit) {
        verify(() => tokenStorage.clear()).called(1);
        expect(cubit.flags, const FeatureFlags.empty());
      },
    );

    blocTest<SessionCubit, SessionState>(
      'NetworkFailure emits SessionSignedOut and keeps the token',
      setUp: () => profileResult = const Error(NetworkFailure()),
      build: buildCubit,
      act: (cubit) => cubit.onSignedIn(session, flags),
      expect: () => [const SessionSignedOut()],
      verify: (_) => verifyNever(() => tokenStorage.clear()),
    );
  });

  test('logout clears the token, emits SessionSignedOut and drops flags', () async {
    profileResult = const Success(true);
    final cubit = buildCubit();
    await cubit.onSignedIn(session, flags);
    expect(cubit.flags.isEnabled(askFlag), isTrue);

    await cubit.logout();

    expect(cubit.state, const SessionSignedOut());
    expect(cubit.flags, const FeatureFlags.empty());
    verify(() => tokenStorage.clear()).called(1);
  });

  test('flags are not persisted across cubit instances', () async {
    profileResult = const Success(true);
    givenToken(accessToken);
    final first = buildCubit();
    await first.onSignedIn(session, flags);
    expect(first.flags.isEnabled(askFlag), isTrue);

    final second = buildCubit();
    await second.checkStartup();

    expect(second.state, const SessionSignedIn(FeatureFlags.empty()));
    expect(second.flags.isEnabled(askFlag), isFalse);
  });
}

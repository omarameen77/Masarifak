import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:masarifak/app/placeholder_screen.dart';
import 'package:masarifak/app/router/app_router.dart';
import 'package:masarifak/core/constants/app_durations.dart';
import 'package:masarifak/core/constants/app_motion.dart';
import 'package:masarifak/core/constants/app_assets.dart';
import 'package:masarifak/core/constants/app_locales.dart';
import 'package:masarifak/core/constants/app_routes.dart';
import 'package:masarifak/core/constants/translation_keys.dart';
import 'package:masarifak/core/di/injection.dart';
import 'package:masarifak/core/theme/app_colors.dart';
import 'package:masarifak/core/theme/app_theme.dart';
import 'package:masarifak/features/auth/domain/entities/feature_flags.dart';
import 'package:masarifak/features/auth/domain/usecases/login_usecase.dart';
import 'package:masarifak/features/auth/domain/usecases/register_usecase.dart';
import 'package:masarifak/features/auth/presentation/login/login_cubit.dart';
import 'package:masarifak/features/auth/presentation/login/login_screen.dart';
import 'package:masarifak/features/auth/presentation/register/register_cubit.dart';
import 'package:masarifak/features/auth/presentation/register/register_screen.dart';
import 'package:masarifak/features/auth/presentation/session/session_cubit.dart';
import 'package:masarifak/features/auth/presentation/session/session_state.dart';
import 'package:masarifak/core/id/id_generator.dart';
import 'package:masarifak/core/time/clock.dart';
import 'package:masarifak/features/onboarding/data/local_onboarding_repository.dart';
import 'package:masarifak/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:masarifak/features/onboarding/domain/usecases/get_currencies_usecase.dart';
import 'package:masarifak/features/onboarding/domain/usecases/preview_onboarding_usecase.dart';
import 'package:masarifak/features/onboarding/presentation/onboarding_cubit.dart';
import 'package:masarifak/features/onboarding/presentation/onboarding_shell.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

const _maxLoadAttempts = 50;
const _loadPollInterval = Duration(milliseconds: 20);

late Map<String, dynamic> arabic;

String arabicText(String key) => arabic[key] as String;

Widget buildApp(GoRouter router, SessionCubit sessionCubit) => EasyLocalization(
  supportedLocales: AppLocales.supported,
  path: AppAssets.translationsPath,
  fallbackLocale: AppLocales.fallback,
  startLocale: AppLocales.arabic,
  useOnlyLangCode: true,
  ignorePluralRules: false,
  saveLocale: true,
  child: Builder(
    builder: (context) => BlocProvider<SessionCubit>.value(
      value: sessionCubit,
      child: MaterialApp.router(
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        theme: AppTheme.build(AppColors.light),
        routerConfig: router,
      ),
    ),
  ),
);

Future<GoRouter> pumpApp(
  WidgetTester tester, {
  MockSessionCubit? session,
  SessionState initialState = const SessionSignedOut(),
  Finder? until,
}) async {
  final sessionCubit = session ?? MockSessionCubit();
  whenListen(
    sessionCubit,
    const Stream<SessionState>.empty(),
    initialState: initialState,
  );
  final refresh = ChangeNotifier();
  addTearDown(refresh.dispose);
  final router = createAppRouter(
    sessionCubit: sessionCubit,
    refreshListenable: refresh,
  );
  addTearDown(router.dispose);

  final screen = until ?? find.byType(LoginScreen);
  await tester.runAsync(
    () => tester.pumpWidget(buildApp(router, sessionCubit)),
  );
  for (var i = 0; i < _maxLoadAttempts && screen.evaluate().isEmpty; i++) {
    await tester.runAsync(() => Future<void>.delayed(_loadPollInterval));
    await tester.pump();
  }
  await tester.pumpAndSettle();
  expect(screen, findsOneWidget);
  return router;
}

String currentPath(GoRouter router) =>
    router.routerDelegate.currentConfiguration.last.matchedLocation;

Future<void> tapText(WidgetTester tester, String key) async {
  final finder = find.text(arabicText(key));
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    EasyLocalization.logger.enableBuildModes = [];
    arabic =
        jsonDecode(
              await File(
                AppAssets.translationFile(AppLocales.arabic),
              ).readAsString(),
            )
            as Map<String, dynamic>;
  });

  setUp(() {
    final localRepository = LocalOnboardingRepository(Clock());
    getIt.registerFactory<OnboardingCubit>(
      () => OnboardingCubit(
        GetCurrenciesUseCase(localRepository),
        PreviewOnboardingUseCase(localRepository),
        CompleteOnboardingUseCase(localRepository),
        IdGenerator(),
        Clock(),
      ),
    );
    getIt.registerFactory<LoginCubit>(() => LoginCubit(MockLoginUseCase()));
    getIt.registerFactory<RegisterCubit>(
      () => RegisterCubit(MockRegisterUseCase()),
    );
  });

  tearDown(getIt.reset);

  testWidgets('initial location is login', (tester) async {
    final router = await pumpApp(tester);

    expect(currentPath(router), AppRoutes.login);
  });

  testWidgets('register slides in and slides back out', (tester) async {
    await pumpApp(tester);

    final link = find.text(arabicText(TranslationKeys.loginRegisterLink));
    await tester.ensureVisible(link);
    await tester.pumpAndSettle();
    await tester.tap(link);
    await tester.pump();
    await tester.pump(AppMotion.pageSlideDuration ~/ 4);
    expect(tester.getTopLeft(find.byType(RegisterScreen)).dx, lessThan(0));
    expect(tester.getTopLeft(find.byType(LoginScreen)).dx, greaterThan(0));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byType(RegisterScreen)).dx, 0);

    await tester.tap(find.byType(BackButton));
    await tester.pump();
    await tester.pump(AppMotion.pageSlideReverseDuration ~/ 4);
    expect(tester.getTopLeft(find.byType(RegisterScreen)).dx, lessThan(0));
    await tester.pumpAndSettle();
    expect(find.byType(RegisterScreen), findsNothing);
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  Future<void> openRegister(WidgetTester tester) async {
    await pumpApp(tester);
    await tapText(tester, TranslationKeys.loginRegisterLink);
    expect(find.byType(RegisterScreen), findsOneWidget);
  }

  Offset startEdge(WidgetTester tester) {
    final size = tester.getSize(find.byType(RegisterScreen));
    return Offset(size.width - 2, size.height / 2);
  }

  testWidgets(
    'iOS swipe from the start edge returns to login',
    (tester) async {
      await openRegister(tester);
      final width = tester.getSize(find.byType(RegisterScreen)).width;

      await tester.dragFrom(startEdge(tester), Offset(-width * 0.6, 0));
      await tester.pumpAndSettle();

      expect(find.byType(RegisterScreen), findsNothing);
      expect(find.byType(LoginScreen), findsOneWidget);
    },
    variant: const TargetPlatformVariant({TargetPlatform.iOS}),
  );

  testWidgets(
    'iOS short slow swipe settles back on register',
    (tester) async {
      await openRegister(tester);
      final width = tester.getSize(find.byType(RegisterScreen)).width;

      await tester.timedDragFrom(
        startEdge(tester),
        Offset(-width * 0.2, 0),
        const Duration(seconds: 1),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RegisterScreen), findsOneWidget);
      expect(tester.getTopLeft(find.byType(RegisterScreen)).dx, 0);
    },
    variant: const TargetPlatformVariant({TargetPlatform.iOS}),
  );

  testWidgets(
    'Android has no edge swipe back',
    (tester) async {
      await openRegister(tester);
      final width = tester.getSize(find.byType(RegisterScreen)).width;

      await tester.dragFrom(startEdge(tester), Offset(-width * 0.6, 0));
      await tester.pumpAndSettle();

      expect(find.byType(RegisterScreen), findsOneWidget);
    },
    variant: const TargetPlatformVariant({TargetPlatform.android}),
  );

  testWidgets('needs onboarding lands on the income step inside the shell', (tester) async {
    final incomeTitle = find.text(
      arabicText(TranslationKeys.onboardingIncomeTitle),
    );
    final router = await pumpApp(
      tester,
      initialState: const SessionNeedsOnboarding(),
      until: incomeTitle,
    );

    expect(currentPath(router), AppRoutes.onboardingIncome);
    expect(find.byType(OnboardingShell), findsOneWidget);
  });

  testWidgets('onboarding steps push inside the shell and pop back', (tester) async {
    final router = await pumpApp(
      tester,
      initialState: const SessionNeedsOnboarding(),
      until: find.text(arabicText(TranslationKeys.onboardingIncomeTitle)),
    );
    final cubit = BlocProvider.of<OnboardingCubit>(
      tester.element(find.byType(OnboardingShell)),
    );

    router.push(AppRoutes.onboardingObligations);
    await tester.pumpAndSettle();
    expect(currentPath(router), AppRoutes.onboardingObligations);
    expect(
      BlocProvider.of<OnboardingCubit>(
        tester.element(find.byType(OnboardingShell)),
      ),
      same(cubit),
    );

    router.pop();
    await tester.pumpAndSettle();
    expect(currentPath(router), AppRoutes.onboardingIncome);
  });

  testWidgets('onboarding back arrow shows from step two and pops', (tester) async {
    final router = await pumpApp(
      tester,
      initialState: const SessionNeedsOnboarding(),
      until: find.text(arabicText(TranslationKeys.onboardingIncomeTitle)),
    );
    expect(find.byIcon(Icons.arrow_back), findsNothing);

    router.push(AppRoutes.onboardingObligations);
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(currentPath(router), AppRoutes.onboardingIncome);
    expect(find.byIcon(Icons.arrow_back), findsNothing);
  });

  testWidgets('home is shown with a fade transition', (tester) async {
    final sessionCubit = MockSessionCubit();
    final router = await pumpApp(tester, session: sessionCubit);

    when(
      () => sessionCubit.state,
    ).thenReturn(const SessionSignedIn(FeatureFlags.empty()));
    router.go(AppRoutes.home);
    await tester.pump();
    await tester.pump(AppDurations.pageFade ~/ 2);

    final fades = tester.widgetList<FadeTransition>(
      find.ancestor(
        of: find.byType(PlaceholderScreen),
        matching: find.byType(FadeTransition),
      ),
    );
    expect(
      fades.any((fade) => fade.opacity.value > 0 && fade.opacity.value < 1),
      isTrue,
    );

    await tester.pumpAndSettle();
    expect(find.byType(PlaceholderScreen), findsOneWidget);
  });

  testWidgets('register link opens register and back returns to login', (
    tester,
  ) async {
    final router = await pumpApp(tester);

    await tapText(tester, TranslationKeys.loginRegisterLink);
    expect(find.byType(RegisterScreen), findsOneWidget);
    expect(currentPath(router), AppRoutes.register);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(currentPath(router), AppRoutes.login);
  });

  testWidgets('login link on register pops back to login', (tester) async {
    final router = await pumpApp(tester);

    await tapText(tester, TranslationKeys.loginRegisterLink);
    expect(find.byType(RegisterScreen), findsOneWidget);

    await tapText(tester, TranslationKeys.registerLoginLink);
    expect(find.byType(RegisterScreen), findsNothing);
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(currentPath(router), AppRoutes.login);
  });
}

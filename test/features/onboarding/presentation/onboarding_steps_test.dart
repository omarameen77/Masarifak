import 'package:bloc_test/bloc_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:masarifak/app/router/app_router.dart';
import 'package:masarifak/core/constants/app_assets.dart';
import 'package:masarifak/core/constants/app_locales.dart';
import 'package:masarifak/core/constants/app_routes.dart';
import 'package:masarifak/core/constants/translation_keys.dart';
import 'package:masarifak/core/di/injection.dart';
import 'package:masarifak/core/error/failure.dart';
import 'package:masarifak/core/formatting/app_number_format.dart';
import 'package:masarifak/core/result/result.dart';
import 'package:masarifak/core/id/id_generator.dart';
import 'package:masarifak/core/theme/app_colors.dart';
import 'package:masarifak/core/theme/app_theme.dart';
import 'package:masarifak/core/time/clock.dart';
import 'package:masarifak/features/auth/presentation/session/session_cubit.dart';
import 'package:masarifak/features/auth/presentation/session/session_state.dart';
import 'package:masarifak/features/onboarding/data/local_onboarding_repository.dart';
import 'package:masarifak/features/onboarding/domain/entities/obligation_kind.dart';
import 'package:masarifak/features/onboarding/domain/entities/onboarding_draft.dart';
import 'package:masarifak/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:masarifak/features/onboarding/domain/usecases/get_currencies_usecase.dart';
import 'package:masarifak/features/onboarding/domain/usecases/preview_onboarding_usecase.dart';
import 'package:masarifak/features/onboarding/presentation/obligations/widgets/obligation_sheet.dart';
import 'package:masarifak/features/onboarding/presentation/onboarding_cubit.dart';
import 'package:masarifak/features/onboarding/presentation/onboarding_shell.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/localized_app.dart';

class MockSessionCubit extends MockCubit<SessionState> implements SessionCubit {}

class MockClock extends Mock implements Clock {}

const _maxLoadAttempts = 50;
const _loadPollInterval = Duration(milliseconds: 20);
const _phoneSize = Size(390, 844);

late Map<String, dynamic> arabic;
late MockSessionCubit session;

String ar(String key) => arabic[key] as String;

Future<GoRouter> pumpOnboarding(WidgetTester tester) async {
  tester.view.physicalSize = _phoneSize;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  session = MockSessionCubit();
  whenListen(
    session,
    const Stream<SessionState>.empty(),
    initialState: const SessionNeedsOnboarding(),
  );
  final refresh = ChangeNotifier();
  addTearDown(refresh.dispose);
  final router = createAppRouter(sessionCubit: session, refreshListenable: refresh);
  addTearDown(router.dispose);

  final title = find.text(ar(TranslationKeys.onboardingIncomeTitle));
  await tester.runAsync(
    () => tester.pumpWidget(
      EasyLocalization(
        supportedLocales: AppLocales.supported,
        path: AppAssets.translationsPath,
        fallbackLocale: AppLocales.fallback,
        startLocale: AppLocales.arabic,
        useOnlyLangCode: true,
        ignorePluralRules: false,
        saveLocale: false,
        child: Builder(
          builder: (context) => BlocProvider<SessionCubit>.value(
            value: session,
            child: MaterialApp.router(
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              theme: AppTheme.build(AppColors.light),
              routerConfig: router,
            ),
          ),
        ),
      ),
    ),
  );
  for (var i = 0; i < _maxLoadAttempts && title.evaluate().isEmpty; i++) {
    await tester.runAsync(() => Future<void>.delayed(_loadPollInterval));
    await tester.pump();
  }
  await tester.pumpAndSettle();
  expect(title, findsOneWidget);
  return router;
}

OnboardingCubit cubitOf(WidgetTester tester) => BlocProvider.of<OnboardingCubit>(
  tester.element(find.byType(OnboardingShell)),
);

String currentPath(GoRouter router) =>
    router.routerDelegate.currentConfiguration.last.matchedLocation;

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Finder fieldWithLabel(String key) => find.descendant(
  of: find.ancestor(
    of: find.text(ar(key)),
    matching: find.byType(Column),
  ).first,
  matching: find.byType(TextField),
);

Future<void> goToObligations(WidgetTester tester) async {
  await tester.enterText(find.byType(TextField).first, '5000');
  await tapVisible(tester, find.text(ar(TranslationKeys.onboardingNext)));
  expect(find.text(ar(TranslationKeys.onboardingObligationsTitle)), findsOneWidget);
}

void main() {
  setUpAll(() async {
    arabic = await readArabicTranslations();
    registerFallbackValue(FakeOnboardingDraft());
  });

  setUp(() {
    final clock = MockClock();
    when(clock.now).thenReturn(DateTime(2026, 10, 30));
    final repository = LocalOnboardingRepository(clock);
    getIt.registerFactory<OnboardingCubit>(
      () => OnboardingCubit(
        GetCurrenciesUseCase(repository),
        PreviewOnboardingUseCase(repository),
        CompleteOnboardingUseCase(repository),
        IdGenerator(),
        clock,
      ),
    );
  });

  tearDown(getIt.reset);

  group('income step', () {
    testWidgets('next with an empty salary shows the salary error and stays', (tester) async {
      final router = await pumpOnboarding(tester);

      await tapVisible(tester, find.text(ar(TranslationKeys.onboardingNext)));

      expect(find.text(ar(TranslationKeys.validationSalaryInvalid)), findsOneWidget);
      expect(currentPath(router), AppRoutes.onboardingIncome);
    });

    testWidgets('the cycle explanation follows the selected payday', (tester) async {
      await pumpOnboarding(tester);

      expect(find.textContaining('١ أكتوبر'), findsOneWidget);
      expect(find.textContaining('٣١ أكتوبر'), findsOneWidget);
      expect(find.textContaining('٣١ يوم'), findsOneWidget);

      await tapVisible(tester, find.text('٢٥'));

      expect(find.textContaining('٢٥ أكتوبر'), findsOneWidget);
      expect(find.textContaining('٢٤ نوفمبر'), findsOneWidget);
    });

    testWidgets('another day shows a day field that drives the cycle', (tester) async {
      await pumpOnboarding(tester);

      await tapVisible(tester, find.text(ar(TranslationKeys.onboardingPaydayOther)));
      expect(find.text(ar(TranslationKeys.onboardingPaydayDayLabel)), findsOneWidget);

      await tester.enterText(find.byType(TextField).at(1), '١٠');
      await tester.pumpAndSettle();

      expect(find.textContaining('١٠ أكتوبر'), findsOneWidget);
      expect(find.textContaining('٩ نوفمبر'), findsOneWidget);
    });

    testWidgets('a valid salary and payday are saved and open step two', (tester) async {
      final router = await pumpOnboarding(tester);

      await tester.enterText(find.byType(TextField).first, '٥٠٠٠');
      await tapVisible(tester, find.text('١٥'));
      await tapVisible(tester, find.text(ar(TranslationKeys.onboardingNext)));

      expect(currentPath(router), AppRoutes.onboardingObligations);
      final state = cubitOf(tester).state;
      expect(state.salaryMinor, 500000);
      expect(state.payday, 15);
    });
  });

  group('obligations step', () {
    testWidgets('with no obligations the footer offers skip', (tester) async {
      await pumpOnboarding(tester);
      await goToObligations(tester);

      expect(find.text(ar(TranslationKeys.onboardingSkip)), findsOneWidget);
      expect(find.text(ar(TranslationKeys.onboardingNext)), findsNothing);
    });

    testWidgets('saving an empty sheet shows the field errors', (tester) async {
      await pumpOnboarding(tester);
      await goToObligations(tester);

      await tapVisible(tester, find.text(ar(TranslationKeys.onboardingAddObligation)));
      await tapVisible(tester, find.text(ar(TranslationKeys.obligationSave)));

      expect(find.text(ar(TranslationKeys.validationObligationName)), findsOneWidget);
      expect(find.text(ar(TranslationKeys.validationAmountInvalid)), findsOneWidget);
      expect(find.text(ar(TranslationKeys.validationDayInvalid)), findsOneWidget);
      expect(find.byType(ObligationSheet), findsOneWidget);
    });

    testWidgets('adding a fixed obligation lists it with the monthly total', (tester) async {
      await pumpOnboarding(tester);
      await goToObligations(tester);

      await tapVisible(tester, find.text(ar(TranslationKeys.onboardingAddObligation)));
      await tester.enterText(fieldWithLabel(TranslationKeys.obligationNameLabel), 'إيجار');
      await tester.enterText(
        fieldWithLabel(TranslationKeys.obligationMonthlyAmount),
        '3000',
      );
      await tester.enterText(fieldWithLabel(TranslationKeys.obligationDueDayLabel), '5');
      await tapVisible(tester, find.text(ar(TranslationKeys.obligationSave)));

      expect(find.byType(ObligationSheet), findsNothing);
      expect(find.text('إيجار'), findsOneWidget);
      expect(find.text(ar(TranslationKeys.onboardingReservedTotal)), findsOneWidget);
      expect(find.text(ar(TranslationKeys.onboardingNext)), findsOneWidget);
      final obligation = cubitOf(tester).state.obligations.single;
      expect(obligation.amountMinor, 300000);
      expect(obligation.dueDay, 5);
      expect(obligation.clientId, isNotEmpty);
    });

    testWidgets('a periodic obligation reserves its amount over the interval', (tester) async {
      await pumpOnboarding(tester);
      await goToObligations(tester);

      await tapVisible(tester, find.text(ar(TranslationKeys.onboardingAddObligation)));
      await tapVisible(tester, find.text(ar(TranslationKeys.obligationKindPeriodic)));
      expect(find.text(ar(TranslationKeys.obligationTotalAmount)), findsOneWidget);
      expect(find.text(ar(TranslationKeys.obligationNextDueLabel)), findsOneWidget);

      await tester.enterText(fieldWithLabel(TranslationKeys.obligationNameLabel), 'تأمين');
      await tester.enterText(
        fieldWithLabel(TranslationKeys.obligationTotalAmount),
        '1200',
      );
      await tapVisible(tester, find.text(ar(TranslationKeys.obligationEvery6)));
      await tester.enterText(fieldWithLabel(TranslationKeys.obligationDueDayLabel), '10');
      await tapVisible(tester, find.text(ar(TranslationKeys.obligationSave)));

      final obligation = cubitOf(tester).state.obligations.single;
      expect(obligation.kind, ObligationKind.periodic);
      expect(obligation.amountMinor, 120000);
      expect(obligation.everyMonths, 6);
      expect(obligation.monthlyShareMinor, 20000);
      expect(obligation.nextDueOn, DateTime.utc(2026, 11, 10));
    });

    testWidgets('tapping an obligation opens edit and delete removes it', (tester) async {
      await pumpOnboarding(tester);
      await goToObligations(tester);

      await tapVisible(tester, find.text(ar(TranslationKeys.onboardingAddObligation)));
      await tester.enterText(fieldWithLabel(TranslationKeys.obligationNameLabel), 'نت');
      await tester.enterText(
        fieldWithLabel(TranslationKeys.obligationMonthlyAmount),
        '400',
      );
      await tester.enterText(fieldWithLabel(TranslationKeys.obligationDueDayLabel), '3');
      await tapVisible(tester, find.text(ar(TranslationKeys.obligationSave)));

      await tapVisible(tester, find.text('نت'));
      expect(find.text(ar(TranslationKeys.obligationEditTitle)), findsOneWidget);

      await tapVisible(tester, find.text(ar(TranslationKeys.obligationDelete)));

      expect(cubitOf(tester).state.obligations, isEmpty);
      expect(find.text(ar(TranslationKeys.onboardingSkip)), findsOneWidget);
    });

    testWidgets('skip opens the safety step', (tester) async {
      final router = await pumpOnboarding(tester);
      await goToObligations(tester);

      await tapVisible(tester, find.text(ar(TranslationKeys.onboardingSkip)));

      expect(currentPath(router), AppRoutes.onboardingSafety);
    });
  });

  group('safety step', () {
    testWidgets('minimum starts at 20% of salary and mid-cycle asks what was spent', (tester) async {
      await pumpOnboarding(tester);
      await goToSafety(tester);

      expect(fieldText(tester, TranslationKeys.safetyMinLabel), '1000');
      expect(
        find.textContaining(money(100000, rounded: true)),
        findsOneWidget,
      );
      expect(find.textContaining('١ أكتوبر'), findsOneWidget);
    });

    testWidgets('next saves the safety numbers and opens the summary', (tester) async {
      final router = await pumpOnboarding(tester);
      await goToSafety(tester);
      await fillSafety(tester, savings: '500', spent: '1500');

      expect(currentPath(router), AppRoutes.onboardingSummary);
      final state = cubitOf(tester).state;
      expect(state.safetyBalanceMinor, 100000);
      expect(state.savingsContributionMinor, 50000);
      expect(state.spentSoFarMinor, 150000);
    });
  });

  group('summary step', () {
    testWidgets('shows the preview breakdown and the daily allowance', (tester) async {
      await pumpOnboarding(tester);
      await goToSafety(tester);
      await fillSafety(tester, savings: '500', spent: '1500');

      expect(find.text(money(450000)), findsOneWidget);
      expect(find.text(ar(TranslationKeys.summaryRemaining)), findsOneWidget);
      expect(find.text(money(300000)), findsOneWidget);
      expect(find.text(money(100000, rounded: true)), findsOneWidget);
      expect(find.text('يومين'), findsOneWidget);
      expect(find.text('١ نوفمبر'), findsOneWidget);
      expect(find.text(ar(TranslationKeys.summaryOverIncome)), findsNothing);
    });

    testWidgets('warns when commitments exceed income', (tester) async {
      await pumpOnboarding(tester);
      await goToSafety(tester);
      await fillSafety(tester, savings: '5000', spent: '');

      expect(find.text(ar(TranslationKeys.summaryOverIncome)), findsOneWidget);
    });

    testWidgets('start completes onboarding through the session', (tester) async {
      await pumpOnboarding(tester);
      await goToSafety(tester);
      await fillSafety(tester, savings: '0', spent: '');

      await tapVisible(tester, find.text(ar(TranslationKeys.summaryStart)));

      verify(() => session.completeOnboarding()).called(1);
    });

    testWidgets('a 422 on step two shows the error and returns to that step', (tester) async {
      final clock = MockClock();
      when(clock.now).thenReturn(DateTime(2026, 10, 30));
      final repository = LocalOnboardingRepository(clock);
      final complete = MockCompleteOnboarding();
      when(
        () => complete(any(), idempotencyKey: any(named: 'idempotencyKey')),
      ).thenAnswer((_) async => const Error(ValidationFailure(null, step: 2)));
      getIt.unregister<OnboardingCubit>();
      getIt.registerFactory<OnboardingCubit>(
        () => OnboardingCubit(
          GetCurrenciesUseCase(repository),
          PreviewOnboardingUseCase(repository),
          complete,
          IdGenerator(),
          clock,
        ),
      );
      final router = await pumpOnboarding(tester);
      await goToSafety(tester);
      await fillSafety(tester, savings: '0', spent: '');

      await tapVisible(tester, find.text(ar(TranslationKeys.summaryStart)));
      expect(find.text(ar(TranslationKeys.errorValidation)), findsOneWidget);

      await tapVisible(tester, find.text(ar(TranslationKeys.errorDialogAction)));

      expect(currentPath(router), AppRoutes.onboardingObligations);
      verifyNever(() => session.completeOnboarding());
    });
  });
}

class MockCompleteOnboarding extends Mock implements CompleteOnboardingUseCase {}

class FakeOnboardingDraft extends Fake implements OnboardingDraft {}

String money(int minor, {bool rounded = false}) => AppNumberFormat(
  AppLocales.arabic,
).money(minor, exponent: 2, symbol: 'ج.م', rounded: rounded);

String fieldText(WidgetTester tester, String labelKey) =>
    tester.widget<TextField>(fieldWithLabel(labelKey)).controller!.text;

Future<void> goToSafety(WidgetTester tester) async {
  await goToObligations(tester);
  await tapVisible(tester, find.text(ar(TranslationKeys.onboardingSkip)));
  expect(find.text(ar(TranslationKeys.onboardingSafetyTitle)), findsOneWidget);
}

Future<void> fillSafety(
  WidgetTester tester, {
  required String savings,
  required String spent,
}) async {
  await tester.enterText(fieldWithLabel(TranslationKeys.safetySavingsLabel), savings);
  await tester.enterText(
    find.byType(TextField).last,
    spent,
  );
  await tapVisible(tester, find.text(ar(TranslationKeys.onboardingNext)));
  expect(find.text(ar(TranslationKeys.onboardingSummaryTitle)), findsOneWidget);
}

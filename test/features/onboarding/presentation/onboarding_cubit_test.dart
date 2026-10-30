import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/constants/api_error_codes.dart';
import 'package:masarifak/core/error/failure.dart';
import 'package:masarifak/core/id/id_generator.dart';
import 'package:masarifak/core/result/result.dart';
import 'package:masarifak/core/time/clock.dart';
import 'package:masarifak/features/onboarding/domain/entities/currency.dart';
import 'package:masarifak/features/onboarding/domain/entities/obligation_category.dart';
import 'package:masarifak/features/onboarding/domain/entities/obligation_draft.dart';
import 'package:masarifak/features/onboarding/domain/entities/obligation_kind.dart';
import 'package:masarifak/features/onboarding/domain/entities/onboarding_draft.dart';
import 'package:masarifak/features/onboarding/domain/entities/onboarding_result.dart';
import 'package:masarifak/features/onboarding/domain/entities/onboarding_summary.dart';
import 'package:masarifak/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:masarifak/features/onboarding/domain/usecases/get_currencies_usecase.dart';
import 'package:masarifak/features/onboarding/domain/usecases/preview_onboarding_usecase.dart';
import 'package:masarifak/features/onboarding/presentation/onboarding_cubit.dart';
import 'package:masarifak/features/onboarding/presentation/onboarding_intent.dart';
import 'package:masarifak/features/onboarding/presentation/onboarding_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCurrencies extends Mock implements GetCurrenciesUseCase {}

class MockPreview extends Mock implements PreviewOnboardingUseCase {}

class MockComplete extends Mock implements CompleteOnboardingUseCase {}

class MockIdGenerator extends Mock implements IdGenerator {}

class FakeDraft extends Fake implements OnboardingDraft {}

void main() {
  const egp = Currency(
    code: 'EGP',
    symbol: 'ج.م',
    exponent: 2,
    paydayPresets: [1, 10, 15, 25],
    defaultWeekStart: 6,
  );
  const rent = ObligationDraft(
    clientId: '',
    name: 'Rent',
    kind: ObligationKind.fixed,
    category: ObligationCategory.housing,
    amountMinor: 300000,
    dueDay: 1,
  );
  const result = OnboardingResult(
    summary: OnboardingSummary(
      remainingMinor: 100000,
      spendableMinor: 100000,
      spentMinor: 0,
      reservedMinor: 300000,
      savingsMinor: 0,
      dailyBudgetMinor: 0,
      status: SummaryStatus.critical,
    ),
    obligationIds: {},
    warnings: [],
  );
  const filled = OnboardingState(
    salaryMinor: 500000,
    payday: 25,
    safetyBalanceMinor: 100000,
  );

  late MockGetCurrencies getCurrencies;
  late MockPreview preview;
  late MockComplete complete;
  late MockIdGenerator ids;

  setUpAll(() => registerFallbackValue(FakeDraft()));

  setUp(() {
    getCurrencies = MockGetCurrencies();
    preview = MockPreview();
    complete = MockComplete();
    ids = MockIdGenerator();
  });

  OnboardingCubit build() =>
      OnboardingCubit(getCurrencies, preview, complete, ids, Clock());

  blocTest<OnboardingCubit, OnboardingState>(
    'started uses the currency from the API',
    setUp: () => when(getCurrencies.call).thenAnswer(
      (_) async => const Success([egp]),
    ),
    build: build,
    act: (cubit) => cubit.doEvent(const OnboardingStarted()),
    expect: () => [const OnboardingState(currency: egp)],
  );

  blocTest<OnboardingCubit, OnboardingState>(
    'started keeps the fallback currency when the API fails',
    setUp: () => when(getCurrencies.call).thenAnswer(
      (_) async => const Error(NetworkFailure()),
    ),
    build: build,
    act: (cubit) => cubit.doEvent(const OnboardingStarted()),
    expect: () => <OnboardingState>[],
    verify: (cubit) =>
        expect(cubit.state.currency, OnboardingState.fallbackCurrency),
  );

  blocTest<OnboardingCubit, OnboardingState>(
    'income is kept in the draft',
    build: build,
    act: (cubit) =>
        cubit.doEvent(const IncomeSubmitted(salaryMinor: 500000, payday: 25)),
    expect: () => [const OnboardingState(salaryMinor: 500000, payday: 25)],
  );

  blocTest<OnboardingCubit, OnboardingState>(
    'added obligations get a client id, can be updated and removed',
    setUp: () => when(ids.next).thenReturn('c-1'),
    build: build,
    act: (cubit) {
      cubit.doEvent(const ObligationAdded(rent));
      cubit.doEvent(
        ObligationUpdated(
          rent.copyWith(clientId: 'c-1').copyWithAmountForTest(350000),
        ),
      );
      cubit.doEvent(const ObligationRemoved('c-1'));
    },
    expect: () => [
      OnboardingState(obligations: [rent.copyWith(clientId: 'c-1')]),
      OnboardingState(
        obligations: [rent.copyWith(clientId: 'c-1').copyWithAmountForTest(350000)],
      ),
      const OnboardingState(),
    ],
  );

  blocTest<OnboardingCubit, OnboardingState>(
    'preview stores the result',
    setUp: () =>
        when(() => preview(any())).thenAnswer((_) async => const Success(result)),
    build: build,
    seed: () => filled,
    act: (cubit) => cubit.doEvent(const PreviewRequested()),
    expect: () => [
      filled.copyWith(isPreviewing: true),
      filled.copyWith(preview: result),
    ],
  );

  blocTest<OnboardingCubit, OnboardingState>(
    'preview without a complete draft does nothing',
    build: build,
    act: (cubit) => cubit.doEvent(const PreviewRequested()),
    expect: () => <OnboardingState>[],
  );

  blocTest<OnboardingCubit, OnboardingState>(
    'retrying a failed completion reuses the idempotency key',
    setUp: () {
      when(ids.next).thenReturn('key-1');
      when(
        () => complete(any(), idempotencyKey: any(named: 'idempotencyKey')),
      ).thenAnswer((_) async => const Error(NetworkFailure()));
    },
    build: build,
    seed: () => filled,
    act: (cubit) async {
      cubit.doEvent(const CompletionRequested());
      await Future<void>.delayed(Duration.zero);
      cubit.doEvent(const CompletionRequested());
    },
    verify: (_) {
      verify(() => complete(any(), idempotencyKey: 'key-1')).called(2);
      verify(ids.next).called(1);
    },
  );

  blocTest<OnboardingCubit, OnboardingState>(
    'already_onboarded counts as completed',
    setUp: () {
      when(ids.next).thenReturn('key-1');
      when(
        () => complete(any(), idempotencyKey: any(named: 'idempotencyKey')),
      ).thenAnswer(
        (_) async => const Error(ConflictFailure(ApiErrorCodes.alreadyOnboarded)),
      );
    },
    build: build,
    seed: () => filled,
    act: (cubit) => cubit.doEvent(const CompletionRequested()),
    expect: () => [
      filled.copyWith(isCompleting: true),
      filled.copyWith(isCompleted: true),
    ],
  );

  blocTest<OnboardingCubit, OnboardingState>(
    'a 422 keeps the failure with its step',
    setUp: () {
      when(ids.next).thenReturn('key-1');
      when(
        () => complete(any(), idempotencyKey: any(named: 'idempotencyKey')),
      ).thenAnswer((_) async => const Error(ValidationFailure(null, step: 2)));
    },
    build: build,
    seed: () => filled,
    act: (cubit) => cubit.doEvent(const CompletionRequested()),
    expect: () => [
      filled.copyWith(isCompleting: true),
      filled.copyWith(failure: const ValidationFailure(null, step: 2)),
    ],
  );
}

extension on ObligationDraft {
  ObligationDraft copyWithAmountForTest(int amountMinor) => ObligationDraft(
    clientId: clientId,
    name: name,
    kind: kind,
    category: category,
    amountMinor: amountMinor,
    dueDay: dueDay,
    everyMonths: everyMonths,
    nextDueOn: nextDueOn,
  );
}

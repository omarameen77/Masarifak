import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/error/failure.dart';
import 'package:masarifak/core/money/money_currency.dart';
import 'package:masarifak/core/result/result.dart';
import 'package:masarifak/core/time/clock.dart';
import 'package:masarifak/features/home/domain/entities/cycle_status.dart';
import 'package:masarifak/features/home/domain/entities/cycle_summary.dart';
import 'package:masarifak/features/home/domain/entities/home_profile.dart';
import 'package:masarifak/features/home/domain/entities/home_snapshot.dart';
import 'package:masarifak/features/home/domain/entities/recent_expense.dart';
import 'package:masarifak/features/home/domain/entities/savings_overview.dart';
import 'package:masarifak/features/home/domain/entities/upcoming_obligation.dart';
import 'package:masarifak/features/home/domain/usecases/load_home_usecase.dart';
import 'package:masarifak/features/home/presentation/home_cubit.dart';
import 'package:masarifak/features/home/presentation/home_intent.dart';
import 'package:masarifak/features/home/presentation/home_state.dart';
import 'package:mocktail/mocktail.dart';

class MockLoadHome extends Mock implements LoadHomeUseCase {}

class MockClock extends Mock implements Clock {}

void main() {
  final today = DateTime.utc(2026, 10, 30);
  const usd = MoneyCurrency(code: 'USD', symbol: r'$', exponent: 2);
  const summary = CycleSummary(
    remainingMinor: 325000,
    spendableMinor: 350000,
    spentMinor: 25000,
    reservedMinor: 495000,
    savingsMinor: 100000,
    dailyBudgetMinor: 9000,
    status: CycleStatus.ok,
    hasPendingReview: false,
  );
  const updatedSummary = CycleSummary(
    remainingMinor: 300000,
    spendableMinor: 350000,
    spentMinor: 50000,
    reservedMinor: 495000,
    savingsMinor: 100000,
    dailyBudgetMinor: 8000,
    status: CycleStatus.warn,
    hasPendingReview: false,
  );
  const profile = HomeProfile(unreadNotifications: 3, hasPendingReview: false);
  const savings = SavingsOverview(
    balanceMinor: 3050000,
    monthlyContributionMinor: 100000,
  );
  final obligations = [
    UpcomingObligation(
      id: 'ob-1',
      name: 'Rent',
      kind: UpcomingObligationKind.fixed,
      amountMinor: 300000,
      isEstimate: false,
      dueOn: DateTime.utc(2026, 11, 1),
      daysUntilDue: 2,
      status: ObligationDisplayStatus.reserved,
    ),
  ];
  final expenses = [
    RecentExpense(
      id: 'ex-1',
      amountMinor: 9500,
      merchant: 'Costa',
      categoryKey: 'food',
      categoryLabel: 'Food',
      spentOn: DateTime.utc(2026, 10, 30),
    ),
  ];

  HomeSnapshot snapshot({
    Result<CycleSummary> summaryResult = const Success(summary),
    Result<SavingsOverview> savingsResult = const Success(savings),
  }) => HomeSnapshot(
    summary: summaryResult,
    profile: const Success(profile),
    savings: savingsResult,
    obligations: Success(obligations),
    expenses: Success(RecentExpenses(items: expenses, currency: usd)),
  );

  final ready = HomeState(
    status: HomeStatus.ready,
    summary: summary,
    today: today,
    currency: usd,
    profile: const HomeSection(data: profile),
    savings: const HomeSection(data: savings),
    obligations: HomeSection(data: obligations),
    expenses: HomeSection(data: expenses),
  );

  late MockLoadHome loadHome;
  late MockClock clock;

  setUp(() {
    loadHome = MockLoadHome();
    clock = MockClock();
    when(clock.now).thenReturn(DateTime(2026, 10, 30, 14));
  });

  HomeCubit build() => HomeCubit(loadHome, clock);

  test('starts in the loading state', () {
    expect(build().state.status, HomeStatus.loading);
  });

  blocTest<HomeCubit, HomeState>(
    'first load fills every section from one snapshot',
    setUp: () => when(loadHome.call).thenAnswer((_) async => snapshot()),
    build: build,
    act: (cubit) => cubit.doEvent(const HomeStarted()),
    expect: () => [const HomeState(), ready],
  );

  blocTest<HomeCubit, HomeState>(
    'a failed summary on first load shows the failure screen',
    setUp: () => when(loadHome.call).thenAnswer(
      (_) async => snapshot(summaryResult: const Error(NetworkFailure())),
    ),
    build: build,
    act: (cubit) => cubit.doEvent(const HomeStarted()),
    verify: (cubit) {
      expect(cubit.state.status, HomeStatus.failure);
      expect(cubit.state.failure, const NetworkFailure());
      expect(cubit.state.summary, isNull);
    },
  );

  blocTest<HomeCubit, HomeState>(
    'a failed section keeps the screen ready and marks only that section',
    setUp: () => when(loadHome.call).thenAnswer(
      (_) async => snapshot(savingsResult: const Error(ServerFailure())),
    ),
    build: build,
    act: (cubit) => cubit.doEvent(const HomeStarted()),
    verify: (cubit) {
      expect(cubit.state.status, HomeStatus.ready);
      expect(cubit.state.savings.data, isNull);
      expect(cubit.state.savings.failure, const ServerFailure());
      expect(cubit.state.obligations.data, obligations);
    },
  );

  blocTest<HomeCubit, HomeState>(
    'refresh keeps the content visible and then shows the new numbers',
    setUp: () => when(loadHome.call).thenAnswer(
      (_) async => snapshot(summaryResult: const Success(updatedSummary)),
    ),
    seed: () => ready,
    build: build,
    act: (cubit) => cubit.doEvent(const HomeRefreshed()),
    expect: () => [
      ready.copyWith(isRefreshing: true),
      ready.copyWith(summary: updatedSummary),
    ],
  );

  blocTest<HomeCubit, HomeState>(
    'a failed refresh keeps the old data and reports the failure',
    setUp: () => when(loadHome.call).thenAnswer(
      (_) async => snapshot(
        summaryResult: const Error(TimeoutFailure()),
        savingsResult: const Error(TimeoutFailure()),
      ),
    ),
    seed: () => ready,
    build: build,
    act: (cubit) => cubit.doEvent(const HomeRefreshed()),
    verify: (cubit) {
      expect(cubit.state.status, HomeStatus.ready);
      expect(cubit.state.isRefreshing, isFalse);
      expect(cubit.state.summary, summary);
      expect(cubit.state.failure, const TimeoutFailure());
      expect(cubit.state.savings.data, savings);
      expect(cubit.state.savings.failure, const TimeoutFailure());
    },
  );

  blocTest<HomeCubit, HomeState>(
    'a second request while loading is ignored',
    setUp: () {
      final pending = Completer<HomeSnapshot>();
      when(loadHome.call).thenAnswer((_) => pending.future);
      Future<void>.delayed(Duration.zero, () => pending.complete(snapshot()));
    },
    seed: () => ready,
    build: build,
    act: (cubit) async {
      cubit
        ..doEvent(const HomeRefreshed())
        ..doEvent(const HomeRefreshed());
      await Future<void>.delayed(Duration.zero);
    },
    verify: (_) => verify(loadHome.call).called(1),
  );

  blocTest<HomeCubit, HomeState>(
    'retry after a failed first load shows the skeleton again',
    setUp: () => when(loadHome.call).thenAnswer((_) async => snapshot()),
    seed: () => const HomeState(
      status: HomeStatus.failure,
      failure: NetworkFailure(),
    ),
    build: build,
    act: (cubit) => cubit.doEvent(const HomeRetried()),
    expect: () => [const HomeState(), ready],
  );
}

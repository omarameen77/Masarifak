import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/result/result.dart';
import 'package:masarifak/core/time/clock.dart';
import 'package:masarifak/features/onboarding/data/local_onboarding_repository.dart';
import 'package:masarifak/features/onboarding/domain/entities/obligation_category.dart';
import 'package:masarifak/features/onboarding/domain/entities/obligation_draft.dart';
import 'package:masarifak/features/onboarding/domain/entities/obligation_kind.dart';
import 'package:masarifak/features/onboarding/domain/entities/onboarding_draft.dart';
import 'package:masarifak/features/onboarding/domain/entities/onboarding_result.dart';
import 'package:masarifak/features/onboarding/domain/entities/onboarding_summary.dart';
import 'package:mocktail/mocktail.dart';

class MockClock extends Mock implements Clock {}

void main() {
  const electricity = ObligationDraft(
    clientId: 'c-1',
    name: 'Electricity',
    kind: ObligationKind.fixed,
    category: ObligationCategory.bills,
    amountMinor: 50000,
    dueDay: 1,
  );

  OnboardingDraft draft({
    int savings = 500000,
    int safety = 100000,
    int spentSoFar = 150000,
  }) => OnboardingDraft(
    currencyCode: 'EGP',
    timezone: 'Africa/Cairo',
    weekStart: 6,
    salaryMinor: 500000,
    payday: 25,
    safetyBalanceMinor: safety,
    savingsContributionMinor: savings,
    savingsOpeningBalanceMinor: 0,
    spentSoFarMinor: spentSoFar,
    obligations: const [electricity],
  );

  late LocalOnboardingRepository repository;

  setUp(() {
    final clock = MockClock();
    when(clock.now).thenReturn(DateTime(2026, 10, 30));
    repository = LocalOnboardingRepository(clock);
  });

  test('preview follows the prototype summary formula', () async {
    final result = await repository.preview(draft(savings: 100000));

    final summary = ((result as Success).data as OnboardingResult).summary;
    expect(summary.reservedMinor, 50000);
    expect(summary.savingsMinor, 100000);
    expect(summary.spendableMinor, 350000);
    expect(summary.spentMinor, 150000);
    expect(summary.remainingMinor, 200000);
    expect(summary.dailyBudgetMinor, 100000 ~/ 26);
    expect(summary.status, SummaryStatus.ok);
  });

  test('commitments above income are critical with zero daily budget', () async {
    final result = await repository.preview(draft());

    final summary = ((result as Success).data as OnboardingResult).summary;
    expect(summary.spendableMinor, -50000);
    expect(summary.dailyBudgetMinor, 0);
    expect(summary.status, SummaryStatus.critical);
  });

  test('complete returns a local id for every obligation', () async {
    final result = await repository.complete(draft(), idempotencyKey: 'key-1');

    expect(
      ((result as Success).data as OnboardingResult).obligationIds,
      {'c-1': 'local-c-1'},
    );
  });
}

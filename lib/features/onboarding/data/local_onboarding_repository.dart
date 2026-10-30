import 'dart:math';

import 'package:injectable/injectable.dart';

import '../../../core/constants/onboarding_defaults.dart';
import '../../../core/result/result.dart';
import '../../../core/time/clock.dart';
import '../domain/entities/currency.dart';
import '../domain/entities/onboarding_draft.dart';
import '../domain/entities/onboarding_result.dart';
import '../domain/entities/onboarding_summary.dart';
import '../domain/repositories/onboarding_repository.dart';
import '../domain/services/pay_cycle_calculator.dart';

@injectable
class LocalOnboardingRepository implements OnboardingRepository {
  LocalOnboardingRepository(Clock clock) : _clock = clock;

  final Clock _clock;

  @override
  Future<Result<List<Currency>>> getCurrencies() async => const Success([
    Currency(
      code: OnboardingDefaults.currencyCode,
      symbol: OnboardingDefaults.currencySymbol,
      exponent: OnboardingDefaults.currencyExponent,
      paydayPresets: OnboardingDefaults.paydayPresets,
      defaultWeekStart: OnboardingDefaults.weekStart,
    ),
  ]);

  @override
  Future<Result<OnboardingResult>> preview(OnboardingDraft draft) async =>
      Success(_result(draft, obligationIds: const {}));

  @override
  Future<Result<OnboardingResult>> complete(
    OnboardingDraft draft, {
    required String idempotencyKey,
  }) async => Success(
    _result(
      draft,
      obligationIds: {
        for (final obligation in draft.obligations)
          obligation.clientId:
              '${OnboardingDefaults.localObligationIdPrefix}${obligation.clientId}',
      },
    ),
  );

  OnboardingResult _result(
    OnboardingDraft draft, {
    required Map<String, String> obligationIds,
  }) {
    final today = _clock.now();
    final cycle = PayCycleCalculator.cycleOf(today, draft.payday);
    final daysLeft = PayCycleCalculator.daysLeft(today, cycle);
    final reserved = draft.reservedMinor;
    final spendable =
        draft.salaryMinor - reserved - draft.savingsContributionMinor;
    final remaining = spendable - draft.spentSoFarMinor;
    final margin = remaining - draft.safetyBalanceMinor;
    return OnboardingResult(
      summary: OnboardingSummary(
        remainingMinor: remaining,
        spendableMinor: spendable,
        spentMinor: draft.spentSoFarMinor,
        reservedMinor: reserved,
        savingsMinor: draft.savingsContributionMinor,
        dailyBudgetMinor: max(0, margin) ~/ daysLeft,
        status: margin <= 0 ? SummaryStatus.critical : SummaryStatus.ok,
      ),
      obligationIds: obligationIds,
      warnings: const [],
    );
  }
}

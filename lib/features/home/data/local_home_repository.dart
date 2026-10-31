import 'dart:math';

import 'package:injectable/injectable.dart';

import '../../../core/constants/home_defaults.dart';
import '../../../core/money/money_currency.dart';
import '../../../core/result/result.dart';
import '../../../core/time/clock.dart';
import '../domain/entities/cycle_period.dart';
import '../domain/entities/cycle_status.dart';
import '../domain/entities/cycle_summary.dart';
import '../domain/entities/home_profile.dart';
import '../domain/entities/pace_note.dart';
import '../domain/entities/recent_expense.dart';
import '../domain/entities/savings_overview.dart';
import '../domain/entities/upcoming_obligation.dart';
import '../domain/repositories/home_repository.dart';
import 'local_home_fixtures.dart';

@injectable
class LocalHomeRepository implements HomeRepository {
  LocalHomeRepository(Clock clock) : _clock = clock;

  final Clock _clock;

  DateTime get _today {
    final now = _clock.now();
    return DateTime.utc(now.year, now.month, now.day);
  }

  Future<Result<T>> _respond<T>(T Function() build) async {
    await Future<void>.delayed(HomeDefaults.localLatency);
    return Success(build());
  }

  CyclePeriod _period() {
    final today = _today;
    final startsThisMonth = today.day >= LocalHomeFixtures.payday;
    final start = DateTime.utc(
      today.year,
      startsThisMonth ? today.month : today.month - 1,
      LocalHomeFixtures.payday,
    );
    final next = DateTime.utc(start.year, start.month + 1, LocalHomeFixtures.payday);
    return CyclePeriod(
      start: start,
      end: DateTime.utc(next.year, next.month, next.day - 1),
      days: next.difference(start).inDays,
    );
  }

  @override
  Future<Result<CycleSummary>> getCycleSummary() => _respond(() {
    final period = _period();
    final remaining =
        LocalHomeFixtures.spendableMinor - LocalHomeFixtures.spentMinor;
    final margin = remaining - LocalHomeFixtures.safetyBalanceMinor;
    return CycleSummary(
      remainingMinor: remaining,
      spendableMinor: LocalHomeFixtures.spendableMinor,
      spentMinor: LocalHomeFixtures.spentMinor,
      reservedMinor: LocalHomeFixtures.reservedMinor,
      savingsMinor: LocalHomeFixtures.savingsMinor,
      dailyBudgetMinor: max(0, margin) ~/ period.daysLeft(_today),
      status: CycleStatus.ok,
      hasPendingReview: false,
      paceNote: const PaceNote(
        tone: CycleStatus.ok,
        text: LocalHomeFixtures.paceNote,
      ),
      period: period,
      safetyBalanceMinor: LocalHomeFixtures.safetyBalanceMinor,
      marginMinor: margin,
    );
  });

  @override
  Future<Result<HomeProfile>> getProfile() => _respond(
    () => const HomeProfile(
      unreadNotifications: LocalHomeFixtures.unreadNotifications,
      hasPendingReview: false,
    ),
  );

  @override
  Future<Result<SavingsOverview>> getSavings() => _respond(
    () => const SavingsOverview(
      balanceMinor: LocalHomeFixtures.savingsBalanceMinor,
      monthlyContributionMinor: LocalHomeFixtures.savingsMonthlyMinor,
      nearestGoal: SavingsGoal(
        name: LocalHomeFixtures.goalName,
        balanceMinor: LocalHomeFixtures.goalBalanceMinor,
        targetMinor: LocalHomeFixtures.goalTargetMinor,
      ),
    ),
  );

  @override
  Future<Result<List<UpcomingObligation>>> getUpcomingObligations({
    required int limit,
  }) => _respond(
    () => [
      for (final (id, name, amount, inDays) in LocalHomeFixtures.obligations)
        UpcomingObligation(
          id: id,
          name: name,
          kind: UpcomingObligationKind.fixed,
          amountMinor: amount,
          isEstimate: false,
          dueOn: _today.add(Duration(days: inDays)),
          daysUntilDue: inDays,
          status: ObligationDisplayStatus.reserved,
        ),
    ].take(limit).toList(),
  );

  @override
  Future<Result<RecentExpenses>> getRecentExpenses({required int limit}) =>
      _respond(
        () => RecentExpenses(
          currency: MoneyCurrency.fallback,
          items: [
            for (final (id, merchant, key, label, amount, daysAgo)
                in LocalHomeFixtures.expenses)
              RecentExpense(
                id: id,
                amountMinor: amount,
                merchant: merchant,
                categoryKey: key,
                categoryLabel: label,
                spentOn: _today.subtract(Duration(days: daysAgo)),
                necessity: ExpenseNecessity.normal,
              ),
          ].take(limit).toList(),
        ),
      );
}

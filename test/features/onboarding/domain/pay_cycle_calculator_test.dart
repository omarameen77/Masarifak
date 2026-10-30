import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/features/onboarding/domain/services/pay_cycle_calculator.dart';

void main() {
  test('payday on the 1st gives a calendar month cycle', () {
    final cycle = PayCycleCalculator.cycleOf(DateTime(2026, 10, 30), 1);

    expect(cycle.start, DateTime.utc(2026, 10, 1));
    expect(cycle.end, DateTime.utc(2026, 10, 31));
    expect(cycle.next, DateTime.utc(2026, 11, 1));
    expect(cycle.days, 31);
  });

  test('before payday the cycle starts in the previous month', () {
    final cycle = PayCycleCalculator.cycleOf(DateTime(2026, 10, 20), 25);

    expect(cycle.start, DateTime.utc(2026, 9, 25));
    expect(cycle.end, DateTime.utc(2026, 10, 24));
    expect(cycle.next, DateTime.utc(2026, 10, 25));
  });

  test('on payday the cycle starts today', () {
    final cycle = PayCycleCalculator.cycleOf(DateTime(2026, 10, 25), 25);

    expect(cycle.start, DateTime.utc(2026, 10, 25));
    expect(cycle.next, DateTime.utc(2026, 11, 25));
  });

  test('payday past the end of a short month falls on its last day', () {
    final cycle = PayCycleCalculator.cycleOf(DateTime(2027, 2, 28), 31);

    expect(cycle.start, DateTime.utc(2027, 2, 28));
    expect(cycle.next, DateTime.utc(2027, 3, 31));
    expect(cycle.end, DateTime.utc(2027, 3, 30));
  });

  test('cycle crossing the year boundary', () {
    final cycle = PayCycleCalculator.cycleOf(DateTime(2026, 12, 20), 25);

    expect(cycle.start, DateTime.utc(2026, 11, 25));
    expect(cycle.next, DateTime.utc(2026, 12, 25));

    final january = PayCycleCalculator.cycleOf(DateTime(2027, 1, 5), 25);
    expect(january.start, DateTime.utc(2026, 12, 25));
    expect(january.next, DateTime.utc(2027, 1, 25));
  });

  test('upcoming cycles start with the current one and step monthly', () {
    final cycles = PayCycleCalculator.upcomingCycles(DateTime(2026, 10, 30), 25, 3);

    expect(cycles.map((cycle) => cycle.start), [
      DateTime.utc(2026, 10, 25),
      DateTime.utc(2026, 11, 25),
      DateTime.utc(2026, 12, 25),
    ]);
  });

  test('due date falls in the next month when before the cycle start day', () {
    final cycle = PayCycleCalculator.cycleStartingIn(2026, 11, 25);

    expect(PayCycleCalculator.dueDateIn(cycle, 28), DateTime.utc(2026, 11, 28));
    expect(PayCycleCalculator.dueDateIn(cycle, 5), DateTime.utc(2026, 12, 5));
  });

  test('due day past the month end is clamped to its last day', () {
    final cycle = PayCycleCalculator.cycleStartingIn(2027, 1, 1);

    expect(PayCycleCalculator.dueDateIn(cycle, 31), DateTime.utc(2027, 1, 31));
    final february = PayCycleCalculator.cycleStartingIn(2027, 2, 1);
    expect(PayCycleCalculator.dueDateIn(february, 31), DateTime.utc(2027, 2, 28));
  });

  test('days left counts today and ends on the cycle end', () {
    final cycle = PayCycleCalculator.cycleOf(DateTime(2026, 10, 30), 25);

    expect(PayCycleCalculator.daysLeft(DateTime(2026, 10, 30), cycle), 26);
    expect(PayCycleCalculator.daysSinceStart(DateTime(2026, 10, 30), cycle), 5);
  });
}

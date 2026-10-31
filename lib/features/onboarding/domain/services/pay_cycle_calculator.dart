import 'dart:math';

import '../entities/pay_cycle.dart';

abstract final class PayCycleCalculator {
  static PayCycle cycleOf(DateTime date, int payday) {
    final day = _dateOnly(date);
    final paydayThisMonth = _paydayIn(day.year, day.month, payday);
    final start = day.isBefore(paydayThisMonth)
        ? _paydayIn(day.year, day.month - 1, payday)
        : paydayThisMonth;
    final next = _paydayIn(start.year, start.month + 1, payday);
    return PayCycle(
      start: start,
      end: DateTime.utc(next.year, next.month, next.day - 1),
      next: next,
      days: next.difference(start).inDays,
    );
  }

  static PayCycle cycleStartingIn(int year, int month, int payday) {
    final start = _paydayIn(year, month, payday);
    final next = _paydayIn(start.year, start.month + 1, payday);
    return PayCycle(
      start: start,
      end: DateTime.utc(next.year, next.month, next.day - 1),
      next: next,
      days: next.difference(start).inDays,
    );
  }

  static List<PayCycle> upcomingCycles(DateTime date, int payday, int count) {
    final current = cycleOf(date, payday);
    return [
      for (var offset = 0; offset < count; offset++)
        cycleStartingIn(current.start.year, current.start.month + offset, payday),
    ];
  }

  static DateTime dueDateIn(PayCycle cycle, int dueDay) {
    final month = dueDay < cycle.start.day
        ? cycle.start.month + 1
        : cycle.start.month;
    return _paydayIn(cycle.start.year, month, dueDay);
  }

  static int daysLeft(DateTime date, PayCycle cycle) =>
      cycle.end.difference(_dateOnly(date)).inDays + 1;

  static int daysSinceStart(DateTime date, PayCycle cycle) =>
      _dateOnly(date).difference(cycle.start).inDays;

  static DateTime _dateOnly(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day);

  static DateTime _paydayIn(int year, int month, int payday) {
    final lastDay = DateTime.utc(year, month + 1, 0).day;
    return DateTime.utc(year, month, min(payday, lastDay));
  }
}

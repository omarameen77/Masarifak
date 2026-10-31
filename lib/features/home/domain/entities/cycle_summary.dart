import 'package:equatable/equatable.dart';

import 'cycle_period.dart';
import 'cycle_status.dart';
import 'pace_note.dart';

class CycleSummary extends Equatable {
  const CycleSummary({
    required this.remainingMinor,
    required this.spendableMinor,
    required this.spentMinor,
    required this.reservedMinor,
    required this.savingsMinor,
    required this.dailyBudgetMinor,
    required this.status,
    required this.hasPendingReview,
    this.paceNote,
    this.floorDate,
    this.period,
    this.safetyBalanceMinor,
    this.marginMinor,
  });

  final int remainingMinor;
  final int spendableMinor;
  final int spentMinor;
  final int reservedMinor;
  final int savingsMinor;
  final int dailyBudgetMinor;
  final CycleStatus status;
  final bool hasPendingReview;
  final PaceNote? paceNote;
  final DateTime? floorDate;
  final CyclePeriod? period;
  final int? safetyBalanceMinor;
  final int? marginMinor;

  @override
  List<Object?> get props => [
    remainingMinor,
    spendableMinor,
    spentMinor,
    reservedMinor,
    savingsMinor,
    dailyBudgetMinor,
    status,
    hasPendingReview,
    paceNote,
    floorDate,
    period,
    safetyBalanceMinor,
    marginMinor,
  ];
}

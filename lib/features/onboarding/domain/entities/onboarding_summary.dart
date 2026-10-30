import 'package:equatable/equatable.dart';

enum SummaryStatus { ok, warn, critical }

class OnboardingSummary extends Equatable {
  const OnboardingSummary({
    required this.remainingMinor,
    required this.spendableMinor,
    required this.spentMinor,
    required this.reservedMinor,
    required this.savingsMinor,
    required this.dailyBudgetMinor,
    required this.status,
  });

  final int remainingMinor;
  final int spendableMinor;
  final int spentMinor;
  final int reservedMinor;
  final int savingsMinor;
  final int dailyBudgetMinor;
  final SummaryStatus status;

  @override
  List<Object?> get props => [
    remainingMinor,
    spendableMinor,
    spentMinor,
    reservedMinor,
    savingsMinor,
    dailyBudgetMinor,
    status,
  ];
}

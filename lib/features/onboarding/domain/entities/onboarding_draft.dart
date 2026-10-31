import 'package:equatable/equatable.dart';

import 'obligation_draft.dart';

class OnboardingDraft extends Equatable {
  const OnboardingDraft({
    required this.currencyCode,
    required this.timezone,
    required this.weekStart,
    required this.salaryMinor,
    required this.payday,
    required this.safetyBalanceMinor,
    required this.savingsContributionMinor,
    required this.savingsOpeningBalanceMinor,
    required this.spentSoFarMinor,
    required this.obligations,
  });

  final String currencyCode;
  final String timezone;
  final int weekStart;
  final int salaryMinor;
  final int payday;
  final int safetyBalanceMinor;
  final int savingsContributionMinor;
  final int savingsOpeningBalanceMinor;
  final int spentSoFarMinor;
  final List<ObligationDraft> obligations;

  int get reservedMinor =>
      obligations.fold(0, (sum, obligation) => sum + obligation.monthlyShareMinor);

  @override
  List<Object?> get props => [
    currencyCode,
    timezone,
    weekStart,
    salaryMinor,
    payday,
    safetyBalanceMinor,
    savingsContributionMinor,
    savingsOpeningBalanceMinor,
    spentSoFarMinor,
    obligations,
  ];
}

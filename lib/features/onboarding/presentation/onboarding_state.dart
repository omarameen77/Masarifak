import 'package:equatable/equatable.dart';

import '../../../core/constants/onboarding_defaults.dart';
import '../../../core/error/failure.dart';
import '../domain/entities/currency.dart';
import '../domain/entities/obligation_draft.dart';
import '../domain/entities/onboarding_draft.dart';
import '../domain/entities/onboarding_result.dart';

final class OnboardingState extends Equatable {
  const OnboardingState({
    this.currency = fallbackCurrency,
    this.salaryMinor,
    this.payday,
    this.obligations = const [],
    this.safetyBalanceMinor,
    this.savingsContributionMinor = 0,
    this.spentSoFarMinor = 0,
    this.preview,
    this.isPreviewing = false,
    this.isCompleting = false,
    this.isCompleted = false,
    this.failure,
  });

  static const Currency fallbackCurrency = Currency(
    code: OnboardingDefaults.currencyCode,
    symbol: OnboardingDefaults.currencySymbol,
    exponent: OnboardingDefaults.currencyExponent,
    paydayPresets: OnboardingDefaults.paydayPresets,
    defaultWeekStart: OnboardingDefaults.weekStart,
  );

  final Currency currency;
  final int? salaryMinor;
  final int? payday;
  final List<ObligationDraft> obligations;
  final int? safetyBalanceMinor;
  final int savingsContributionMinor;
  final int spentSoFarMinor;
  final OnboardingResult? preview;
  final bool isPreviewing;
  final bool isCompleting;
  final bool isCompleted;
  final Failure? failure;

  int get reservedMinor => obligations.fold(
    0,
    (sum, obligation) => sum + obligation.monthlyShareMinor,
  );

  OnboardingDraft? get draft {
    final salary = salaryMinor;
    final day = payday;
    final safety = safetyBalanceMinor;
    if (salary == null || day == null || safety == null) return null;
    return OnboardingDraft(
      currencyCode: currency.code,
      timezone: OnboardingDefaults.timezone,
      weekStart: currency.defaultWeekStart,
      salaryMinor: salary,
      payday: day,
      safetyBalanceMinor: safety,
      savingsContributionMinor: savingsContributionMinor,
      savingsOpeningBalanceMinor: OnboardingDefaults.savingsOpeningBalanceMinor,
      spentSoFarMinor: spentSoFarMinor,
      obligations: obligations,
    );
  }

  OnboardingState copyWith({
    Currency? currency,
    int? salaryMinor,
    int? payday,
    List<ObligationDraft>? obligations,
    int? safetyBalanceMinor,
    int? savingsContributionMinor,
    int? spentSoFarMinor,
    OnboardingResult? preview,
    bool? isPreviewing,
    bool? isCompleting,
    bool? isCompleted,
    Failure? failure,
    bool clearPreview = false,
    bool clearFailure = false,
  }) {
    return OnboardingState(
      currency: currency ?? this.currency,
      salaryMinor: salaryMinor ?? this.salaryMinor,
      payday: payday ?? this.payday,
      obligations: obligations ?? this.obligations,
      safetyBalanceMinor: safetyBalanceMinor ?? this.safetyBalanceMinor,
      savingsContributionMinor:
          savingsContributionMinor ?? this.savingsContributionMinor,
      spentSoFarMinor: spentSoFarMinor ?? this.spentSoFarMinor,
      preview: clearPreview ? null : preview ?? this.preview,
      isPreviewing: isPreviewing ?? this.isPreviewing,
      isCompleting: isCompleting ?? this.isCompleting,
      isCompleted: isCompleted ?? this.isCompleted,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    currency,
    salaryMinor,
    payday,
    obligations,
    safetyBalanceMinor,
    savingsContributionMinor,
    spentSoFarMinor,
    preview,
    isPreviewing,
    isCompleting,
    isCompleted,
    failure,
  ];
}

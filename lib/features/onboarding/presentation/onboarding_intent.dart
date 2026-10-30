import '../domain/entities/obligation_draft.dart';

sealed class OnboardingIntent {
  const OnboardingIntent();
}

final class OnboardingStarted extends OnboardingIntent {
  const OnboardingStarted();
}

final class IncomeSubmitted extends OnboardingIntent {
  const IncomeSubmitted({required this.salaryMinor, required this.payday});

  final int salaryMinor;
  final int payday;
}

final class ObligationAdded extends OnboardingIntent {
  const ObligationAdded(this.obligation);

  final ObligationDraft obligation;
}

final class ObligationUpdated extends OnboardingIntent {
  const ObligationUpdated(this.obligation);

  final ObligationDraft obligation;
}

final class ObligationRemoved extends OnboardingIntent {
  const ObligationRemoved(this.clientId);

  final String clientId;
}

final class SafetySubmitted extends OnboardingIntent {
  const SafetySubmitted({
    required this.safetyBalanceMinor,
    required this.savingsContributionMinor,
    required this.spentSoFarMinor,
  });

  final int safetyBalanceMinor;
  final int savingsContributionMinor;
  final int spentSoFarMinor;
}

final class PreviewRequested extends OnboardingIntent {
  const PreviewRequested();
}

final class CompletionRequested extends OnboardingIntent {
  const CompletionRequested();
}

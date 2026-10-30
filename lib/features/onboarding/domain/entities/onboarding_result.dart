import 'package:equatable/equatable.dart';

import 'onboarding_summary.dart';

class OnboardingResult extends Equatable {
  const OnboardingResult({
    required this.summary,
    required this.obligationIds,
    required this.warnings,
  });

  final OnboardingSummary summary;
  final Map<String, String> obligationIds;
  final List<String> warnings;

  @override
  List<Object?> get props => [summary, obligationIds, warnings];
}

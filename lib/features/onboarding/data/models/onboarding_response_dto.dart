import 'package:json_annotation/json_annotation.dart';

import '../../../../core/constants/api_onboarding_values.dart';
import '../../domain/entities/onboarding_result.dart';
import '../../domain/entities/onboarding_summary.dart';

part 'onboarding_response_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class OnboardingResponseDto {
  const OnboardingResponseDto({
    required this.summary,
    this.obligationIds = const {},
    this.warnings = const [],
  });

  factory OnboardingResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingResponseDtoFromJson(json);

  final OnboardingSummaryDto summary;
  final Map<String, String> obligationIds;
  final List<String> warnings;

  OnboardingResult toDomain() => OnboardingResult(
    summary: summary.toDomain(),
    obligationIds: obligationIds,
    warnings: warnings,
  );
}

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class OnboardingSummaryDto {
  const OnboardingSummaryDto({
    required this.remainingMinor,
    required this.spendableMinor,
    required this.spentMinor,
    required this.reservedMinor,
    required this.savingsMinor,
    required this.dailyBudgetMinor,
    required this.status,
  });

  factory OnboardingSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingSummaryDtoFromJson(json);

  final int remainingMinor;
  final int spendableMinor;
  final int spentMinor;
  final int reservedMinor;
  final int savingsMinor;
  final int dailyBudgetMinor;
  final String status;

  OnboardingSummary toDomain() => OnboardingSummary(
    remainingMinor: remainingMinor,
    spendableMinor: spendableMinor,
    spentMinor: spentMinor,
    reservedMinor: reservedMinor,
    savingsMinor: savingsMinor,
    dailyBudgetMinor: dailyBudgetMinor,
    status: switch (status) {
      ApiOnboardingValues.statusCritical => SummaryStatus.critical,
      ApiOnboardingValues.statusWarn => SummaryStatus.warn,
      _ => SummaryStatus.ok,
    },
  );
}

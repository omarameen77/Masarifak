// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnboardingResponseDto _$OnboardingResponseDtoFromJson(
  Map<String, dynamic> json,
) => OnboardingResponseDto(
  summary: OnboardingSummaryDto.fromJson(
    json['summary'] as Map<String, dynamic>,
  ),
  obligationIds:
      (json['obligation_ids'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
  warnings:
      (json['warnings'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

OnboardingSummaryDto _$OnboardingSummaryDtoFromJson(
  Map<String, dynamic> json,
) => OnboardingSummaryDto(
  remainingMinor: (json['remaining_minor'] as num).toInt(),
  spendableMinor: (json['spendable_minor'] as num).toInt(),
  spentMinor: (json['spent_minor'] as num).toInt(),
  reservedMinor: (json['reserved_minor'] as num).toInt(),
  savingsMinor: (json['savings_minor'] as num).toInt(),
  dailyBudgetMinor: (json['daily_budget_minor'] as num).toInt(),
  status: json['status'] as String,
);

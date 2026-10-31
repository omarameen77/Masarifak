// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cycle_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CycleSummaryResponseDto _$CycleSummaryResponseDtoFromJson(
  Map<String, dynamic> json,
) => CycleSummaryResponseDto(
  summary: CycleSummaryDto.fromJson(json['summary'] as Map<String, dynamic>),
);

CycleSummaryDto _$CycleSummaryDtoFromJson(Map<String, dynamic> json) =>
    CycleSummaryDto(
      remainingMinor: (json['remaining_minor'] as num).toInt(),
      spendableMinor: (json['spendable_minor'] as num).toInt(),
      spentMinor: (json['spent_minor'] as num).toInt(),
      reservedMinor: (json['reserved_minor'] as num).toInt(),
      savingsMinor: (json['savings_minor'] as num).toInt(),
      dailyBudgetMinor: (json['daily_budget_minor'] as num).toInt(),
      status: json['status'] as String,
      paceNote: json['pace_note'] == null
          ? null
          : PaceNoteDto.fromJson(json['pace_note'] as Map<String, dynamic>),
      floorDate: json['floor_date'] as String?,
      pendingReviewCycle: json['pending_review_cycle'],
      cycle: json['cycle'] == null
          ? null
          : CyclePeriodDto.fromJson(json['cycle'] as Map<String, dynamic>),
      safetyBalanceMinor: (json['safety_balance_minor'] as num?)?.toInt(),
      marginMinor: (json['margin_minor'] as num?)?.toInt(),
    );

PaceNoteDto _$PaceNoteDtoFromJson(Map<String, dynamic> json) =>
    PaceNoteDto(kind: json['kind'] as String, text: json['text'] as String);

CyclePeriodDto _$CyclePeriodDtoFromJson(Map<String, dynamic> json) =>
    CyclePeriodDto(
      start: json['start'] as String,
      end: json['end'] as String,
      days: (json['days'] as num).toInt(),
    );

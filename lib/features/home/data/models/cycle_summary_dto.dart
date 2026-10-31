import 'package:json_annotation/json_annotation.dart';

import '../../../../core/constants/api_home_values.dart';
import '../../../../core/network/api_date.dart';
import '../../domain/entities/cycle_period.dart';
import '../../domain/entities/cycle_status.dart';
import '../../domain/entities/cycle_summary.dart';
import '../../domain/entities/pace_note.dart';

part 'cycle_summary_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class CycleSummaryResponseDto {
  const CycleSummaryResponseDto({required this.summary});

  factory CycleSummaryResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CycleSummaryResponseDtoFromJson(json);

  final CycleSummaryDto summary;
}

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class CycleSummaryDto {
  const CycleSummaryDto({
    required this.remainingMinor,
    required this.spendableMinor,
    required this.spentMinor,
    required this.reservedMinor,
    required this.savingsMinor,
    required this.dailyBudgetMinor,
    required this.status,
    this.paceNote,
    this.floorDate,
    this.pendingReviewCycle,
    this.cycle,
    this.safetyBalanceMinor,
    this.marginMinor,
  });

  factory CycleSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$CycleSummaryDtoFromJson(json);

  final int remainingMinor;
  final int spendableMinor;
  final int spentMinor;
  final int reservedMinor;
  final int savingsMinor;
  final int dailyBudgetMinor;
  final String status;
  final PaceNoteDto? paceNote;
  final String? floorDate;
  final Object? pendingReviewCycle;
  final CyclePeriodDto? cycle;
  final int? safetyBalanceMinor;
  final int? marginMinor;

  CycleSummary toDomain() => CycleSummary(
    remainingMinor: remainingMinor,
    spendableMinor: spendableMinor,
    spentMinor: spentMinor,
    reservedMinor: reservedMinor,
    savingsMinor: savingsMinor,
    dailyBudgetMinor: dailyBudgetMinor,
    status: cycleStatusFrom(status),
    hasPendingReview: pendingReviewCycle != null,
    paceNote: paceNote?.toDomain(),
    floorDate: ApiDate.tryParse(floorDate),
    period: cycle?.toDomain(),
    safetyBalanceMinor: safetyBalanceMinor,
    marginMinor: marginMinor,
  );
}

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class PaceNoteDto {
  const PaceNoteDto({required this.kind, required this.text});

  factory PaceNoteDto.fromJson(Map<String, dynamic> json) =>
      _$PaceNoteDtoFromJson(json);

  final String kind;
  final String text;

  PaceNote toDomain() => PaceNote(tone: cycleStatusFrom(kind), text: text);
}

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class CyclePeriodDto {
  const CyclePeriodDto({
    required this.start,
    required this.end,
    required this.days,
  });

  factory CyclePeriodDto.fromJson(Map<String, dynamic> json) =>
      _$CyclePeriodDtoFromJson(json);

  final String start;
  final String end;
  final int days;

  CyclePeriod toDomain() => CyclePeriod(
    start: ApiDate.parse(start),
    end: ApiDate.parse(end),
    days: days,
  );
}

CycleStatus cycleStatusFrom(String value) => switch (value) {
  ApiHomeValues.paceCritical => CycleStatus.critical,
  ApiHomeValues.paceWarn => CycleStatus.warn,
  _ => CycleStatus.ok,
};

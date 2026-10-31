// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pockets_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PocketsDto _$PocketsDtoFromJson(Map<String, dynamic> json) => PocketsDto(
  totals: PocketTotalsDto.fromJson(json['totals'] as Map<String, dynamic>),
  goals:
      (json['goals'] as List<dynamic>?)
          ?.map((e) => PocketGoalDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

PocketTotalsDto _$PocketTotalsDtoFromJson(Map<String, dynamic> json) =>
    PocketTotalsDto(
      balanceMinor: (json['balance_minor'] as num).toInt(),
      monthlyContributionMinor: (json['monthly_contribution_minor'] as num)
          .toInt(),
    );

PocketGoalDto _$PocketGoalDtoFromJson(Map<String, dynamic> json) =>
    PocketGoalDto(
      name: json['name'] as String,
      balanceMinor: (json['balance_minor'] as num).toInt(),
      targetMinor: (json['target_minor'] as num).toInt(),
      achievedAt: json['achieved_at'] as String?,
    );

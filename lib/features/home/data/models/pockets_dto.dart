import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/savings_overview.dart';

part 'pockets_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class PocketsDto {
  const PocketsDto({required this.totals, this.goals = const []});

  factory PocketsDto.fromJson(Map<String, dynamic> json) =>
      _$PocketsDtoFromJson(json);

  final PocketTotalsDto totals;
  final List<PocketGoalDto> goals;

  SavingsOverview toDomain() {
    final open = goals.where((goal) => goal.achievedAt == null).toList()
      ..sort((a, b) => b.progress.compareTo(a.progress));
    return SavingsOverview(
      balanceMinor: totals.balanceMinor,
      monthlyContributionMinor: totals.monthlyContributionMinor,
      nearestGoal: open.isEmpty ? null : open.first.toDomain(),
    );
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class PocketTotalsDto {
  const PocketTotalsDto({
    required this.balanceMinor,
    required this.monthlyContributionMinor,
  });

  factory PocketTotalsDto.fromJson(Map<String, dynamic> json) =>
      _$PocketTotalsDtoFromJson(json);

  final int balanceMinor;
  final int monthlyContributionMinor;
}

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class PocketGoalDto {
  const PocketGoalDto({
    required this.name,
    required this.balanceMinor,
    required this.targetMinor,
    this.achievedAt,
  });

  factory PocketGoalDto.fromJson(Map<String, dynamic> json) =>
      _$PocketGoalDtoFromJson(json);

  final String name;
  final int balanceMinor;
  final int targetMinor;
  final String? achievedAt;

  double get progress => toDomain().progress;

  SavingsGoal toDomain() => SavingsGoal(
    name: name,
    balanceMinor: balanceMinor,
    targetMinor: targetMinor,
  );
}

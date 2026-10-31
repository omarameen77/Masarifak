import 'package:equatable/equatable.dart';

class SavingsGoal extends Equatable {
  const SavingsGoal({
    required this.name,
    required this.balanceMinor,
    required this.targetMinor,
  });

  final String name;
  final int balanceMinor;
  final int targetMinor;

  double get progress =>
      targetMinor <= 0 ? 0 : (balanceMinor / targetMinor).clamp(0, 1).toDouble();

  @override
  List<Object?> get props => [name, balanceMinor, targetMinor];
}

class SavingsOverview extends Equatable {
  const SavingsOverview({
    required this.balanceMinor,
    required this.monthlyContributionMinor,
    this.nearestGoal,
  });

  final int balanceMinor;
  final int monthlyContributionMinor;
  final SavingsGoal? nearestGoal;

  @override
  List<Object?> get props => [balanceMinor, monthlyContributionMinor, nearestGoal];
}

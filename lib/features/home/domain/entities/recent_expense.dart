import 'package:equatable/equatable.dart';

import '../../../../core/money/money_currency.dart';

enum ExpenseNecessity { need, normal, lux }

class RecentExpense extends Equatable {
  const RecentExpense({
    required this.id,
    required this.amountMinor,
    required this.merchant,
    required this.categoryKey,
    required this.categoryLabel,
    required this.spentOn,
    this.necessity,
  });

  final String id;
  final int amountMinor;
  final String merchant;
  final String categoryKey;
  final String categoryLabel;
  final DateTime spentOn;
  final ExpenseNecessity? necessity;

  @override
  List<Object?> get props => [
    id,
    amountMinor,
    merchant,
    categoryKey,
    categoryLabel,
    spentOn,
    necessity,
  ];
}

class RecentExpenses extends Equatable {
  const RecentExpenses({required this.items, required this.currency});

  final List<RecentExpense> items;
  final MoneyCurrency currency;

  @override
  List<Object?> get props => [items, currency];
}

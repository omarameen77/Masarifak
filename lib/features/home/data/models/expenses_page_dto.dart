import 'package:json_annotation/json_annotation.dart';

import '../../../../core/constants/api_home_values.dart';
import '../../../../core/money/money_currency.dart';
import '../../../../core/network/api_date.dart';
import '../../domain/entities/recent_expense.dart';

part 'expenses_page_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class ExpensesPageDto {
  const ExpensesPageDto({this.items = const [], this.currency});

  factory ExpensesPageDto.fromJson(Map<String, dynamic> json) =>
      _$ExpensesPageDtoFromJson(json);

  final List<ExpenseDto> items;
  final CurrencyRefDto? currency;

  RecentExpenses toDomain() => RecentExpenses(
    items: items.map((item) => item.toDomain()).toList(),
    currency: currency?.toDomain() ?? MoneyCurrency.fallback,
  );
}

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class ExpenseDto {
  const ExpenseDto({
    required this.id,
    required this.amountMinor,
    required this.merchant,
    required this.category,
    required this.spentOn,
    this.necessity,
  });

  factory ExpenseDto.fromJson(Map<String, dynamic> json) =>
      _$ExpenseDtoFromJson(json);

  final String id;
  final int amountMinor;
  final NamedRefDto merchant;
  final CategoryRefDto category;
  final String spentOn;
  final String? necessity;

  RecentExpense toDomain() => RecentExpense(
    id: id,
    amountMinor: amountMinor,
    merchant: merchant.name,
    categoryKey: category.key,
    categoryLabel: category.label,
    spentOn: ApiDate.parse(spentOn),
    necessity: switch (necessity) {
      ApiHomeValues.necessityNeed => ExpenseNecessity.need,
      ApiHomeValues.necessityNormal => ExpenseNecessity.normal,
      ApiHomeValues.necessityLux => ExpenseNecessity.lux,
      _ => null,
    },
  );
}

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class NamedRefDto {
  const NamedRefDto({required this.name});

  factory NamedRefDto.fromJson(Map<String, dynamic> json) =>
      _$NamedRefDtoFromJson(json);

  final String name;
}

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class CategoryRefDto {
  const CategoryRefDto({required this.key, required this.label});

  factory CategoryRefDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryRefDtoFromJson(json);

  final String key;
  final String label;
}

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class CurrencyRefDto {
  const CurrencyRefDto({
    required this.code,
    required this.symbol,
    required this.exponent,
  });

  factory CurrencyRefDto.fromJson(Map<String, dynamic> json) =>
      _$CurrencyRefDtoFromJson(json);

  final String code;
  final String symbol;
  final int exponent;

  MoneyCurrency toDomain() =>
      MoneyCurrency(code: code, symbol: symbol, exponent: exponent);
}

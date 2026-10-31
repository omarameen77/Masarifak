// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses_page_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpensesPageDto _$ExpensesPageDtoFromJson(Map<String, dynamic> json) =>
    ExpensesPageDto(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => ExpenseDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      currency: json['currency'] == null
          ? null
          : CurrencyRefDto.fromJson(json['currency'] as Map<String, dynamic>),
    );

ExpenseDto _$ExpenseDtoFromJson(Map<String, dynamic> json) => ExpenseDto(
  id: json['id'] as String,
  amountMinor: (json['amount_minor'] as num).toInt(),
  merchant: NamedRefDto.fromJson(json['merchant'] as Map<String, dynamic>),
  category: CategoryRefDto.fromJson(json['category'] as Map<String, dynamic>),
  spentOn: json['spent_on'] as String,
  necessity: json['necessity'] as String?,
);

NamedRefDto _$NamedRefDtoFromJson(Map<String, dynamic> json) =>
    NamedRefDto(name: json['name'] as String);

CategoryRefDto _$CategoryRefDtoFromJson(Map<String, dynamic> json) =>
    CategoryRefDto(key: json['key'] as String, label: json['label'] as String);

CurrencyRefDto _$CurrencyRefDtoFromJson(Map<String, dynamic> json) =>
    CurrencyRefDto(
      code: json['code'] as String,
      symbol: json['symbol'] as String,
      exponent: (json['exponent'] as num).toInt(),
    );

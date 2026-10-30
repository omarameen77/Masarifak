// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyDto _$CurrencyDtoFromJson(Map<String, dynamic> json) => CurrencyDto(
  code: json['code'] as String,
  symbol: json['symbol'] as String,
  exponent: (json['exponent'] as num).toInt(),
  paydayPresets: (json['payday_presets'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  defaultWeekStart: (json['default_week_start'] as num).toInt(),
);

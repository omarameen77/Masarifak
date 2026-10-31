import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/currency.dart';

part 'currency_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class CurrencyDto {
  const CurrencyDto({
    required this.code,
    required this.symbol,
    required this.exponent,
    required this.paydayPresets,
    required this.defaultWeekStart,
  });

  factory CurrencyDto.fromJson(Map<String, dynamic> json) =>
      _$CurrencyDtoFromJson(json);

  final String code;
  final String symbol;
  final int exponent;
  final List<int> paydayPresets;
  final int defaultWeekStart;

  Currency toDomain() => Currency(
    code: code,
    symbol: symbol,
    exponent: exponent,
    paydayPresets: paydayPresets,
    defaultWeekStart: defaultWeekStart,
  );
}

import 'package:equatable/equatable.dart';

class Currency extends Equatable {
  const Currency({
    required this.code,
    required this.symbol,
    required this.exponent,
    required this.paydayPresets,
    required this.defaultWeekStart,
  });

  final String code;
  final String symbol;
  final int exponent;
  final List<int> paydayPresets;
  final int defaultWeekStart;

  @override
  List<Object?> get props => [
    code,
    symbol,
    exponent,
    paydayPresets,
    defaultWeekStart,
  ];
}

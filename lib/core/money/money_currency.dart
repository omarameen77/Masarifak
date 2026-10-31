import 'package:equatable/equatable.dart';

import '../constants/onboarding_defaults.dart';

class MoneyCurrency extends Equatable {
  const MoneyCurrency({
    required this.code,
    required this.symbol,
    required this.exponent,
  });

  static const MoneyCurrency fallback = MoneyCurrency(
    code: OnboardingDefaults.currencyCode,
    symbol: OnboardingDefaults.currencySymbol,
    exponent: OnboardingDefaults.currencyExponent,
  );

  final String code;
  final String symbol;
  final int exponent;

  @override
  List<Object?> get props => [code, symbol, exponent];
}

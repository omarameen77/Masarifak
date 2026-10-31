import 'dart:math';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';

import '../constants/app_locales.dart';
import '../constants/number_symbols.dart';

class AppNumberFormat {
  AppNumberFormat(Locale locale)
    : _locale = locale.languageCode == AppLocales.arabic.languageCode
          ? AppLocales.arabicNumberLocale
          : AppLocales.englishNumberLocale;

  final String _locale;

  String integer(int value) => NumberFormat.decimalPattern(_locale).format(value);

  String year(int value) => NumberFormat(NumberSymbols.plainPattern, _locale)
      .format(value);

  String amount(int minor, {required int exponent, bool rounded = false}) {
    final format = NumberFormat.decimalPattern(_locale)
      ..maximumFractionDigits = rounded ? 0 : exponent;
    final sign = minor < 0 ? NumberSymbols.minus : '';
    final major = minor.abs() / pow(NumberSymbols.base, exponent);
    return '$sign${format.format(major)}';
  }

  String money(
    int minor, {
    required int exponent,
    required String symbol,
    bool rounded = false,
  }) =>
      '${amount(minor, exponent: exponent, rounded: rounded)}'
      '${NumberSymbols.space}$symbol';

  String percent(double fraction) =>
      NumberFormat.percentPattern(_locale).format(fraction);

  static String editableMajor(int minor, {required int exponent}) {
    final unit = pow(NumberSymbols.base, exponent).toInt();
    if (minor % unit == 0) return (minor ~/ unit).toString();
    return (minor / unit).toString();
  }

  static String normalizeDigits(String input) {
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      buffer.write(_normalizeRune(rune));
    }
    return buffer.toString();
  }

  static int? parseMinor(String input, {required int exponent}) {
    final cleaned = normalizeDigits(input.trim())
        .replaceAll(NumberSymbols.groupingPattern, '')
        .replaceAll(NumberSymbols.arabicDecimal, NumberSymbols.decimal);
    if (!NumberSymbols.decimalPattern.hasMatch(cleaned)) return null;
    final value = double.tryParse(cleaned);
    if (value == null) return null;
    return (value * pow(NumberSymbols.base, exponent)).round();
  }

  static String _normalizeRune(int rune) {
    if (rune >= NumberSymbols.arabicZero && rune <= NumberSymbols.arabicNine) {
      return String.fromCharCode(
        rune - NumberSymbols.arabicZero + NumberSymbols.asciiZero,
      );
    }
    if (rune >= NumberSymbols.persianZero && rune <= NumberSymbols.persianNine) {
      return String.fromCharCode(
        rune - NumberSymbols.persianZero + NumberSymbols.asciiZero,
      );
    }
    return String.fromCharCode(rune);
  }
}

import 'package:flutter/services.dart';

import '../constants/number_symbols.dart';
import 'app_number_format.dart';

class LocalizedDigitsInputFormatter extends TextInputFormatter {
  const LocalizedDigitsInputFormatter({this.allowDecimal = false});

  final bool allowDecimal;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final normalized = AppNumberFormat.normalizeDigits(
      newValue.text,
    ).replaceAll(NumberSymbols.arabicDecimal, NumberSymbols.decimal);
    final pattern = allowDecimal
        ? NumberSymbols.amountInputPattern
        : NumberSymbols.digitsInputPattern;
    if (!pattern.hasMatch(normalized)) return oldValue;
    return newValue.copyWith(
      text: normalized,
      selection: newValue.selection,
      composing: TextRange.empty,
    );
  }
}

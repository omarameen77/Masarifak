import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/constants/app_locales.dart';
import 'package:masarifak/core/formatting/app_number_format.dart';
import 'package:masarifak/core/formatting/localized_digits_input_formatter.dart';

void main() {
  test('Arabic locale formats with Arabic-Indic digits', () {
    final formatted = AppNumberFormat(AppLocales.arabic).integer(5000);

    expect(formatted, contains('٥'));
    expect(AppNumberFormat.normalizeDigits(formatted), contains('5'));
  });

  test('English locale formats with Latin digits and grouping', () {
    expect(AppNumberFormat(AppLocales.english).integer(5000), '5,000');
  });

  test('money converts minor units and appends the symbol', () {
    final format = AppNumberFormat(AppLocales.english);

    expect(format.money(500000, exponent: 2, symbol: 'EGP'), '5,000 EGP');
    expect(format.money(150050, exponent: 2, symbol: 'EGP'), '1,500.5 EGP');
    expect(format.money(-5000, exponent: 2, symbol: 'EGP'), '−50 EGP');
  });

  test('parseMinor accepts Arabic-Indic digits and separators', () {
    expect(AppNumberFormat.parseMinor('٥٠٠٠', exponent: 2), 500000);
    expect(AppNumberFormat.parseMinor('1,500.5', exponent: 2), 150050);
    expect(AppNumberFormat.parseMinor('١٥٠٠٫٥', exponent: 2), 150050);
    expect(AppNumberFormat.parseMinor('۱۲', exponent: 2), 1200);
  });

  test('parseMinor rejects empty and non numeric input', () {
    expect(AppNumberFormat.parseMinor('', exponent: 2), isNull);
    expect(AppNumberFormat.parseMinor('abc', exponent: 2), isNull);
    expect(AppNumberFormat.parseMinor('1.2.3', exponent: 2), isNull);
  });

  group('LocalizedDigitsInputFormatter', () {
    TextEditingValue apply(
      LocalizedDigitsInputFormatter formatter,
      String oldText,
      String newText,
    ) => formatter.formatEditUpdate(
      TextEditingValue(text: oldText),
      TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      ),
    );

    test('turns Arabic-Indic digits into Latin digits', () {
      expect(
        apply(const LocalizedDigitsInputFormatter(), '', '١٢٣').text,
        '123',
      );
    });

    test('rejects letters and keeps the previous value', () {
      expect(apply(const LocalizedDigitsInputFormatter(), '12', '12a').text, '12');
    });

    test('allows one decimal separator only when enabled', () {
      const decimal = LocalizedDigitsInputFormatter(allowDecimal: true);
      expect(apply(decimal, '12', '12٫5').text, '12.5');
      expect(apply(decimal, '12.5', '12.5.').text, '12.5');
      expect(apply(const LocalizedDigitsInputFormatter(), '12', '12.').text, '12');
    });
  });
}

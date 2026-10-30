import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/constants/app_locales.dart';
import 'package:masarifak/core/formatting/app_date_format.dart';

import '../../helpers/localized_app.dart';

void main() {
  testWidgets('Arabic day counts follow Arabic plural forms', (tester) async {
    await pumpLocalized(tester, const SizedBox());
    final dates = AppDateFormat(AppLocales.arabic);

    expect(dates.days(1), 'يوم واحد');
    expect(dates.days(2), 'يومين');
    expect(dates.days(3), '٣ أيام');
    expect(dates.days(10), '١٠ أيام');
    expect(dates.days(26), '٢٦ يوم');
    expect(dates.days(31), '٣١ يوم');
  });

  testWidgets('Arabic dates use Arabic digits and month names', (tester) async {
    await pumpLocalized(tester, const SizedBox());
    final dates = AppDateFormat(AppLocales.arabic);

    expect(dates.dayMonth(DateTime(2026, 10, 1)), '١ أكتوبر');
    expect(dates.monthYear(DateTime(2026, 11, 1)), 'نوفمبر ٢٠٢٦');
    expect(
      dates.range(DateTime(2026, 10, 25), DateTime(2026, 11, 24)),
      '٢٥ أكتوبر – ٢٤ نوفمبر',
    );
  });

  testWidgets('English dates and day counts', (tester) async {
    await pumpLocalized(tester, const SizedBox(), locale: AppLocales.english);
    final dates = AppDateFormat(AppLocales.english);

    expect(dates.days(1), '1 day');
    expect(dates.days(31), '31 days');
    expect(dates.dayMonth(DateTime(2026, 10, 1)), 'October 1');
  });
}

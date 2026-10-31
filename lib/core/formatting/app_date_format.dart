import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';

import '../constants/onboarding_args.dart';
import '../constants/translation_keys.dart';
import 'app_number_format.dart';

class AppDateFormat {
  AppDateFormat(Locale locale) : _numbers = AppNumberFormat(locale);

  final AppNumberFormat _numbers;

  String monthName(DateTime date) => TranslationKeys.months[date.month - 1].tr();

  String dayMonth(DateTime date) => TranslationKeys.dateDayMonth.tr(
    namedArgs: {
      OnboardingArgs.day: _numbers.integer(date.day),
      OnboardingArgs.month: monthName(date),
    },
  );

  String monthYear(DateTime date) => TranslationKeys.dateMonthYear.tr(
    namedArgs: {
      OnboardingArgs.month: monthName(date),
      OnboardingArgs.year: _numbers.year(date.year),
    },
  );

  String range(DateTime start, DateTime end) => TranslationKeys.dateRange.tr(
    namedArgs: {
      OnboardingArgs.start: dayMonth(start),
      OnboardingArgs.end: dayMonth(end),
    },
  );

  String days(int count) =>
      TranslationKeys.daysCount.plural(count, args: [_numbers.integer(count)]);
}

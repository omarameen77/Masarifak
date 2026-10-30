import 'package:flutter/widgets.dart';

abstract final class AppLocales {
  static const Locale arabic = Locale('ar');
  static const Locale english = Locale('en');
  static const List<Locale> supported = [arabic, english];
  static const Locale fallback = arabic;
  static const String arabicNumberLocale = 'ar_EG';
  static const String englishNumberLocale = 'en';
}

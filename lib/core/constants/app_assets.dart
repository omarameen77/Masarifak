import 'package:flutter/widgets.dart';

abstract final class AppAssets {
  static const String translationsPath = 'assets/translations';
  static const String fontFamily = 'IBMPlexSansArabic';

  static String translationFile(Locale locale) =>
      '$translationsPath/${locale.languageCode}.json';
}

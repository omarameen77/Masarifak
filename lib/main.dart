import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/constants/app_assets.dart';
import 'core/constants/app_locales.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: AppLocales.supported,
      path: AppAssets.translationsPath,
      fallbackLocale: AppLocales.fallback,
      useOnlyLangCode: true,
      saveLocale: false,
      child: const MasarifakApp(),
    ),
  );
}

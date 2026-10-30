import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/constants/app_assets.dart';
import 'core/constants/app_locales.dart';
import 'core/di/injection.dart';
import 'features/auth/presentation/session/session_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await configureDependencies();
  unawaited(getIt<SessionCubit>().checkStartup());
  runApp(
    EasyLocalization(
      supportedLocales: AppLocales.supported,
      path: AppAssets.translationsPath,
      fallbackLocale: AppLocales.fallback,
      startLocale: AppLocales.arabic,
      useOnlyLangCode: true,
      saveLocale: true,
      child: const MasarifakApp(),
    ),
  );
}

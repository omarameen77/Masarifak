import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/translation_keys.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import 'router/app_router.dart';

class MasarifakApp extends StatefulWidget {
  const MasarifakApp({super.key});

  @override
  State<MasarifakApp> createState() => _MasarifakAppState();
}

class _MasarifakAppState extends State<MasarifakApp> {
  late final GoRouter _router = createAppRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (_) => TranslationKeys.appName.tr(),
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      routerConfig: _router,
      theme: AppTheme.build(AppColors.light),
      themeMode: ThemeMode.light,
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/constants/app_assets.dart';
import 'package:masarifak/core/constants/app_locales.dart';
import 'package:masarifak/core/theme/app_colors.dart';
import 'package:masarifak/core/theme/app_theme.dart';

const _maxLoadAttempts = 50;
const _loadPollInterval = Duration(milliseconds: 20);

Future<Map<String, dynamic>> readArabicTranslations() async =>
    jsonDecode(
          await File(AppAssets.translationFile(AppLocales.arabic)).readAsString(),
        )
        as Map<String, dynamic>;

Future<void> pumpLocalized(
  WidgetTester tester,
  Widget child, {
  Locale locale = AppLocales.arabic,
}) async {
  EasyLocalization.logger.enableBuildModes = [];
  final marker = find.byKey(const ValueKey('localized-ready'));
  await tester.runAsync(
    () => tester.pumpWidget(
      EasyLocalization(
        supportedLocales: AppLocales.supported,
        path: AppAssets.translationsPath,
        fallbackLocale: AppLocales.fallback,
        startLocale: locale,
        useOnlyLangCode: true,
        ignorePluralRules: false,
        saveLocale: false,
        child: Builder(
          builder: (context) => MaterialApp(
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            theme: AppTheme.build(AppColors.light),
            home: Scaffold(
              body: KeyedSubtree(
                key: const ValueKey('localized-ready'),
                child: child,
              ),
            ),
          ),
        ),
      ),
    ),
  );
  for (var i = 0; i < _maxLoadAttempts && marker.evaluate().isEmpty; i++) {
    await tester.runAsync(() => Future<void>.delayed(_loadPollInterval));
    await tester.pump();
  }
  await tester.pumpAndSettle();
  expect(marker, findsOneWidget);
}

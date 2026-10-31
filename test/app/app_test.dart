import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:masarifak/app/app.dart';
import 'package:masarifak/app/placeholder_screen.dart';
import 'package:masarifak/core/constants/app_assets.dart';
import 'package:masarifak/core/constants/app_locales.dart';
import 'package:masarifak/core/constants/app_routes.dart';
import 'package:masarifak/core/constants/translation_keys.dart';
import 'package:masarifak/core/di/injection.dart';
import 'package:masarifak/core/theme/app_colors.dart';
import 'package:masarifak/features/auth/presentation/login/login_screen.dart';

const _maxLoadAttempts = 50;
const _loadPollInterval = Duration(milliseconds: 20);

late Map<String, dynamic> arabic;
late Map<String, dynamic> english;

Future<Map<String, dynamic>> readTranslations(Locale locale) async =>
    jsonDecode(await File(AppAssets.translationFile(locale)).readAsString())
        as Map<String, dynamic>;

Widget buildApp() => EasyLocalization(
  supportedLocales: AppLocales.supported,
  path: AppAssets.translationsPath,
  fallbackLocale: AppLocales.fallback,
  startLocale: AppLocales.arabic,
  useOnlyLangCode: true,
  ignorePluralRules: false,
  saveLocale: false,
  child: const MasarifakApp(),
);

TextDirection directionOf(WidgetTester tester, Type screen) =>
    Directionality.of(tester.element(find.byType(screen)));

Future<void> loadAndPumpUntilFound(
  WidgetTester tester,
  Future<void> Function() action,
  Finder finder,
) async {
  await tester.runAsync(action);
  for (var i = 0; i < _maxLoadAttempts && finder.evaluate().isEmpty; i++) {
    await tester.runAsync(() => Future<void>.delayed(_loadPollInterval));
    await tester.pump();
  }
  await tester.pumpAndSettle();
  expect(finder, findsOneWidget);
}

void main() {
  setUpAll(() async {
    EasyLocalization.logger.enableBuildModes = [];
    arabic = await readTranslations(AppLocales.arabic);
    english = await readTranslations(AppLocales.english);
  });

  setUp(configureDependencies);

  tearDown(getIt.reset);

  testWidgets('Arabic locale renders right-to-left with real translations', (tester) async {
    await loadAndPumpUntilFound(
      tester,
      () => tester.pumpWidget(buildApp()),
      find.text(arabic[TranslationKeys.loginHeading] as String),
    );

    expect(directionOf(tester, LoginScreen), TextDirection.rtl);
  });

  testWidgets('language toggle switches to English left-to-right', (tester) async {
    await loadAndPumpUntilFound(
      tester,
      () => tester.pumpWidget(buildApp()),
      find.byType(LoginScreen),
    );

    GoRouter.of(tester.element(find.byType(LoginScreen))).go(AppRoutes.home);
    await tester.pumpAndSettle();
    expect(find.text(arabic[TranslationKeys.homeTitle] as String), findsOneWidget);

    await loadAndPumpUntilFound(
      tester,
      () => tester.tap(find.text(arabic[TranslationKeys.languageToggle] as String)),
      find.text(english[TranslationKeys.homeTitle] as String),
    );

    expect(directionOf(tester, PlaceholderScreen), TextDirection.ltr);
  });

  testWidgets('applies the light AppColors theme only', (tester) async {
    await loadAndPumpUntilFound(
      tester,
      () => tester.pumpWidget(buildApp()),
      find.byType(LoginScreen),
    );

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.light);
    expect(app.darkTheme, isNull);

    final colors = Theme.of(
      tester.element(find.byType(LoginScreen)),
    ).extension<AppColors>()!;
    expect(colors.bg, const Color(0xFFF7F6F2));
  });
}

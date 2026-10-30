import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/constants/app_assets.dart';
import 'package:masarifak/core/constants/app_locales.dart';
import 'package:masarifak/core/constants/translation_keys.dart';
import 'package:masarifak/core/theme/app_colors.dart';
import 'package:masarifak/core/theme/app_theme.dart';
import 'package:masarifak/features/auth/domain/usecases/login_usecase.dart';
import 'package:masarifak/features/auth/presentation/login/login_cubit.dart';
import 'package:masarifak/features/auth/presentation/login/login_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

const _maxLoadAttempts = 50;
const _loadPollInterval = Duration(milliseconds: 20);
const _phoneSize = Size(360, 640);

late Map<String, dynamic> arabic;

Widget buildScreen() => EasyLocalization(
  supportedLocales: AppLocales.supported,
  path: AppAssets.translationsPath,
  fallbackLocale: AppLocales.fallback,
  startLocale: AppLocales.arabic,
  useOnlyLangCode: true,
  saveLocale: false,
  child: Builder(
    builder: (context) => MaterialApp(
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      theme: AppTheme.build(AppColors.light),
      home: BlocProvider(
        create: (_) => LoginCubit(MockLoginUseCase()),
        child: const LoginScreen(),
      ),
    ),
  ),
);

Future<void> pumpLoginScreen(WidgetTester tester) async {
  final title = find.text(arabic[TranslationKeys.loginTitle] as String);
  await tester.runAsync(() => tester.pumpWidget(buildScreen()));
  for (var i = 0; i < _maxLoadAttempts && title.evaluate().isEmpty; i++) {
    await tester.runAsync(() => Future<void>.delayed(_loadPollInterval));
    await tester.pump();
  }
  await tester.pumpAndSettle();
  expect(title, findsOneWidget);
}

FilledButton submitButton(WidgetTester tester) =>
    tester.widget<FilledButton>(find.byType(FilledButton));

void main() {
  setUpAll(() async {
    EasyLocalization.logger.enableBuildModes = [];
    arabic = jsonDecode(
      await File(AppAssets.translationFile(AppLocales.arabic)).readAsString(),
    ) as Map<String, dynamic>;
  });

  testWidgets('submit button is disabled when the fields are empty', (tester) async {
    await pumpLoginScreen(tester);

    expect(submitButton(tester).onPressed, isNull);
  });

  testWidgets('submit button is enabled when both fields have text', (tester) async {
    await pumpLoginScreen(tester);

    await tester.enterText(find.byType(TextField).at(0), 'ahmed@example.com');
    await tester.pump();
    expect(submitButton(tester).onPressed, isNull);

    await tester.enterText(find.byType(TextField).at(1), 'at-least-8-chars');
    await tester.pump();
    expect(submitButton(tester).onPressed, isNotNull);
  });

  testWidgets('screen has no Telegram text', (tester) async {
    await pumpLoginScreen(tester);

    expect(find.textContaining('Telegram'), findsNothing);
    expect(find.textContaining('تيليجرام'), findsNothing);
  });

  testWidgets('screen renders without overflow at 360x640', (tester) async {
    tester.view.physicalSize = _phoneSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await pumpLoginScreen(tester);

    expect(tester.takeException(), isNull);
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}

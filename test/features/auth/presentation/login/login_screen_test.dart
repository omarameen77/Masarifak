import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/constants/app_assets.dart';
import 'package:masarifak/core/constants/app_locales.dart';
import 'package:masarifak/core/constants/translation_keys.dart';
import 'package:masarifak/core/error/failure.dart';
import 'package:masarifak/core/result/result.dart';
import 'package:masarifak/core/theme/app_colors.dart';
import 'package:masarifak/core/theme/app_theme.dart';
import 'package:masarifak/features/auth/domain/entities/login_result.dart';
import 'package:masarifak/features/auth/domain/usecases/login_usecase.dart';
import 'package:masarifak/features/auth/presentation/login/login_cubit.dart';
import 'package:masarifak/features/auth/presentation/login/login_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

const _maxLoadAttempts = 50;
const _loadPollInterval = Duration(milliseconds: 20);
const _phoneSize = Size(360, 640);

late Map<String, dynamic> arabic;

Widget buildScreen([LoginUseCase? loginUseCase]) => EasyLocalization(
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
        create: (_) => LoginCubit(loginUseCase ?? MockLoginUseCase()),
        child: const LoginScreen(),
      ),
    ),
  ),
);

Future<void> pumpLoginScreen(
  WidgetTester tester, [
  LoginUseCase? loginUseCase,
]) async {
  final title = find.text(arabic[TranslationKeys.loginHeading] as String);
  await tester.runAsync(() => tester.pumpWidget(buildScreen(loginUseCase)));
  for (var i = 0; i < _maxLoadAttempts && title.evaluate().isEmpty; i++) {
    await tester.runAsync(() => Future<void>.delayed(_loadPollInterval));
    await tester.pump();
  }
  await tester.pumpAndSettle();
  expect(title, findsOneWidget);
}

FilledButton submitButton(WidgetTester tester) =>
    tester.widget<FilledButton>(find.byType(FilledButton));

String fieldText(WidgetTester tester, int index) =>
    tester.widget<TextField>(find.byType(TextField).at(index)).controller!.text;

String arabicText(String key) => arabic[key] as String;

MockLoginUseCase mockLoginUseCaseReturning401() {
  final loginUseCase = MockLoginUseCase();
  when(
    () => loginUseCase(
      email: any(named: 'email'),
      password: any(named: 'password'),
    ),
  ).thenAnswer((_) async => const Error<LoginResult>(UnauthorizedFailure()));
  return loginUseCase;
}

Future<void> fillAndSubmit(
  WidgetTester tester,
  String email,
  String password,
) async {
  await tester.enterText(find.byType(TextField).at(0), email);
  await tester.enterText(find.byType(TextField).at(1), password);
  await tester.pump();
  await tester.tap(find.byType(FilledButton));
  await tester.pumpAndSettle();
}

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

  testWidgets('invalid email shows no error before submit', (tester) async {
    await pumpLoginScreen(tester);

    await tester.enterText(find.byType(TextField).at(0), 'ahmed@example');
    await tester.pump();
    await tester.enterText(find.byType(TextField).at(1), 'at-least-8-chars');
    await tester.pump();

    expect(
      find.text(arabicText(TranslationKeys.validationEmailInvalid)),
      findsNothing,
    );
  });

  testWidgets('submit with an invalid email shows validationEmailInvalid and does not log in', (tester) async {
    final loginUseCase = mockLoginUseCaseReturning401();
    await pumpLoginScreen(tester, loginUseCase);

    await fillAndSubmit(tester, 'ahmed@example', 'at-least-8-chars');

    expect(
      find.text(arabicText(TranslationKeys.validationEmailInvalid)),
      findsOneWidget,
    );
    verifyNever(
      () => loginUseCase(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    );
  });

  testWidgets('submit with a 6-character password shows validationPasswordTooShort and does not log in', (tester) async {
    final loginUseCase = mockLoginUseCaseReturning401();
    await pumpLoginScreen(tester, loginUseCase);

    await fillAndSubmit(tester, 'ahmed@example.com', 'abcdef');

    expect(
      find.text(arabicText(TranslationKeys.validationPasswordTooShort)),
      findsOneWidget,
    );
    verifyNever(
      () => loginUseCase(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    );
  });

  testWidgets('submit with valid fields calls the use case once', (tester) async {
    final loginUseCase = mockLoginUseCaseReturning401();
    await pumpLoginScreen(tester, loginUseCase);

    await fillAndSubmit(tester, 'ahmed@example.com', 'at-least-8-chars');

    verify(
      () => loginUseCase(
        email: 'ahmed@example.com',
        password: 'at-least-8-chars',
      ),
    ).called(1);
  });

  testWidgets('401 shows the error dialog and clears the password', (tester) async {
    await pumpLoginScreen(tester, mockLoginUseCaseReturning401());

    await fillAndSubmit(tester, 'ahmed@example.com', 'at-least-8-chars');

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(
      find.text(arabicText(TranslationKeys.errorDialogTitle)),
      findsOneWidget,
    );
    expect(
      find.text(arabicText(TranslationKeys.errorInvalidCredentials)),
      findsOneWidget,
    );
    expect(fieldText(tester, 1), isEmpty);
    expect(
      find.text(arabicText(TranslationKeys.validationRequired)),
      findsNothing,
    );

    await tester.tap(find.text(arabicText(TranslationKeys.errorDialogAction)));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Telegram button is shown and does nothing when tapped', (tester) async {
    final loginUseCase = mockLoginUseCaseReturning401();
    await pumpLoginScreen(tester, loginUseCase);

    final telegram = find.text(arabicText(TranslationKeys.loginTelegram));
    expect(telegram, findsOneWidget);

    await tester.ensureVisible(telegram);
    await tester.tap(telegram);
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
    verifyNever(
      () => loginUseCase(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    );
  });

  testWidgets('screen shows no demo account entry', (tester) async {
    await pumpLoginScreen(tester);

    expect(find.textContaining('تجريبي'), findsNothing);
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

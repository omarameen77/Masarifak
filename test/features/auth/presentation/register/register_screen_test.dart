import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/constants/api_error_codes.dart';
import 'package:masarifak/core/constants/api_locale_values.dart';
import 'package:masarifak/core/constants/app_assets.dart';
import 'package:masarifak/core/constants/app_locales.dart';
import 'package:masarifak/core/constants/translation_keys.dart';
import 'package:masarifak/core/error/failure.dart';
import 'package:masarifak/core/result/result.dart';
import 'package:masarifak/core/theme/app_colors.dart';
import 'package:masarifak/core/theme/app_theme.dart';
import 'package:masarifak/features/auth/domain/entities/login_result.dart';
import 'package:masarifak/features/auth/domain/usecases/register_usecase.dart';
import 'package:masarifak/features/auth/presentation/register/register_cubit.dart';
import 'package:masarifak/features/auth/presentation/register/register_screen.dart';
import 'package:masarifak/features/auth/presentation/session/session_cubit.dart';
import 'package:masarifak/features/auth/presentation/session/session_state.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockSessionCubit extends MockCubit<SessionState> implements SessionCubit {}

const _maxLoadAttempts = 50;
const _loadPollInterval = Duration(milliseconds: 20);
const _name = 'Ahmed Test';
const _email = 'ahmed@example.com';
const _password = 'at-least-8-chars';

late Map<String, dynamic> arabic;

String arabicText(String key) => arabic[key] as String;

Widget buildScreen(RegisterUseCase registerUseCase) => EasyLocalization(
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
      home: MultiBlocProvider(
        providers: [
          BlocProvider<SessionCubit>(create: (_) => MockSessionCubit()),
          BlocProvider(create: (_) => RegisterCubit(registerUseCase)),
        ],
        child: const RegisterScreen(),
      ),
    ),
  ),
);

Future<void> pumpRegisterScreen(
  WidgetTester tester,
  RegisterUseCase registerUseCase,
) async {
  final title = find.text(arabicText(TranslationKeys.registerSubheading));
  await tester.runAsync(
    () => tester.pumpWidget(buildScreen(registerUseCase)),
  );
  for (var i = 0; i < _maxLoadAttempts && title.evaluate().isEmpty; i++) {
    await tester.runAsync(() => Future<void>.delayed(_loadPollInterval));
    await tester.pump();
  }
  await tester.pumpAndSettle();
  expect(title, findsOneWidget);
}

Future<void> fillAndSubmit(
  WidgetTester tester, {
  required String name,
  required String email,
  required String password,
}) async {
  await tester.enterText(find.byType(TextField).at(0), name);
  await tester.enterText(find.byType(TextField).at(1), email);
  await tester.enterText(find.byType(TextField).at(2), password);
  await tester.pump();
  await tester.tap(find.byType(FilledButton));
  await tester.pumpAndSettle();
}

MockRegisterUseCase mockUseCaseReturning(Result<LoginResult> value) {
  final useCase = MockRegisterUseCase();
  when(
    () => useCase(
      name: any(named: 'name'),
      email: any(named: 'email'),
      password: any(named: 'password'),
      locale: any(named: 'locale'),
      digits: any(named: 'digits'),
    ),
  ).thenAnswer((_) async => value);
  return useCase;
}

void main() {
  setUpAll(() async {
    EasyLocalization.logger.enableBuildModes = [];
    arabic = jsonDecode(
      await File(AppAssets.translationFile(AppLocales.arabic)).readAsString(),
    ) as Map<String, dynamic>;
  });

  testWidgets('submitting empty fields does not call the use case', (tester) async {
    final useCase = mockUseCaseReturning(const Error(NetworkFailure()));
    await pumpRegisterScreen(tester, useCase);

    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    verifyNever(
      () => useCase(
        name: any(named: 'name'),
        email: any(named: 'email'),
        password: any(named: 'password'),
        locale: any(named: 'locale'),
        digits: any(named: 'digits'),
      ),
    );
  });

  testWidgets('valid form calls the use case once with ar locale and arabic digits', (tester) async {
    final useCase = mockUseCaseReturning(const Error(NetworkFailure()));
    await pumpRegisterScreen(tester, useCase);

    await fillAndSubmit(
      tester,
      name: _name,
      email: _email,
      password: _password,
    );

    verify(
      () => useCase(
        name: _name,
        email: _email,
        password: _password,
        locale: ApiLocaleValues.arabicLocale,
        digits: ApiLocaleValues.arabicDigits,
      ),
    ).called(1);
  });

  testWidgets('strength meter text follows the typed password', (tester) async {
    await pumpRegisterScreen(
      tester,
      mockUseCaseReturning(const Error(NetworkFailure())),
    );

    expect(
      find.text(arabicText(TranslationKeys.passwordStrengthHint)),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextField).at(2), 'abc');
    await tester.pump();
    expect(
      find.text(arabicText(TranslationKeys.passwordStrengthShort)),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextField).at(2), 'Abcdefg1!');
    await tester.pump();
    expect(
      find.text(arabicText(TranslationKeys.passwordStrengthVeryStrong)),
      findsOneWidget,
    );
  });

  testWidgets('editing the email clears the email_taken server error', (tester) async {
    final useCase = mockUseCaseReturning(
      const Error(ConflictFailure(ApiErrorCodes.emailTaken)),
    );
    await pumpRegisterScreen(tester, useCase);

    await fillAndSubmit(
      tester,
      name: _name,
      email: _email,
      password: _password,
    );

    final serverError = find.text(
      arabicText(TranslationKeys.validationEmailTaken),
    );
    expect(serverError, findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);

    await tester.enterText(find.byType(TextField).at(1), 'ahmed2@example.com');
    await tester.pump();

    expect(serverError, findsNothing);
  });
}

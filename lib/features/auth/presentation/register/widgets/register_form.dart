import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/api_locale_values.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/constants/app_locales.dart';
import '../../../../../core/constants/translation_keys.dart';
import '../../../../../core/error/failure.dart';
import '../register_cubit.dart';
import '../register_failure_message.dart';
import '../register_intent.dart';
import '../register_state.dart';
import 'register_email_field.dart';
import 'register_name_field.dart';
import 'register_password_field.dart';
import 'register_submit_button.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key, required this.state});

  final RegisterState state;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _serverEmailErrorKey;
  String? _rejectedEmail;

  @override
  void initState() {
    super.initState();
    _name.addListener(_onChanged);
    _email.addListener(_onChanged);
    _password.addListener(_onChanged);
  }

  @override
  void didUpdateWidget(RegisterForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    final failure = widget.state.failure;
    if (failure == null || failure == oldWidget.state.failure) return;
    if (isEmailTakenFailure(failure)) {
      _serverEmailErrorKey = TranslationKeys.validationEmailTaken;
      _rejectedEmail = _email.text;
    } else if (failure is UnauthorizedFailure) {
      _password.clear();
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {
    if (_rejectedEmail != null && _email.text != _rejectedEmail) {
      _serverEmailErrorKey = null;
      _rejectedEmail = null;
    }
  });

  bool get _hasInput =>
      _name.text.trim().isNotEmpty &&
      _email.text.trim().isNotEmpty &&
      _password.text.isNotEmpty;

  void _submit() {
    if (!_hasInput || widget.state.isSubmitting) return;
    final cubit = context.read<RegisterCubit>();
    cubit.doEvent(const RegisterSubmitAttempted());
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final isArabic =
        context.locale.languageCode == AppLocales.arabic.languageCode;
    cubit.doEvent(
      RegisterSubmitted(
        name: _name.text.trim(),
        email: _email.text.trim(),
        password: _password.text,
        locale: isArabic
            ? ApiLocaleValues.arabicLocale
            : ApiLocaleValues.englishLocale,
        digits: isArabic
            ? ApiLocaleValues.arabicDigits
            : ApiLocaleValues.englishDigits,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final autovalidateMode = state.hasSubmitted
        ? AutovalidateMode.onUnfocus
        : AutovalidateMode.disabled;
    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RegisterNameField(
              controller: _name,
              enabled: !state.isSubmitting,
              autovalidateMode: autovalidateMode,
            ),
            const SizedBox(height: AppDimensions.lg),
            RegisterEmailField(
              controller: _email,
              enabled: !state.isSubmitting,
              autovalidateMode: autovalidateMode,
              serverErrorKey: _serverEmailErrorKey,
            ),
            const SizedBox(height: AppDimensions.lg),
            RegisterPasswordField(
              controller: _password,
              enabled: !state.isSubmitting,
              autovalidateMode: autovalidateMode,
              isVisible: state.isPasswordVisible,
              onSubmitted: _submit,
            ),
            const SizedBox(height: AppDimensions.lg),
            RegisterSubmitButton(
              isSubmitting: state.isSubmitting,
              hasInput: _hasInput,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

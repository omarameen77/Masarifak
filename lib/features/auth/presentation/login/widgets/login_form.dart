import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/constants/translation_keys.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/validation/app_validators.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../login_cubit.dart';
import '../login_intent.dart';
import '../login_state.dart';
import 'login_forgot_password_link.dart';
import 'login_password_visibility_button.dart';
import 'login_submit_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.state});

  final LoginState state;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _email.addListener(_onChanged);
    _password.addListener(_onChanged);
  }

  @override
  void didUpdateWidget(LoginForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    final failure = widget.state.failure;
    if (failure != oldWidget.state.failure && failure is UnauthorizedFailure) {
      _autovalidateMode = AutovalidateMode.disabled;
      _password.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _formKey.currentState?.reset();
      });
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  bool get _hasInput =>
      _email.text.trim().isNotEmpty && _password.text.isNotEmpty;

  void _submit() {
    if (!_hasInput || widget.state.isSubmitting) return;
    setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<LoginCubit>().doEvent(
      LoginSubmitted(_email.text.trim(), _password.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _email,
              labelKey: TranslationKeys.loginEmailLabel,
              hintKey: TranslationKeys.loginEmailHint,
              validator: AppValidators.email,
              keyboardType: TextInputType.emailAddress,
              textDirection: TextDirection.ltr,
              autofillHints: const [AutofillHints.email],
              textInputAction: TextInputAction.next,
              enabled: !state.isSubmitting,
              autovalidateMode: _autovalidateMode,
            ),
            const SizedBox(height: AppDimensions.lg),
            AppTextField(
              controller: _password,
              labelKey: TranslationKeys.loginPasswordLabel,
              validator: AppValidators.password,
              obscureText: !state.isPasswordVisible,
              suffixIcon: LoginPasswordVisibilityButton(
                isVisible: state.isPasswordVisible,
              ),
              textDirection: TextDirection.ltr,
              autofillHints: const [AutofillHints.password],
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              enabled: !state.isSubmitting,
              autovalidateMode: _autovalidateMode,
            ),
            const SizedBox(height: AppDimensions.xs),
            const LoginForgotPasswordLink(),
            const SizedBox(height: AppDimensions.md),
            LoginSubmitButton(
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

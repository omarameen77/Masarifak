import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/error/failure.dart';
import '../login_cubit.dart';
import '../login_intent.dart';
import '../login_state.dart';
import 'login_email_field.dart';
import 'login_password_field.dart';
import 'login_submit_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.state});

  final LoginState state;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _email = TextEditingController();
  final _password = TextEditingController();

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
      _password.clear();
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
    context.read<LoginCubit>().doEvent(
      LoginSubmitted(_email.text.trim(), _password.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LoginEmailField(controller: _email, enabled: !state.isSubmitting),
          const SizedBox(height: AppDimensions.lg),
          LoginPasswordField(
            controller: _password,
            enabled: !state.isSubmitting,
            isVisible: state.isPasswordVisible,
            onSubmitted: _submit,
          ),
          const SizedBox(height: AppDimensions.lg),
          LoginSubmitButton(
            isSubmitting: state.isSubmitting,
            hasInput: _hasInput,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

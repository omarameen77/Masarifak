import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/translation_keys.dart';
import '../login_cubit.dart';
import '../login_intent.dart';
import 'login_field_label.dart';

class LoginPasswordField extends StatelessWidget {
  const LoginPasswordField({
    super.key,
    required this.controller,
    required this.enabled,
    required this.isVisible,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final bool enabled;
  final bool isVisible;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const LoginFieldLabel(TranslationKeys.loginPasswordLabel),
        TextField(
          controller: controller,
          enabled: enabled,
          obscureText: !isVisible,
          textInputAction: TextInputAction.done,
          textDirection: TextDirection.ltr,
          textAlign: Directionality.of(context) == TextDirection.rtl
              ? TextAlign.right
              : TextAlign.left,
          autocorrect: false,
          enableSuggestions: false,
          autofillHints: const [AutofillHints.password],
          onSubmitted: (_) => onSubmitted(),
          decoration: InputDecoration(
            suffixIcon: IconButton(
              tooltip: context.tr(
                isVisible
                    ? TranslationKeys.loginHidePassword
                    : TranslationKeys.loginShowPassword,
              ),
              onPressed: () => context.read<LoginCubit>().doEvent(
                const LoginPasswordVisibilityToggled(),
              ),
              icon: Icon(
                isVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

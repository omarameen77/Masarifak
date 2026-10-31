import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/translation_keys.dart';
import '../../../../../core/validation/app_validators.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../../../core/widgets/password_strength_meter.dart';
import '../register_cubit.dart';
import '../register_intent.dart';

class RegisterPasswordField extends StatelessWidget {
  const RegisterPasswordField({
    super.key,
    required this.controller,
    required this.enabled,
    required this.autovalidateMode,
    required this.isVisible,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final bool enabled;
  final AutovalidateMode autovalidateMode;
  final bool isVisible;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: controller,
          labelKey: TranslationKeys.loginPasswordLabel,
          validator: AppValidators.password,
          obscureText: !isVisible,
          suffixIcon: IconButton(
            tooltip: context.tr(
              isVisible
                  ? TranslationKeys.loginHidePassword
                  : TranslationKeys.loginShowPassword,
            ),
            onPressed: () => context.read<RegisterCubit>().doEvent(
              const RegisterPasswordVisibilityToggled(),
            ),
            icon: Icon(
              isVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
          ),
          textDirection: TextDirection.ltr,
          autofillHints: const [AutofillHints.newPassword],
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => onSubmitted(),
          enabled: enabled,
          autovalidateMode: autovalidateMode,
        ),
        PasswordStrengthMeter(controller: controller),
      ],
    );
  }
}

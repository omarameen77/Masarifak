import 'package:flutter/material.dart';

import '../../../../../core/constants/translation_keys.dart';
import '../../../../../core/validation/app_validators.dart';
import '../../../../../core/widgets/app_text_field.dart';

class RegisterEmailField extends StatelessWidget {
  const RegisterEmailField({
    super.key,
    required this.controller,
    required this.enabled,
    required this.autovalidateMode,
    this.serverErrorKey,
  });

  final TextEditingController controller;
  final bool enabled;
  final AutovalidateMode autovalidateMode;
  final String? serverErrorKey;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      labelKey: TranslationKeys.loginEmailLabel,
      hintKey: TranslationKeys.loginEmailHint,
      validator: AppValidators.email,
      keyboardType: TextInputType.emailAddress,
      textDirection: TextDirection.ltr,
      autofillHints: const [AutofillHints.email],
      textInputAction: TextInputAction.next,
      enabled: enabled,
      autovalidateMode: autovalidateMode,
      serverErrorKey: serverErrorKey,
    );
  }
}

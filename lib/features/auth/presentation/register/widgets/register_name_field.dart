import 'package:flutter/material.dart';

import '../../../../../core/constants/translation_keys.dart';
import '../../../../../core/validation/app_validators.dart';
import '../../../../../core/widgets/app_text_field.dart';

class RegisterNameField extends StatelessWidget {
  const RegisterNameField({
    super.key,
    required this.controller,
    required this.enabled,
    required this.autovalidateMode,
  });

  final TextEditingController controller;
  final bool enabled;
  final AutovalidateMode autovalidateMode;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      labelKey: TranslationKeys.registerNameLabel,
      hintKey: TranslationKeys.registerNameHint,
      validator: AppValidators.name,
      keyboardType: TextInputType.name,
      autofillHints: const [AutofillHints.givenName],
      textInputAction: TextInputAction.next,
      enabled: enabled,
      autovalidateMode: autovalidateMode,
    );
  }
}

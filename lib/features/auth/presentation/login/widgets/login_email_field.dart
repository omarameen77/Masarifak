import 'package:flutter/material.dart';

import '../../../../../core/constants/translation_keys.dart';
import 'login_field_label.dart';

class LoginEmailField extends StatelessWidget {
  const LoginEmailField({
    super.key,
    required this.controller,
    required this.enabled,
  });

  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const LoginFieldLabel(TranslationKeys.loginEmailLabel),
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          textDirection: TextDirection.ltr,
          textAlign: Directionality.of(context) == TextDirection.rtl
              ? TextAlign.right
              : TextAlign.left,
          autocorrect: false,
          autofillHints: const [AutofillHints.email],
        ),
      ],
    );
  }
}

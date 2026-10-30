import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/translation_keys.dart';

class LoginSubmitButton extends StatelessWidget {
  const LoginSubmitButton({
    super.key,
    required this.isSubmitting,
    required this.hasInput,
    required this.onPressed,
  });

  final bool isSubmitting;
  final bool hasInput;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: hasInput && !isSubmitting ? onPressed : null,
      child: Text(context.tr(TranslationKeys.loginSubmit)),
    );
  }
}

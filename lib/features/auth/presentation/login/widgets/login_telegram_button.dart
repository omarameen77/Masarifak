import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/translation_keys.dart';

class LoginTelegramButton extends StatelessWidget {
  const LoginTelegramButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.send_outlined),
      label: Text(context.tr(TranslationKeys.loginTelegram)),
    );
  }
}

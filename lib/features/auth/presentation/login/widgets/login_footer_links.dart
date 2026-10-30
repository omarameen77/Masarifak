import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_routes.dart';
import '../../../../../core/constants/translation_keys.dart';

class LoginFooterLinks extends StatelessWidget {
  const LoginFooterLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () => context.push(AppRoutes.forgotPassword),
          child: Text(context.tr(TranslationKeys.loginForgotPassword)),
        ),
        TextButton(
          onPressed: () => context.push(AppRoutes.register),
          child: Text(context.tr(TranslationKeys.loginRegisterLink)),
        ),
      ],
    );
  }
}

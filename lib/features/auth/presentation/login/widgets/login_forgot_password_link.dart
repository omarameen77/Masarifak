import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_routes.dart';
import '../../../../../core/constants/translation_keys.dart';

class LoginForgotPasswordLink extends StatelessWidget {
  const LoginForgotPasswordLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: TextButton(
        onPressed: () => context.push(AppRoutes.forgotPassword),
        child: Text(context.tr(TranslationKeys.loginForgotPassword)),
      ),
    );
  }
}

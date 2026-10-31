import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/constants/app_routes.dart';
import '../../../../../core/constants/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';

class LoginRegisterPrompt extends StatelessWidget {
  const LoginRegisterPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          context.tr(TranslationKeys.loginNoAccount),
          style: TextStyle(
            fontSize: AppDimensions.secondaryFontSize,
            color: colors.ink2,
          ),
        ),
        TextButton(
          onPressed: () => context.push(AppRoutes.register),
          child: Text(context.tr(TranslationKeys.loginRegisterLink)),
        ),
      ],
    );
  }
}

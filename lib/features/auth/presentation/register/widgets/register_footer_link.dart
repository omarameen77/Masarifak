import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/constants/app_routes.dart';
import '../../../../../core/constants/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';

class RegisterFooterLink extends StatelessWidget {
  const RegisterFooterLink({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          context.tr(TranslationKeys.registerHaveAccount),
          style: TextStyle(
            fontSize: AppDimensions.secondaryFontSize,
            color: colors.ink2,
          ),
        ),
        TextButton(
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(AppRoutes.login),
          child: Text(context.tr(TranslationKeys.registerLoginLink)),
        ),
      ],
    );
  }
}

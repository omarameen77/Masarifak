import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/constants/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';

class LoginDivider extends StatelessWidget {
  const LoginDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Row(
      children: [
        Expanded(child: Divider(color: colors.line)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
          child: Text(
            context.tr(TranslationKeys.loginOr),
            style: TextStyle(
              fontSize: AppDimensions.captionFontSize,
              color: colors.muted,
            ),
          ),
        ),
        Expanded(child: Divider(color: colors.line)),
      ],
    );
  }
}

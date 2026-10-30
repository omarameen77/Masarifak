import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/constants/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.tr(TranslationKeys.loginHeading),
          style: textTheme.headlineSmall,
        ),
        const SizedBox(height: AppDimensions.xs),
        Text(
          context.tr(TranslationKeys.loginSubheading),
          style: textTheme.bodyMedium?.copyWith(
            fontSize: AppDimensions.secondaryFontSize,
            color: colors.muted,
          ),
        ),
      ],
    );
  }
}

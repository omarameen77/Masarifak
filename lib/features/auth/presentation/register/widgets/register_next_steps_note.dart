import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/constants/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';

class RegisterNextStepsNote extends StatelessWidget {
  const RegisterNextStepsNote({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Text(
      context.tr(TranslationKeys.registerNextStepsNote),
      style: TextStyle(
        fontSize: AppDimensions.captionFontSize,
        color: colors.muted,
      ),
    );
  }
}

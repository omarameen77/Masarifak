import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';

class LoginFieldLabel extends StatelessWidget {
  const LoginFieldLabel(this.translationKey, {super.key});

  final String translationKey;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: AppDimensions.fieldLabelGap),
      child: Text(
        context.tr(translationKey),
        style: TextStyle(
          fontSize: AppDimensions.labelFontSize,
          fontWeight: FontWeight.w500,
          color: colors.ink2,
        ),
      ),
    );
  }
}

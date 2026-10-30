import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';

class LoginErrorNote extends StatelessWidget {
  const LoginErrorNote({super.key, required this.messageKey});

  final String messageKey;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.md,
        horizontal: AppDimensions.inputPaddingHorizontal,
      ),
      decoration: BoxDecoration(
        color: colors.critSoft,
        border: Border.all(color: colors.critLine),
        borderRadius: BorderRadius.circular(AppDimensions.radius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_outlined,
            color: colors.crit,
            size: AppDimensions.noteIconSize,
          ),
          const SizedBox(width: AppDimensions.noteIconGap),
          Expanded(
            child: Text(
              context.tr(messageKey),
              style: TextStyle(
                fontSize: AppDimensions.secondaryFontSize,
                color: colors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/constants/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';

class LoginBrand extends StatelessWidget {
  const LoginBrand({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          width: AppDimensions.brandMarkSize,
          height: AppDimensions.brandMarkSize,
          decoration: BoxDecoration(
            color: colors.acc,
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          ),
          child: Icon(
            Icons.account_balance_wallet_outlined,
            size: AppDimensions.brandIconSize,
            color: colors.accInk,
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        Text(
          context.tr(TranslationKeys.appName),
          style: textTheme.titleMedium?.copyWith(
            color: colors.accText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

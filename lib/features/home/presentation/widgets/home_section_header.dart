import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/translation_keys.dart';
import '../../../../core/theme/app_colors.dart';

class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({super.key, required this.titleKey, this.onSeeAll});

  final String titleKey;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.only(
        top: AppDimensions.sectionTopGap,
        bottom: AppDimensions.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                context.tr(titleKey),
                style: TextStyle(
                  fontSize: AppDimensions.sectionTitleFontSize,
                  fontWeight: FontWeight.w600,
                  color: colors.ink,
                ),
              ),
            ),
          ),
          if (onSeeAll case final seeAll?)
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.padded,
              ),
              onPressed: seeAll,
              child: Text(context.tr(TranslationKeys.homeSeeAll)),
            ),
        ],
      ),
    );
  }
}

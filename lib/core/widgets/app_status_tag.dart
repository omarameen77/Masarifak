import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../theme/app_colors.dart';

enum AppStatusTone { neutral, ok, warn, critical }

class AppStatusTag extends StatelessWidget {
  const AppStatusTag({
    super.key,
    required this.label,
    this.icon,
    this.tone = AppStatusTone.neutral,
  });

  final String label;
  final IconData? icon;
  final AppStatusTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final (background, foreground) = switch (tone) {
      AppStatusTone.neutral => (colors.sunk, colors.ink2),
      AppStatusTone.ok => (colors.accSoft, colors.accText),
      AppStatusTone.warn => (colors.warnSoft, colors.warn),
      AppStatusTone.critical => (colors.critSoft, colors.crit),
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.tagPaddingHorizontal,
        vertical: AppDimensions.tagPaddingVertical,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppDimensions.pillRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon case final icon?) ...[
            Icon(icon, size: AppDimensions.tagIconSize, color: foreground),
            const SizedBox(width: AppDimensions.xs),
          ],
          Text(
            label,
            maxLines: 1,
            style: TextStyle(
              fontSize: AppDimensions.tagFontSize,
              fontWeight: FontWeight.w500,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}

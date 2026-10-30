import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../theme/app_colors.dart';

class AppListRow extends StatelessWidget {
  const AppListRow({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final String? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppDimensions.rowMinHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.rowPaddingVertical,
            horizontal: AppDimensions.inputPaddingHorizontal,
          ),
          child: Row(
            children: [
              if (icon case final icon?) ...[
                Container(
                  width: AppDimensions.choiceIconBox,
                  height: AppDimensions.choiceIconBox,
                  decoration: BoxDecoration(
                    color: colors.sunk,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                  ),
                  child: Icon(
                    icon,
                    size: AppDimensions.choiceIconSize,
                    color: colors.ink2,
                  ),
                ),
                const SizedBox(width: AppDimensions.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: AppDimensions.bodyFontSize,
                        fontWeight: FontWeight.w500,
                        color: colors.ink,
                      ),
                    ),
                    if (subtitle case final subtitle?)
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: AppDimensions.captionFontSize,
                          color: colors.muted,
                        ),
                      ),
                  ],
                ),
              ),
              if (trailing case final trailing?) ...[
                const SizedBox(width: AppDimensions.md),
                Text(
                  trailing,
                  style: TextStyle(
                    fontSize: AppDimensions.bodyFontSize,
                    fontWeight: FontWeight.w600,
                    color: colors.ink,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../theme/app_colors.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.emptyPaddingVertical,
        horizontal: AppDimensions.emptyPaddingHorizontal,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppDimensions.emptyIconBox,
            height: AppDimensions.emptyIconBox,
            decoration: BoxDecoration(
              color: colors.accSoft,
              borderRadius: BorderRadius.circular(AppDimensions.emptyIconRadius),
            ),
            child: Icon(icon, color: colors.accText),
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppDimensions.secondaryFontSize,
              color: colors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

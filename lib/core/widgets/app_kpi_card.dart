import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../theme/app_colors.dart';

class AppKpiCard extends StatelessWidget {
  const AppKpiCard({
    super.key,
    required this.label,
    required this.value,
    this.caption,
  });

  final String label;
  final String value;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.md,
        horizontal: AppDimensions.inputPaddingHorizontal,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(color: colors.line, width: AppDimensions.borderWidth),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppDimensions.captionFontSize,
              color: colors.muted,
            ),
          ),
          const SizedBox(height: AppDimensions.kpiValueGap),
          Text(
            value,
            style: TextStyle(
              fontSize: AppDimensions.kpiValueFontSize,
              fontWeight: FontWeight.w600,
              color: colors.ink,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          if (caption case final caption?) ...[
            const SizedBox(height: AppDimensions.kpiValueGap),
            Text(
              caption,
              style: TextStyle(
                fontSize: AppDimensions.kpiCaptionFontSize,
                color: colors.muted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

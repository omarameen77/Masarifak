import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/translation_keys.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_skeleton_box.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  static const int _rowCount = 3;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      semanticLabel: context.tr(TranslationKeys.homeLoading),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.pageGutter,
          vertical: AppDimensions.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppSkeletonBox(
                        height: AppDimensions.skeletonTitleHeight,
                        widthFactor: AppDimensions.skeletonWideFactor,
                      ),
                      SizedBox(height: AppDimensions.sm),
                      AppSkeletonBox(
                        height: AppDimensions.skeletonLineHeight,
                        widthFactor: AppDimensions.skeletonMediumFactor,
                      ),
                    ],
                  ),
                ),
                for (var i = 0; i < _rowCount; i++) ...[
                  const SizedBox(width: AppDimensions.md),
                  const SizedBox(
                    width: AppDimensions.avatarSize,
                    child: AppSkeletonBox(
                      height: AppDimensions.avatarSize,
                      radius: AppDimensions.avatarSize,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppDimensions.xl),
            const AppSkeletonBox(
              height: AppDimensions.skeletonLineHeight,
              widthFactor: AppDimensions.skeletonShortFactor,
            ),
            const SizedBox(height: AppDimensions.sm),
            const AppSkeletonBox(
              height: AppDimensions.skeletonAmountHeight,
              widthFactor: AppDimensions.skeletonWideFactor,
            ),
            const SizedBox(height: AppDimensions.sm),
            const AppSkeletonBox(
              height: AppDimensions.skeletonLineHeight,
              widthFactor: AppDimensions.skeletonMediumFactor,
            ),
            const SizedBox(height: AppDimensions.lg),
            const Row(
              children: [
                Expanded(
                  child: AppSkeletonBox(
                    height: AppDimensions.skeletonKpiHeight,
                    radius: AppDimensions.radius,
                  ),
                ),
                SizedBox(width: AppDimensions.kpiGap),
                Expanded(
                  child: AppSkeletonBox(
                    height: AppDimensions.skeletonKpiHeight,
                    radius: AppDimensions.radius,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.lg),
            const AppSkeletonBox(
              height: AppDimensions.skeletonRulerHeight,
              radius: AppDimensions.radius,
            ),
            const SizedBox(height: AppDimensions.md),
            const AppSkeletonBox(
              height: AppDimensions.skeletonNoteHeight,
              radius: AppDimensions.radius,
            ),
            const SizedBox(height: AppDimensions.lg),
            const Row(
              children: [
                Expanded(
                  child: AppSkeletonBox(
                    height: AppDimensions.quickActionHeight,
                    radius: AppDimensions.radiusControl,
                  ),
                ),
                SizedBox(width: AppDimensions.kpiGap),
                Expanded(
                  child: AppSkeletonBox(
                    height: AppDimensions.quickActionHeight,
                    radius: AppDimensions.radiusControl,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.sectionTopGap),
            const AppSkeletonBox(
              height: AppDimensions.skeletonLineHeight,
              widthFactor: AppDimensions.skeletonShortFactor,
            ),
            for (var i = 0; i < _rowCount; i++) ...[
              const SizedBox(height: AppDimensions.sm),
              const AppSkeletonBox(
                height: AppDimensions.skeletonRowHeight,
                radius: AppDimensions.radius,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

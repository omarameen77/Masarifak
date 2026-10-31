import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_motion.dart';
import '../../../../core/theme/app_colors.dart';

class CycleTimeline extends StatelessWidget {
  const CycleTimeline({
    super.key,
    required this.progress,
    this.floorProgress,
    this.semanticLabel,
  });

  final double progress;
  final double? floorProgress;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Semantics(
      label: semanticLabel,
      child: ExcludeSemantics(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            const dot = AppDimensions.timelineDotSize;
            return SizedBox(
              height: dot,
              child: Stack(
                alignment: AlignmentDirectional.centerStart,
                children: [
                  Positioned.fill(
                    top: (dot - AppDimensions.meterHeight) / 2,
                    bottom: (dot - AppDimensions.meterHeight) / 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.meterRadius,
                      ),
                      child: ColoredBox(
                        color: colors.sunk,
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: progress),
                            duration: AppMotion.meterFillDuration,
                            curve: AppMotion.meterFillCurve,
                            builder: (_, value, _) => FractionallySizedBox(
                              widthFactor: value,
                              heightFactor: 1,
                              child: ColoredBox(
                                color: colors.acc.withValues(
                                  alpha: AppDimensions.timelinePastOpacity,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (floorProgress case final floor?)
                    _dot(width, floor, colors.warn, colors.surface),
                  _dot(width, progress, colors.acc, colors.surface),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _dot(double width, double at, Color fill, Color border) =>
      PositionedDirectional(
        start: (width * at - AppDimensions.timelineDotSize / 2).clamp(
          0.0,
          width - AppDimensions.timelineDotSize,
        ),
        child: Container(
          width: AppDimensions.timelineDotSize,
          height: AppDimensions.timelineDotSize,
          decoration: BoxDecoration(
            color: fill,
            shape: BoxShape.circle,
            border: Border.all(
              color: border,
              width: AppDimensions.radioBorderWidth,
            ),
          ),
        ),
      );
}

import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_motion.dart';
import '../../../../core/theme/app_colors.dart';

class RulerMeter extends StatelessWidget {
  const RulerMeter({
    super.key,
    required this.fill,
    required this.marker,
    required this.color,
    this.semanticLabel,
  });

  final double fill;
  final double marker;
  final Color color;
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
            return SizedBox(
              height: AppDimensions.meterHeight +
                  AppDimensions.meterMarkerOverflow * 2,
              child: Stack(
                children: [
                  PositionedDirectional(
                    start: 0,
                    end: 0,
                    top: AppDimensions.meterMarkerOverflow,
                    bottom: AppDimensions.meterMarkerOverflow,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.meterRadius,
                      ),
                      child: ColoredBox(
                        color: colors.sunk,
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: fill),
                            duration: AppMotion.meterFillDuration,
                            curve: AppMotion.meterFillCurve,
                            builder: (_, value, _) => FractionallySizedBox(
                              widthFactor: value,
                              heightFactor: 1,
                              child: ColoredBox(color: color),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    start: width * marker - AppDimensions.meterMarkerWidth / 2,
                    top: 0,
                    bottom: 0,
                    width: AppDimensions.meterMarkerWidth,
                    child: ColoredBox(color: colors.ink),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

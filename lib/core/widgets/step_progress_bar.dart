import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../constants/app_durations.dart';
import '../theme/app_colors.dart';

class StepProgressBar extends StatelessWidget {
  const StepProgressBar({
    super.key,
    required this.current,
    required this.total,
    this.semanticLabel,
  });

  final int current;
  final int total;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Semantics(
      label: semanticLabel,
      child: ExcludeSemantics(
        child: Row(
          children: [
            for (var i = 0; i < total; i++) ...[
              if (i > 0) const SizedBox(width: AppDimensions.stepBarGap),
              Expanded(
                child: AnimatedContainer(
                  duration: AppDurations.pageFade,
                  height: AppDimensions.stepBarHeight,
                  decoration: BoxDecoration(
                    color: i < current ? colors.acc : colors.line,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.stepBarRadius,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

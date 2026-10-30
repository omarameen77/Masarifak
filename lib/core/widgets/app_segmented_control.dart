import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../constants/app_durations.dart';
import '../theme/app_colors.dart';
import 'app_choice_option.dart';

class AppSegmentedControl<T> extends StatelessWidget {
  const AppSegmentedControl({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<AppChoiceOption<T>> options;
  final T selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      padding: const EdgeInsets.all(AppDimensions.segmentPadding),
      decoration: BoxDecoration(
        color: colors.sunk,
        borderRadius: BorderRadius.circular(AppDimensions.radiusControl),
      ),
      child: Row(
        children: [
          for (final (index, option) in options.indexed) ...[
            if (index > 0) const SizedBox(width: AppDimensions.segmentGap),
            Expanded(child: _segment(colors, option, option.value == selected)),
          ],
        ],
      ),
    );
  }

  Widget _segment(AppColors colors, AppChoiceOption<T> option, bool isSelected) {
    return Semantics(
      selected: isSelected,
      inMutuallyExclusiveGroup: true,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onSelected(option.value),
        child: AnimatedContainer(
          duration: AppDurations.short,
          constraints: const BoxConstraints(
            minHeight: AppDimensions.segmentMinHeight,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? colors.surface : null,
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: colors.shadow.withValues(
                        alpha: AppDimensions.segmentShadowOpacity,
                      ),
                      blurRadius: AppDimensions.segmentShadowBlur,
                      offset: const Offset(0, AppDimensions.borderWidth),
                    ),
                  ]
                : null,
          ),
          child: Text(
            option.label,
            style: TextStyle(
              fontSize: AppDimensions.secondaryFontSize,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? colors.ink : colors.ink2,
            ),
          ),
        ),
      ),
    );
  }
}

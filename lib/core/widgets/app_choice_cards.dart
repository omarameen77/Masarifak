import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../theme/app_colors.dart';
import 'app_choice_option.dart';

class AppChoiceCards<T> extends StatelessWidget {
  const AppChoiceCards({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<AppChoiceOption<T>> options;
  final T? selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, option) in options.indexed) ...[
          if (index > 0) const SizedBox(height: AppDimensions.sm),
          _card(colors, option, option.value == selected),
        ],
      ],
    );
  }

  Widget _card(AppColors colors, AppChoiceOption<T> option, bool isSelected) {
    return Semantics(
      selected: isSelected,
      inMutuallyExclusiveGroup: true,
      button: true,
      child: Material(
        color: isSelected ? colors.accSoft : colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius),
          side: BorderSide(
            color: isSelected ? colors.acc : colors.line2,
            width: AppDimensions.borderWidth,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => onSelected(option.value),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppDimensions.choiceMinHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.md,
                horizontal: AppDimensions.inputPaddingHorizontal,
              ),
              child: Row(
                children: [
                  if (option.icon case final icon?) ...[
                    Container(
                      width: AppDimensions.choiceIconBox,
                      height: AppDimensions.choiceIconBox,
                      decoration: BoxDecoration(
                        color: colors.sunk,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusSmall,
                        ),
                      ),
                      child: Icon(
                        icon,
                        size: AppDimensions.choiceIconSize,
                        color: colors.ink2,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.md),
                  ],
                  Expanded(child: _texts(colors, option)),
                  const SizedBox(width: AppDimensions.md),
                  _radio(colors, isSelected),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _texts(AppColors colors, AppChoiceOption<T> option) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        option.label,
        style: TextStyle(
          fontSize: AppDimensions.bodyFontSize,
          fontWeight: FontWeight.w600,
          color: colors.ink,
        ),
      ),
      if (option.description case final description?)
        Text(
          description,
          style: TextStyle(
            fontSize: AppDimensions.captionFontSize,
            color: colors.muted,
          ),
        ),
    ],
  );

  Widget _radio(AppColors colors, bool isSelected) => Container(
    width: AppDimensions.radioSize,
    height: AppDimensions.radioSize,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: isSelected ? colors.acc : colors.line2,
        width: AppDimensions.radioBorderWidth,
      ),
    ),
    alignment: Alignment.center,
    child: isSelected
        ? Container(
            width: AppDimensions.radioDotSize,
            height: AppDimensions.radioDotSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.acc,
            ),
          )
        : null,
  );
}

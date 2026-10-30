import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../theme/app_colors.dart';
import 'app_choice_option.dart';

class AppChoiceChips<T> extends StatelessWidget {
  const AppChoiceChips({
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
    return Wrap(
      spacing: AppDimensions.sm,
      runSpacing: AppDimensions.sm,
      children: [
        for (final option in options)
          _chip(colors, option, option.value == selected),
      ],
    );
  }

  Widget _chip(AppColors colors, AppChoiceOption<T> option, bool isSelected) {
    final foreground = isSelected ? colors.accText : colors.ink;
    return Semantics(
      selected: isSelected,
      button: true,
      child: Material(
        color: isSelected ? colors.accSoft : colors.surface,
        shape: StadiumBorder(
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
              minHeight: AppDimensions.chipMinHeight,
              minWidth: AppDimensions.chipMinHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.chipPaddingHorizontal,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (option.icon case final icon?) ...[
                    Icon(
                      icon,
                      size: AppDimensions.chipIconSize,
                      color: foreground,
                    ),
                    const SizedBox(width: AppDimensions.xs),
                  ],
                  Text(
                    option.label,
                    style: TextStyle(
                      fontSize: AppDimensions.secondaryFontSize,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: foreground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

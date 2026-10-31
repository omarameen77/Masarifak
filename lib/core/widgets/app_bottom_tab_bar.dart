import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../theme/app_colors.dart';
import 'app_bottom_tab_item.dart';

class AppBottomTabBar extends StatelessWidget {
  const AppBottomTabBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.semanticLabel,
  });

  final List<AppBottomTabItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Semantics(
      container: true,
      label: semanticLabel,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(
            top: BorderSide(color: colors.line, width: AppDimensions.borderWidth),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.tabBarPadding),
            child: Row(
              children: [
                for (final (index, item) in items.indexed)
                  Expanded(
                    child: _tab(colors, item, index == selectedIndex, index),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tab(
    AppColors colors,
    AppBottomTabItem item,
    bool isSelected,
    int index,
  ) {
    final color = isSelected ? colors.accText : colors.muted;
    return Semantics(
      selected: isSelected,
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusControl),
        onTap: () => onSelected(index),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppDimensions.tabMinHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? item.selectedIcon : item.icon,
                size: AppDimensions.tabIconSize,
                color: color,
              ),
              const SizedBox(height: AppDimensions.tabIconLabelGap),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: AppDimensions.tabLabelFontSize,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

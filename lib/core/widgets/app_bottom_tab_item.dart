import 'package:flutter/widgets.dart';

class AppBottomTabItem {
  const AppBottomTabItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

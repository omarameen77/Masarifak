import 'package:flutter/material.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/translation_keys.dart';

enum MainTab {
  home(
    route: AppRoutes.home,
    labelKey: TranslationKeys.tabHome,
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
  ),
  expenses(
    route: AppRoutes.expenses,
    labelKey: TranslationKeys.tabExpenses,
    icon: Icons.receipt_long_outlined,
    selectedIcon: Icons.receipt_long,
  ),
  obligations(
    route: AppRoutes.obligations,
    labelKey: TranslationKeys.tabObligations,
    icon: Icons.calendar_month_outlined,
    selectedIcon: Icons.calendar_month,
  ),
  ask(
    route: AppRoutes.ask,
    labelKey: TranslationKeys.tabAsk,
    icon: Icons.chat_bubble_outline,
    selectedIcon: Icons.chat_bubble,
  );

  const MainTab({
    required this.route,
    required this.labelKey,
    required this.icon,
    required this.selectedIcon,
  });

  final String route;
  final String labelKey;
  final IconData icon;
  final IconData selectedIcon;
}

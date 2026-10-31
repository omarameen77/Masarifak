import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/translation_keys.dart';
import '../../../core/widgets/app_bottom_tab_bar.dart';
import '../../../core/widgets/app_bottom_tab_item.dart';
import 'main_layout_cubit.dart';
import 'main_layout_intent.dart';
import 'main_layout_state.dart';
import 'main_tab.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  @override
  void initState() {
    super.initState();
    _syncFromRouter();
  }

  @override
  void didUpdateWidget(MainLayoutScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.navigationShell.currentIndex !=
        widget.navigationShell.currentIndex) {
      _syncFromRouter();
    }
  }

  void _syncFromRouter() => context.read<MainLayoutCubit>().doEvent(
    MainTabSynced(MainTab.values[widget.navigationShell.currentIndex]),
  );

  void _goTo(MainTab tab, {bool toRoot = false}) =>
      widget.navigationShell.goBranch(tab.index, initialLocation: toRoot);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MainLayoutCubit, MainLayoutState>(
          listenWhen: (previous, current) =>
              previous.currentTab != current.currentTab &&
              current.currentTab.index != widget.navigationShell.currentIndex,
          listener: (_, state) => _goTo(state.currentTab),
        ),
        BlocListener<MainLayoutCubit, MainLayoutState>(
          listenWhen: (previous, current) =>
              previous.rootRequests != current.rootRequests,
          listener: (_, state) => _goTo(state.currentTab, toRoot: true),
        ),
      ],
      child: BlocBuilder<MainLayoutCubit, MainLayoutState>(
        builder: (context, state) => PopScope(
          canPop: state.isHome,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) {
              context.read<MainLayoutCubit>().doEvent(const MainBackPressed());
            }
          },
          child: Scaffold(
            body: widget.navigationShell,
            bottomNavigationBar: AppBottomTabBar(
              semanticLabel: context.tr(TranslationKeys.mainNavigationLabel),
              selectedIndex: state.currentTab.index,
              onSelected: (index) => context.read<MainLayoutCubit>().doEvent(
                MainTabTapped(MainTab.values[index]),
              ),
              items: [
                for (final tab in MainTab.values)
                  AppBottomTabItem(
                    icon: tab.icon,
                    selectedIcon: tab.selectedIcon,
                    label: context.tr(tab.labelKey),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

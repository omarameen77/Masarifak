import 'package:equatable/equatable.dart';

import 'main_tab.dart';

final class MainLayoutState extends Equatable {
  const MainLayoutState({
    this.currentTab = MainTab.home,
    this.rootRequests = 0,
  });

  final MainTab currentTab;
  final int rootRequests;

  bool get isHome => currentTab == MainTab.home;

  MainLayoutState copyWith({MainTab? currentTab, int? rootRequests}) {
    return MainLayoutState(
      currentTab: currentTab ?? this.currentTab,
      rootRequests: rootRequests ?? this.rootRequests,
    );
  }

  @override
  List<Object?> get props => [currentTab, rootRequests];
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'main_layout_intent.dart';
import 'main_layout_state.dart';
import 'main_tab.dart';

@injectable
class MainLayoutCubit extends Cubit<MainLayoutState> {
  MainLayoutCubit() : super(const MainLayoutState());

  void doEvent(MainLayoutIntent intent) {
    switch (intent) {
      case MainTabTapped(:final tab) when tab == state.currentTab:
        emit(state.copyWith(rootRequests: state.rootRequests + 1));
      case MainTabTapped(:final tab):
        emit(state.copyWith(currentTab: tab));
      case MainTabSynced(:final tab):
        if (tab != state.currentTab) emit(state.copyWith(currentTab: tab));
      case MainBackPressed():
        if (!state.isHome) emit(state.copyWith(currentTab: MainTab.home));
    }
  }
}

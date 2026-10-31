import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/features/main_layout/presentation/main_layout_cubit.dart';
import 'package:masarifak/features/main_layout/presentation/main_layout_intent.dart';
import 'package:masarifak/features/main_layout/presentation/main_layout_state.dart';
import 'package:masarifak/features/main_layout/presentation/main_tab.dart';

void main() {
  test('starts on home', () {
    expect(MainLayoutCubit().state, const MainLayoutState());
  });

  blocTest<MainLayoutCubit, MainLayoutState>(
    'tapping another tab selects it',
    build: MainLayoutCubit.new,
    act: (cubit) => cubit.doEvent(const MainTabTapped(MainTab.expenses)),
    expect: () => [const MainLayoutState(currentTab: MainTab.expenses)],
  );

  blocTest<MainLayoutCubit, MainLayoutState>(
    'tapping the current tab asks to go back to its root',
    build: MainLayoutCubit.new,
    seed: () => const MainLayoutState(currentTab: MainTab.obligations),
    act: (cubit) => cubit
      ..doEvent(const MainTabTapped(MainTab.obligations))
      ..doEvent(const MainTabTapped(MainTab.obligations)),
    expect: () => [
      const MainLayoutState(currentTab: MainTab.obligations, rootRequests: 1),
      const MainLayoutState(currentTab: MainTab.obligations, rootRequests: 2),
    ],
  );

  blocTest<MainLayoutCubit, MainLayoutState>(
    'a router change syncs the tab without asking for the root',
    build: MainLayoutCubit.new,
    act: (cubit) => cubit
      ..doEvent(const MainTabSynced(MainTab.home))
      ..doEvent(const MainTabSynced(MainTab.ask)),
    expect: () => [const MainLayoutState(currentTab: MainTab.ask)],
  );

  blocTest<MainLayoutCubit, MainLayoutState>(
    'back from another tab returns to home',
    build: MainLayoutCubit.new,
    seed: () => const MainLayoutState(currentTab: MainTab.ask),
    act: (cubit) => cubit.doEvent(const MainBackPressed()),
    expect: () => [const MainLayoutState()],
  );

  blocTest<MainLayoutCubit, MainLayoutState>(
    'back on home does nothing so the system can close the app',
    build: MainLayoutCubit.new,
    act: (cubit) => cubit.doEvent(const MainBackPressed()),
    expect: () => <MainLayoutState>[],
  );
}

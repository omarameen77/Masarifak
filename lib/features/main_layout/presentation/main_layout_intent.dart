import 'main_tab.dart';

sealed class MainLayoutIntent {
  const MainLayoutIntent();
}

final class MainTabTapped extends MainLayoutIntent {
  const MainTabTapped(this.tab);

  final MainTab tab;
}

final class MainTabSynced extends MainLayoutIntent {
  const MainTabSynced(this.tab);

  final MainTab tab;
}

final class MainBackPressed extends MainLayoutIntent {
  const MainBackPressed();
}

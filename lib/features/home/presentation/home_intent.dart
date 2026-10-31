sealed class HomeIntent {
  const HomeIntent();
}

final class HomeStarted extends HomeIntent {
  const HomeStarted();
}

final class HomeRefreshed extends HomeIntent {
  const HomeRefreshed();
}

final class HomeRetried extends HomeIntent {
  const HomeRetried();
}

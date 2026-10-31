import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_durations.dart';

CustomTransitionPage<void> fadeTransitionPage(
  GoRouterState state,
  Widget child,
) => CustomTransitionPage<void>(
  key: state.pageKey,
  transitionDuration: AppDurations.pageFade,
  reverseTransitionDuration: AppDurations.pageFade,
  transitionsBuilder: (_, animation, _, child) =>
      FadeTransition(opacity: animation, child: child),
  child: child,
);

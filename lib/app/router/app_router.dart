import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_routes.dart';
import '../../core/constants/translation_keys.dart';
import '../../features/auth/presentation/session/session_cubit.dart';
import '../placeholder_screen.dart';
import 'session_redirect.dart';

GoRouter createAppRouter({
  SessionCubit? sessionCubit,
  Listenable? refreshListenable,
}) => GoRouter(
  initialLocation: AppRoutes.initialLocation,
  refreshListenable: refreshListenable,
  redirect: sessionCubit == null
      ? null
      : (_, state) =>
            sessionRedirect(sessionCubit.state, state.matchedLocation),
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (_, _) =>
          const PlaceholderScreen(titleKey: TranslationKeys.loginTitle),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (_, _) =>
          const PlaceholderScreen(titleKey: TranslationKeys.onboardingTitle),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (_, _) => const PlaceholderScreen(
        titleKey: TranslationKeys.homeTitle,
        showHomeActions: true,
      ),
    ),
  ],
);

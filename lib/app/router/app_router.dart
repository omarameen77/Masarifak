import 'package:go_router/go_router.dart';

import '../../core/constants/app_routes.dart';
import '../../core/constants/translation_keys.dart';
import '../placeholder_screen.dart';

GoRouter createAppRouter() => GoRouter(
  initialLocation: AppRoutes.initialLocation,
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

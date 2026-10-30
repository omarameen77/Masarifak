import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_routes.dart';
import '../../core/constants/translation_keys.dart';
import '../../core/di/injection.dart';
import '../../core/router/stream_listenable.dart';
import '../../features/auth/presentation/login/login_cubit.dart';
import '../../features/auth/presentation/login/login_screen.dart';
import '../../features/auth/presentation/session/session_cubit.dart';
import '../placeholder_screen.dart';
import 'session_redirect.dart';

GoRouter createAppRouter({
  SessionCubit? sessionCubit,
  Listenable? refreshListenable,
}) {
  final session = sessionCubit ?? getIt<SessionCubit>();
  return GoRouter(
    initialLocation: AppRoutes.initialLocation,
    refreshListenable: refreshListenable ?? StreamListenable(session.stream),
    redirect: (_, state) => sessionRedirect(session.state, state.matchedLocation),
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (_, _) => BlocProvider<LoginCubit>(
          create: (_) => getIt<LoginCubit>(),
          child: const LoginScreen(),
        ),
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
}

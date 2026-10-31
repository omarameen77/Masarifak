import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_routes.dart';
import '../../core/constants/translation_keys.dart';
import '../../core/di/injection.dart';
import '../../core/router/stream_listenable.dart';
import '../../features/auth/presentation/login/login_cubit.dart';
import '../../features/auth/presentation/login/login_screen.dart';
import '../../features/auth/presentation/register/register_cubit.dart';
import '../../features/auth/presentation/register/register_screen.dart';
import '../../features/auth/presentation/session/session_cubit.dart';
import '../../features/onboarding/presentation/onboarding_cubit.dart';
import '../../features/onboarding/presentation/onboarding_intent.dart';
import '../../features/home/presentation/home_cubit.dart';
import '../../features/home/presentation/home_intent.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/main_layout/presentation/main_layout_cubit.dart';
import '../../features/main_layout/presentation/main_layout_screen.dart';
import '../../features/main_layout/presentation/main_tab.dart';
import '../../features/onboarding/presentation/income/onboarding_income_screen.dart';
import '../../features/onboarding/presentation/obligations/onboarding_obligations_screen.dart';
import '../../features/onboarding/presentation/onboarding_shell.dart';
import '../../features/onboarding/presentation/safety/onboarding_safety_screen.dart';
import '../../features/onboarding/presentation/summary/onboarding_summary_screen.dart';
import '../placeholder_screen.dart';
import 'fade_transition_page.dart';
import 'session_redirect.dart';
import 'slide_transition_page.dart';

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
        pageBuilder: (_, state) => SlideTransitionPage(
          key: state.pageKey,
          child: BlocProvider<LoginCubit>(
            create: (_) => getIt<LoginCubit>(),
            child: const LoginScreen(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        pageBuilder: (_, state) => SlideTransitionPage(
          key: state.pageKey,
          child: BlocProvider<RegisterCubit>(
            create: (_) => getIt<RegisterCubit>(),
            child: const RegisterScreen(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (_, _) => const PlaceholderScreen(
          titleKey: TranslationKeys.loginForgotPassword,
        ),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        redirect: (_, _) => AppRoutes.onboardingIncome,
      ),
      ShellRoute(
        pageBuilder: (_, state, child) => fadeTransitionPage(
          state,
          BlocProvider<OnboardingCubit>(
            create: (_) =>
                getIt<OnboardingCubit>()..doEvent(const OnboardingStarted()),
            child: OnboardingShell(
              step: _onboardingStepNumber(state.uri.path),
              totalSteps: AppRoutes.onboardingSteps.length,
              child: child,
            ),
          ),
        ),
        routes: [
          _onboardingStep(
            AppRoutes.onboardingIncome,
            (step, total) =>
                OnboardingIncomeScreen(step: step, totalSteps: total),
          ),
          _onboardingStep(
            AppRoutes.onboardingObligations,
            (step, total) =>
                OnboardingObligationsScreen(step: step, totalSteps: total),
          ),
          _onboardingStep(
            AppRoutes.onboardingSafety,
            (step, total) =>
                OnboardingSafetyScreen(step: step, totalSteps: total),
          ),
          _onboardingStep(
            AppRoutes.onboardingSummary,
            (step, total) =>
                OnboardingSummaryScreen(step: step, totalSteps: total),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        pageBuilder: (_, state, navigationShell) => fadeTransitionPage(
          state,
          BlocProvider<MainLayoutCubit>(
            create: (_) => getIt<MainLayoutCubit>(),
            child: MainLayoutScreen(navigationShell: navigationShell),
          ),
        ),
        branches: [
          for (final tab in MainTab.values)
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: tab.route,
                  pageBuilder: (_, state) => NoTransitionPage<void>(
                    key: state.pageKey,
                    child: _tabRoot(tab),
                  ),
                ),
              ],
            ),
        ],
      ),
    ],
  );
}

Widget _tabRoot(MainTab tab) => switch (tab) {
  MainTab.home => BlocProvider<HomeCubit>(
    create: (_) => getIt<HomeCubit>()..doEvent(const HomeStarted()),
    child: const HomeScreen(),
  ),
  MainTab.expenses => const PlaceholderScreen(
    titleKey: TranslationKeys.expensesTitle,
  ),
  MainTab.obligations => const PlaceholderScreen(
    titleKey: TranslationKeys.obligationsTitle,
  ),
  MainTab.ask => const PlaceholderScreen(titleKey: TranslationKeys.askTitle),
};

int _onboardingStepNumber(String path) =>
    AppRoutes.onboardingSteps.indexOf(path) + 1;

GoRoute _onboardingStep(
  String path,
  Widget Function(int step, int totalSteps) builder,
) => GoRoute(
  path: path,
  pageBuilder: (_, state) => SlideTransitionPage(
    key: state.pageKey,
    child: builder(
      _onboardingStepNumber(path),
      AppRoutes.onboardingSteps.length,
    ),
  ),
);

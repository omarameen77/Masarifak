import '../../core/constants/app_routes.dart';
import '../../features/auth/presentation/session/session_state.dart';

String? sessionRedirect(SessionState state, String currentLocation) =>
    switch (state) {
      SessionUnknown() => null,
      SessionSignedOut() =>
        currentLocation == AppRoutes.login ? null : AppRoutes.login,
      SessionNeedsOnboarding() =>
        currentLocation == AppRoutes.onboarding ? null : AppRoutes.onboarding,
      SessionSignedIn() =>
        currentLocation == AppRoutes.login ||
                currentLocation == AppRoutes.onboarding
            ? AppRoutes.home
            : null,
    };

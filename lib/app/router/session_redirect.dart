import '../../core/constants/app_routes.dart';
import '../../features/auth/presentation/session/session_state.dart';

String? sessionRedirect(SessionState state, String currentLocation) =>
    switch (state) {
      SessionUnknown() => null,
      SessionSignedOut() =>
        AppRoutes.signedOutRoutes.contains(currentLocation)
            ? null
            : AppRoutes.login,
      SessionNeedsOnboarding() =>
        AppRoutes.onboardingRoutes.contains(currentLocation)
            ? null
            : AppRoutes.onboarding,
      SessionSignedIn() =>
        AppRoutes.signedOutRoutes.contains(currentLocation) ||
                AppRoutes.onboardingRoutes.contains(currentLocation)
            ? AppRoutes.home
            : null,
    };

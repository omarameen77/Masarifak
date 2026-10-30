import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/app/router/session_redirect.dart';
import 'package:masarifak/core/constants/app_routes.dart';
import 'package:masarifak/features/auth/domain/entities/feature_flags.dart';
import 'package:masarifak/features/auth/presentation/session/session_state.dart';

void main() {
  const signedIn = SessionSignedIn(FeatureFlags.empty());
  const locations = [AppRoutes.login, AppRoutes.onboarding, AppRoutes.home];

  final expected = <SessionState, Map<String, String?>>{
    const SessionUnknown(): {
      AppRoutes.login: null,
      AppRoutes.onboarding: null,
      AppRoutes.home: null,
    },
    const SessionSignedOut(): {
      AppRoutes.login: null,
      AppRoutes.onboarding: AppRoutes.login,
      AppRoutes.home: AppRoutes.login,
    },
    const SessionNeedsOnboarding(): {
      AppRoutes.login: AppRoutes.onboarding,
      AppRoutes.onboarding: null,
      AppRoutes.home: AppRoutes.onboarding,
    },
    signedIn: {
      AppRoutes.login: AppRoutes.home,
      AppRoutes.onboarding: AppRoutes.home,
      AppRoutes.home: null,
    },
  };

  for (final location in [AppRoutes.register, AppRoutes.forgotPassword]) {
    test('SessionSignedOut stays at $location', () {
      expect(sessionRedirect(const SessionSignedOut(), location), isNull);
    });

    test('SessionSignedIn at $location redirects to home', () {
      expect(sessionRedirect(signedIn, location), AppRoutes.home);
    });
  }

  for (final step in AppRoutes.onboardingSteps) {
    test('SessionNeedsOnboarding stays on $step', () {
      expect(sessionRedirect(const SessionNeedsOnboarding(), step), isNull);
    });

    test('SessionSignedIn on $step redirects to home', () {
      expect(sessionRedirect(signedIn, step), AppRoutes.home);
    });

    test('SessionSignedOut on $step redirects to login', () {
      expect(sessionRedirect(const SessionSignedOut(), step), AppRoutes.login);
    });
  }

  for (final MapEntry(key: state, value: targets) in expected.entries) {
    for (final location in locations) {
      test('${state.runtimeType} at $location redirects to ${targets[location]}', () {
        expect(sessionRedirect(state, location), targets[location]);
      });
    }
  }
}

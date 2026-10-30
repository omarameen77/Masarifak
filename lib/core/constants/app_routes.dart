abstract final class AppRoutes {
  static const String login = '/login';
  static const String onboarding = '/onboarding';
  static const String onboardingIncome = '/onboarding/income';
  static const String onboardingObligations = '/onboarding/obligations';
  static const String onboardingSafety = '/onboarding/safety';
  static const String onboardingSummary = '/onboarding/summary';
  static const String home = '/home';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String initialLocation = login;
  static const Set<String> signedOutRoutes = {login, register, forgotPassword};
  static const Set<String> onboardingRoutes = {
    onboarding,
    onboardingIncome,
    onboardingObligations,
    onboardingSafety,
    onboardingSummary,
  };
  static const List<String> onboardingSteps = [
    onboardingIncome,
    onboardingObligations,
    onboardingSafety,
    onboardingSummary,
  ];
}

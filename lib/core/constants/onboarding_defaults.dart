abstract final class OnboardingDefaults {
  static const String currencyCode = 'EGP';
  static const String currencySymbol = 'ج.م';
  static const int currencyExponent = 2;
  static const List<int> paydayPresets = [1, 15, 25, 28];
  static const int weekStart = 6;
  static const String timezone = 'Africa/Cairo';
  static const int savingsOpeningBalanceMinor = 0;
  static const String localObligationIdPrefix = 'local-';
  static const int defaultPayday = 1;
  static const List<int> periodicIntervals = [3, 6, 12];
  static const int defaultEveryMonths = 12;
  static const int upcomingCycleCount = 12;
  static const double suggestedSafetyFraction = 0.2;
  static const int safetyRoundingMajor = 100;
}

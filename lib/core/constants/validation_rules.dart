abstract final class ValidationRules {
  static const int passwordMinLength = 8;
  static const int passwordMaxLength = 128;
  static const int passwordStrongLength = 14;
  static const int dayOfMonthMin = 1;
  static const int dayOfMonthMax = 31;
  static const String emailPattern = r'^[^\s@]+@[^\s@]+\.[^\s@]+$';
  static const String uppercasePattern = '[A-Z]';
  static const String lowercasePattern = '[a-z]';
  static const String digitPattern = r'\d';
  static const String symbolPattern = '[^A-Za-z0-9]';
}

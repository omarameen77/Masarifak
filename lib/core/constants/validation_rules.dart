abstract final class ValidationRules {
  static const int passwordMinLength = 8;
  static const int passwordMaxLength = 128;
  static const String emailPattern = r'^[^\s@]+@[^\s@]+\.[^\s@]+$';
}

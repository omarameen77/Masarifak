abstract final class LocalHomeFixtures {
  static const int payday = 25;
  static const int spendableMinor = 350000;
  static const int spentMinor = 25000;
  static const int reservedMinor = 495000;
  static const int savingsMinor = 100000;
  static const int safetyBalanceMinor = 100000;
  static const int unreadNotifications = 3;
  static const String paceNote = 'ماشي على خطتك. متوسطك ٤٣ ج.م في اليوم والخطة ٨٢ ج.م.';
  static const int savingsBalanceMinor = 3050000;
  static const int savingsMonthlyMinor = 100000;
  static const String goalName = 'عربية';
  static const int goalBalanceMinor = 1800000;
  static const int goalTargetMinor = 5000000;
  static const List<(String, String, int, int)> obligations = [
    ('ob-1', 'الإيجار', 300000, 2),
    ('ob-2', 'النت', 45000, 6),
    ('ob-3', 'الكهربا', 50000, 11),
  ];
  static const List<(String, String, String, String, int, int)> expenses = [
    ('ex-1', 'كوستا', 'food', 'أكل', 9500, 0),
    ('ex-2', 'كارفور', 'grocery', 'بقالة', 8000, 1),
    ('ex-3', 'أوبر', 'transport', 'مواصلات', 4500, 2),
    ('ex-4', 'صيدلية العزبي', 'health', 'صحة', 3000, 3),
  ];
}

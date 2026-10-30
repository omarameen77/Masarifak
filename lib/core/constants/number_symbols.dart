abstract final class NumberSymbols {
  static const int base = 10;
  static const String minus = '−';
  static const String space = ' ';
  static const String decimal = '.';
  static const String approx = '~';
  static const String plainPattern = '0';
  static const String arabicDecimal = '٫';
  static const int asciiZero = 0x30;
  static const int arabicZero = 0x0660;
  static const int arabicNine = 0x0669;
  static const int persianZero = 0x06F0;
  static const int persianNine = 0x06F9;
  static final RegExp groupingPattern = RegExp('[٬,\\s]');
  static final RegExp decimalPattern = RegExp(r'^\d+(\.\d+)?$');
  static final RegExp amountInputPattern = RegExp(r'^\d*\.?\d*$');
  static final RegExp digitsInputPattern = RegExp(r'^\d*$');
}

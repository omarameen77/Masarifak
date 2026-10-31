abstract final class ApiDate {
  static DateTime parse(String value) {
    final date = DateTime.parse(value);
    return DateTime.utc(date.year, date.month, date.day);
  }

  static DateTime? tryParse(String? value) {
    if (value == null) return null;
    final date = DateTime.tryParse(value);
    return date == null ? null : DateTime.utc(date.year, date.month, date.day);
  }
}

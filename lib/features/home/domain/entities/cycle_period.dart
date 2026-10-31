import 'package:equatable/equatable.dart';

class CyclePeriod extends Equatable {
  const CyclePeriod({required this.start, required this.end, required this.days});

  final DateTime start;
  final DateTime end;
  final int days;

  DateTime get nextPayday => DateTime.utc(end.year, end.month, end.day + 1);

  int daysLeft(DateTime today) =>
      end.difference(_dateOnly(today)).inDays + 1;

  int dayNumber(DateTime today) =>
      _dateOnly(today).difference(start).inDays + 1;

  static DateTime _dateOnly(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day);

  @override
  List<Object?> get props => [start, end, days];
}

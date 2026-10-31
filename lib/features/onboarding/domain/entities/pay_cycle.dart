import 'package:equatable/equatable.dart';

class PayCycle extends Equatable {
  const PayCycle({
    required this.start,
    required this.end,
    required this.next,
    required this.days,
  });

  final DateTime start;
  final DateTime end;
  final DateTime next;
  final int days;

  @override
  List<Object?> get props => [start, end, next, days];
}

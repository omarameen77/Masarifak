import 'package:equatable/equatable.dart';

enum UpcomingObligationKind { fixed, variable, periodic, debt }

enum ObligationDisplayStatus {
  reserved,
  dueSoon,
  late,
  awaitingBill,
  collecting,
  paid,
  skipped,
  stopped,
  arrears,
}

class UpcomingObligation extends Equatable {
  const UpcomingObligation({
    required this.id,
    required this.name,
    required this.kind,
    required this.amountMinor,
    required this.isEstimate,
    required this.dueOn,
    required this.daysUntilDue,
    required this.status,
  });

  final String id;
  final String name;
  final UpcomingObligationKind kind;
  final int amountMinor;
  final bool isEstimate;
  final DateTime dueOn;
  final int daysUntilDue;
  final ObligationDisplayStatus status;

  @override
  List<Object?> get props => [
    id,
    name,
    kind,
    amountMinor,
    isEstimate,
    dueOn,
    daysUntilDue,
    status,
  ];
}

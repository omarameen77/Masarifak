import 'package:equatable/equatable.dart';

import 'obligation_category.dart';
import 'obligation_kind.dart';

class ObligationDraft extends Equatable {
  const ObligationDraft({
    required this.clientId,
    required this.name,
    required this.kind,
    required this.category,
    required this.amountMinor,
    required this.dueDay,
    this.everyMonths,
    this.nextDueOn,
  });

  final String clientId;
  final String name;
  final ObligationKind kind;
  final ObligationCategory category;
  final int amountMinor;
  final int dueDay;
  final int? everyMonths;
  final DateTime? nextDueOn;

  ObligationDraft copyWith({String? clientId}) => ObligationDraft(
    clientId: clientId ?? this.clientId,
    name: name,
    kind: kind,
    category: category,
    amountMinor: amountMinor,
    dueDay: dueDay,
    everyMonths: everyMonths,
    nextDueOn: nextDueOn,
  );

  int get monthlyShareMinor => switch (kind) {
    ObligationKind.periodic => (amountMinor / (everyMonths ?? 1)).round(),
    ObligationKind.fixed || ObligationKind.variable => amountMinor,
  };

  @override
  List<Object?> get props => [
    clientId,
    name,
    kind,
    category,
    amountMinor,
    dueDay,
    everyMonths,
    nextDueOn,
  ];
}

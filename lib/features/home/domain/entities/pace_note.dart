import 'package:equatable/equatable.dart';

import 'cycle_status.dart';

class PaceNote extends Equatable {
  const PaceNote({required this.tone, required this.text});

  final CycleStatus tone;
  final String text;

  @override
  List<Object?> get props => [tone, text];
}

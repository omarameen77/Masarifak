import 'package:json_annotation/json_annotation.dart';

import '../../../../core/constants/api_home_values.dart';
import '../../../../core/constants/api_onboarding_values.dart';
import '../../../../core/network/api_date.dart';
import '../../domain/entities/upcoming_obligation.dart';

part 'obligations_page_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class ObligationsPageDto {
  const ObligationsPageDto({this.sections = const []});

  factory ObligationsPageDto.fromJson(Map<String, dynamic> json) =>
      _$ObligationsPageDtoFromJson(json);

  final List<ObligationSectionDto> sections;

  List<UpcomingObligation> toDomain(int limit) {
    final items = [
      for (final section in sections)
        for (final item in section.items) item.toDomain(),
    ]..sort((a, b) => a.dueOn.compareTo(b.dueOn));
    return items.take(limit).toList();
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class ObligationSectionDto {
  const ObligationSectionDto({required this.key, this.items = const []});

  factory ObligationSectionDto.fromJson(Map<String, dynamic> json) =>
      _$ObligationSectionDtoFromJson(json);

  final String key;
  final List<ObligationItemDto> items;
}

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class ObligationItemDto {
  const ObligationItemDto({
    required this.id,
    required this.name,
    required this.kind,
    required this.amountMinor,
    required this.dueOn,
    required this.daysUntilDue,
    required this.displayStatus,
    this.actualMinor,
    this.isEstimate = false,
  });

  factory ObligationItemDto.fromJson(Map<String, dynamic> json) =>
      _$ObligationItemDtoFromJson(json);

  final String id;
  final String name;
  final String kind;
  final int amountMinor;
  final int? actualMinor;
  final bool isEstimate;
  final String dueOn;
  final int daysUntilDue;
  final String displayStatus;

  UpcomingObligation toDomain() => UpcomingObligation(
    id: id,
    name: name,
    kind: switch (kind) {
      ApiOnboardingValues.kindVariable => UpcomingObligationKind.variable,
      ApiOnboardingValues.kindPeriodic => UpcomingObligationKind.periodic,
      ApiHomeValues.kindDebt => UpcomingObligationKind.debt,
      _ => UpcomingObligationKind.fixed,
    },
    amountMinor: actualMinor ?? amountMinor,
    isEstimate: isEstimate,
    dueOn: ApiDate.parse(dueOn),
    daysUntilDue: daysUntilDue,
    status: switch (displayStatus) {
      ApiHomeValues.statusDueSoon => ObligationDisplayStatus.dueSoon,
      ApiHomeValues.statusLate => ObligationDisplayStatus.late,
      ApiHomeValues.statusAwaitingBill => ObligationDisplayStatus.awaitingBill,
      ApiHomeValues.statusCollecting => ObligationDisplayStatus.collecting,
      ApiHomeValues.statusPaid => ObligationDisplayStatus.paid,
      ApiHomeValues.statusSkipped => ObligationDisplayStatus.skipped,
      ApiHomeValues.statusStopped => ObligationDisplayStatus.stopped,
      ApiHomeValues.statusArrears => ObligationDisplayStatus.arrears,
      _ => ObligationDisplayStatus.reserved,
    },
  );
}

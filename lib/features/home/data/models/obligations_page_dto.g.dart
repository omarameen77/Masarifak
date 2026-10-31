// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'obligations_page_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObligationsPageDto _$ObligationsPageDtoFromJson(Map<String, dynamic> json) =>
    ObligationsPageDto(
      sections:
          (json['sections'] as List<dynamic>?)
              ?.map(
                (e) => ObligationSectionDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

ObligationSectionDto _$ObligationSectionDtoFromJson(
  Map<String, dynamic> json,
) => ObligationSectionDto(
  key: json['key'] as String,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => ObligationItemDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

ObligationItemDto _$ObligationItemDtoFromJson(Map<String, dynamic> json) =>
    ObligationItemDto(
      id: json['id'] as String,
      name: json['name'] as String,
      kind: json['kind'] as String,
      amountMinor: (json['amount_minor'] as num).toInt(),
      dueOn: json['due_on'] as String,
      daysUntilDue: (json['days_until_due'] as num).toInt(),
      displayStatus: json['display_status'] as String,
      actualMinor: (json['actual_minor'] as num?)?.toInt(),
      isEstimate: json['is_estimate'] as bool? ?? false,
    );

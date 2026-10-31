// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_flags_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeatureFlagsDto _$FeatureFlagsDtoFromJson(Map<String, dynamic> json) =>
    FeatureFlagsDto(
      version: (json['version'] as num?)?.toInt(),
      features: json['features'] as Map<String, dynamic>? ?? const {},
    );

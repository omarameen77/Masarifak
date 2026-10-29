import 'package:json_annotation/json_annotation.dart';

import '../../../../core/constants/api_json_keys.dart';
import '../../domain/entities/feature_flags.dart';

part 'feature_flags_dto.g.dart';

@JsonSerializable(createToJson: false)
class FeatureFlagsDto {
  const FeatureFlagsDto({this.version, this.features = const {}});

  factory FeatureFlagsDto.fromJson(Map<String, dynamic> json) =>
      _$FeatureFlagsDtoFromJson(json);

  final int? version;
  final Map<String, dynamic> features;

  FeatureFlags toDomain() => FeatureFlags({
    for (final MapEntry(:key, :value) in features.entries)
      key: value is Map<String, dynamic> && value[ApiJsonKeys.enabled] == true,
  });
}

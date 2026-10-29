import 'package:json_annotation/json_annotation.dart';

part 'profile_dto.g.dart';

@JsonSerializable(createToJson: false)
class ProfileDto {
  const ProfileDto({required this.onboarded});

  factory ProfileDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDtoFromJson(json);

  final bool onboarded;

  bool toDomain() => onboarded;
}

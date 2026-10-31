import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/home_profile.dart';

part 'home_profile_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class HomeProfileDto {
  const HomeProfileDto({
    this.unreadNotifications = 0,
    this.hasPendingReview = false,
  });

  factory HomeProfileDto.fromJson(Map<String, dynamic> json) =>
      _$HomeProfileDtoFromJson(json);

  final int unreadNotifications;
  final bool hasPendingReview;

  HomeProfile toDomain() => HomeProfile(
    unreadNotifications: unreadNotifications,
    hasPendingReview: hasPendingReview,
  );
}

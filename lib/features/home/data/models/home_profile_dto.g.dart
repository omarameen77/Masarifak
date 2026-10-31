// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeProfileDto _$HomeProfileDtoFromJson(Map<String, dynamic> json) =>
    HomeProfileDto(
      unreadNotifications: (json['unread_notifications'] as num?)?.toInt() ?? 0,
      hasPendingReview: json['has_pending_review'] as bool? ?? false,
    );

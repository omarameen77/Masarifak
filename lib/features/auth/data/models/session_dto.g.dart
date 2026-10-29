// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionDto _$SessionDtoFromJson(Map<String, dynamic> json) => SessionDto(
  accessToken: json['access_token'] as String,
  refreshToken: json['refresh_token'] as String,
  expiresIn: (json['expires_in'] as num).toInt(),
  user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
  features: FeatureFlagsDto.fromJson(json['features'] as Map<String, dynamic>),
);

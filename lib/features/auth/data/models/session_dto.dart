import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/entities/login_outcome.dart';
import 'feature_flags_dto.dart';
import 'user_dto.dart';

part 'session_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class SessionDto {
  const SessionDto({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.user,
    required this.features,
  });

  factory SessionDto.fromJson(Map<String, dynamic> json) =>
      _$SessionDtoFromJson(json);

  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final UserDto user;
  final FeatureFlagsDto features;

  LoginOutcome toDomain() => LoginOutcome(
    session: AuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresInSeconds: expiresIn,
      user: user.toDomain(),
    ),
    flags: features.toDomain(),
  );
}

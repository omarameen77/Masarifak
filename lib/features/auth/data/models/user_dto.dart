import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/auth_user.dart';

part 'user_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class UserDto {
  const UserDto({
    required this.id,
    required this.name,
    this.email,
    required this.emailVerified,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

  final String id;
  final String name;
  final String? email;
  final bool emailVerified;

  AuthUser toDomain() =>
      AuthUser(id: id, name: name, email: email, emailVerified: emailVerified);
}

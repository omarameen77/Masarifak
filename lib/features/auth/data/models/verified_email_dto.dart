import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/verified_email.dart';

part 'verified_email_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class VerifiedEmailDto {
  const VerifiedEmailDto({required this.email, required this.emailVerified});

  factory VerifiedEmailDto.fromJson(Map<String, dynamic> json) =>
      _$VerifiedEmailDtoFromJson(json);

  final String email;
  final bool emailVerified;

  VerifiedEmail toDomain() =>
      VerifiedEmail(email: email, emailVerified: emailVerified);
}

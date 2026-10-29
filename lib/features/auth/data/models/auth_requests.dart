import 'package:json_annotation/json_annotation.dart';

part 'auth_requests.g.dart';

@JsonSerializable(createFactory: false)
class LoginRequest {
  const LoginRequest({required this.email, required this.password});

  final String email;
  final String password;

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable(createFactory: false)
class RegisterRequest {
  const RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.locale,
    required this.digits,
  });

  final String name;
  final String email;
  final String password;
  final String locale;
  final String digits;

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, createFactory: false)
class RestoreAccountRequest {
  const RestoreAccountRequest({required this.restoreToken});

  final String restoreToken;

  Map<String, dynamic> toJson() => _$RestoreAccountRequestToJson(this);
}

@JsonSerializable(createFactory: false)
class ForgotPasswordRequest {
  const ForgotPasswordRequest({required this.email});

  final String email;

  Map<String, dynamic> toJson() => _$ForgotPasswordRequestToJson(this);
}

@JsonSerializable(createFactory: false)
class ResetPasswordRequest {
  const ResetPasswordRequest({required this.token, required this.password});

  final String token;
  final String password;

  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);
}

@JsonSerializable(createFactory: false)
class VerifyEmailRequest {
  const VerifyEmailRequest({required this.token});

  final String token;

  Map<String, dynamic> toJson() => _$VerifyEmailRequestToJson(this);
}

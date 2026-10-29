// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'locale': instance.locale,
      'digits': instance.digits,
    };

Map<String, dynamic> _$RestoreAccountRequestToJson(
  RestoreAccountRequest instance,
) => <String, dynamic>{'restore_token': instance.restoreToken};

Map<String, dynamic> _$ForgotPasswordRequestToJson(
  ForgotPasswordRequest instance,
) => <String, dynamic>{'email': instance.email};

Map<String, dynamic> _$ResetPasswordRequestToJson(
  ResetPasswordRequest instance,
) => <String, dynamic>{'token': instance.token, 'password': instance.password};

Map<String, dynamic> _$VerifyEmailRequestToJson(VerifyEmailRequest instance) =>
    <String, dynamic>{'token': instance.token};

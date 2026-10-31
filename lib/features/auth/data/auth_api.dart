import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/constants/di_names.dart';
import '../../../core/network/data_envelope.dart';
import 'models/auth_requests.dart';
import 'models/session_dto.dart';
import 'models/verified_email_dto.dart';

part 'auth_api.g.dart';

@lazySingleton
@RestApi()
abstract class AuthApi {
  @factoryMethod
  factory AuthApi(@Named(DiNames.authDio) Dio dio) = _AuthApi;

  @POST(ApiPaths.login)
  Future<DataEnvelope<SessionDto>> login(@Body() LoginRequest request);

  @POST(ApiPaths.register)
  Future<DataEnvelope<SessionDto>> register(@Body() RegisterRequest request);

  @POST(ApiPaths.accountRestore)
  Future<DataEnvelope<SessionDto>> restore(@Body() RestoreAccountRequest request);

  @POST(ApiPaths.passwordForgot)
  Future<HttpResponse<void>> forgotPassword(@Body() ForgotPasswordRequest request);

  @POST(ApiPaths.passwordReset)
  Future<DataEnvelope<SessionDto>> resetPassword(@Body() ResetPasswordRequest request);

  @POST(ApiPaths.emailVerify)
  Future<DataEnvelope<VerifiedEmailDto>> verifyEmail(@Body() VerifyEmailRequest request);

  @POST(ApiPaths.emailResend)
  Future<HttpResponse<void>> resendVerification();
}

import 'package:injectable/injectable.dart';

import 'auth_api.dart';
import 'models/auth_requests.dart';
import 'models/profile_dto.dart';
import 'models/session_dto.dart';
import 'models/verified_email_dto.dart';
import 'profile_api.dart';

abstract interface class AuthRemoteDataSource {
  Future<SessionDto> login({required String email, required String password});

  Future<SessionDto> restoreAccount({required String restoreToken});

  Future<SessionDto> register({
    required String name,
    required String email,
    required String password,
    required String locale,
    required String digits,
  });

  Future<void> requestPasswordReset({required String email});

  Future<SessionDto> resetPassword({
    required String token,
    required String password,
  });

  Future<VerifiedEmailDto> verifyEmail({required String token});

  Future<void> resendVerification();

  Future<ProfileDto> getProfile();
}

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(AuthApi authApi, ProfileApi profileApi)
    : _authApi = authApi,
      _profileApi = profileApi;

  final AuthApi _authApi;
  final ProfileApi _profileApi;

  @override
  Future<SessionDto> login({
    required String email,
    required String password,
  }) async =>
      (await _authApi.login(LoginRequest(email: email, password: password))).data;

  @override
  Future<SessionDto> restoreAccount({required String restoreToken}) async =>
      (await _authApi.restore(RestoreAccountRequest(restoreToken: restoreToken)))
          .data;

  @override
  Future<SessionDto> register({
    required String name,
    required String email,
    required String password,
    required String locale,
    required String digits,
  }) async => (await _authApi.register(
    RegisterRequest(
      name: name,
      email: email,
      password: password,
      locale: locale,
      digits: digits,
    ),
  )).data;

  @override
  Future<void> requestPasswordReset({required String email}) =>
      _authApi.forgotPassword(ForgotPasswordRequest(email: email));

  @override
  Future<SessionDto> resetPassword({
    required String token,
    required String password,
  }) async => (await _authApi.resetPassword(
    ResetPasswordRequest(token: token, password: password),
  )).data;

  @override
  Future<VerifiedEmailDto> verifyEmail({required String token}) async =>
      (await _authApi.verifyEmail(VerifyEmailRequest(token: token))).data;

  @override
  Future<void> resendVerification() => _authApi.resendVerification();

  @override
  Future<ProfileDto> getProfile() async => (await _profileApi.getProfile()).data;
}

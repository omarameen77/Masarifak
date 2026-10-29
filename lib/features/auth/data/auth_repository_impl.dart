import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../core/error/error_mapper.dart';
import '../../../core/error/failure.dart';
import '../../../core/result/result.dart';
import '../../../core/storage/token_storage.dart';
import '../domain/entities/login_outcome.dart';
import '../domain/entities/verified_email.dart';
import '../domain/repositories/auth_repository.dart';
import 'auth_remote_data_source.dart';
import 'models/session_dto.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(AuthRemoteDataSource remote, TokenStorage tokenStorage)
    : _remote = remote,
      _tokenStorage = tokenStorage;

  final AuthRemoteDataSource _remote;
  final TokenStorage _tokenStorage;

  @override
  Future<Result<LoginOutcome>> login({
    required String email,
    required String password,
  }) => _authenticate(() => _remote.login(email: email, password: password));

  @override
  Future<Result<LoginOutcome>> restoreAccount({required String restoreToken}) =>
      _authenticate(() => _remote.restoreAccount(restoreToken: restoreToken));

  @override
  Future<Result<LoginOutcome>> register({
    required String name,
    required String email,
    required String password,
    required String locale,
    required String digits,
  }) => _authenticate(
    () => _remote.register(
      name: name,
      email: email,
      password: password,
      locale: locale,
      digits: digits,
    ),
  );

  @override
  Future<Result<void>> requestPasswordReset({required String email}) =>
      _guard(() => _remote.requestPasswordReset(email: email));

  @override
  Future<Result<LoginOutcome>> resetPassword({
    required String token,
    required String password,
  }) => _authenticate(
    () => _remote.resetPassword(token: token, password: password),
  );

  @override
  Future<Result<VerifiedEmail>> verifyEmail({required String token}) =>
      _guard(() async => (await _remote.verifyEmail(token: token)).toDomain());

  @override
  Future<Result<void>> resendVerification() =>
      _guard(_remote.resendVerification);

  @override
  Future<Result<bool>> isOnboarded() =>
      _guard(() async => (await _remote.getProfile()).toDomain());

  @override
  Future<void> clearSession() => _tokenStorage.clear();

  Future<Result<LoginOutcome>> _authenticate(
    Future<SessionDto> Function() request,
  ) => _guard(() async {
    final outcome = (await request()).toDomain();
    await _tokenStorage.saveSession(
      accessToken: outcome.session.accessToken,
      refreshToken: outcome.session.refreshToken,
    );
    return outcome;
  });

  Future<Result<T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Success(await action());
    } on DioException catch (error) {
      return Error(mapDioError(error));
    } catch (error) {
      if (kDebugMode) debugPrint('${error.runtimeType}');
      return Error<T>(const UnknownFailure());
    }
  }
}

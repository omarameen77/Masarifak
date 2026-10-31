import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/constants/api_config.dart';
import 'package:masarifak/core/error/failure.dart';
import 'package:masarifak/core/result/result.dart';
import 'package:masarifak/core/storage/token_storage.dart';
import 'package:masarifak/features/auth/data/auth_api.dart';
import 'package:masarifak/features/auth/data/auth_remote_data_source.dart';
import 'package:masarifak/features/auth/data/auth_repository_impl.dart';
import 'package:masarifak/features/auth/data/models/feature_flags_dto.dart';
import 'package:masarifak/features/auth/data/models/profile_dto.dart';
import 'package:masarifak/features/auth/data/models/session_dto.dart';
import 'package:masarifak/features/auth/data/models/user_dto.dart';
import 'package:masarifak/features/auth/data/profile_api.dart';
import 'package:masarifak/features/auth/domain/entities/login_outcome.dart';
import 'package:mocktail/mocktail.dart';

class MockRemote extends Mock implements AuthRemoteDataSource {}

class MockTokenStorage extends Mock implements TokenStorage {}

class JsonBodyAdapter implements HttpClientAdapter {
  JsonBodyAdapter(this.body);

  final String body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString(
    body,
    HttpStatus.ok,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );

  @override
  void close({bool force = false}) {}
}

void main() {
  const email = 'ahmed@example.com';
  const password = 'test-password-1';
  const accessToken = 'access-token';
  const refreshToken = 'refresh-token';
  const sessionDto = SessionDto(
    accessToken: accessToken,
    refreshToken: refreshToken,
    expiresIn: 900,
    user: UserDto(id: 'user-id', name: 'Test User', emailVerified: true),
    features: FeatureFlagsDto(features: {'ask': {'enabled': true}}),
  );

  late MockRemote remote;
  late MockTokenStorage tokenStorage;
  late AuthRepositoryImpl repository;

  DioException httpError(int status) {
    final request = RequestOptions();
    return DioException(
      requestOptions: request,
      type: DioExceptionType.badResponse,
      response: Response<Object?>(requestOptions: request, statusCode: status),
    );
  }

  void stubSave(Future<void> Function() answer) => when(
    () => tokenStorage.saveSession(
      accessToken: any(named: 'accessToken'),
      refreshToken: any(named: 'refreshToken'),
    ),
  ).thenAnswer((_) => answer());

  setUp(() {
    remote = MockRemote();
    tokenStorage = MockTokenStorage();
    repository = AuthRepositoryImpl(remote, tokenStorage);
    stubSave(() async {});
    when(() => tokenStorage.clear()).thenAnswer((_) async {});
  });

  test('login success saves both tokens before returning', () async {
    final saving = Completer<void>();
    stubSave(() => saving.future);
    when(() => remote.login(email: email, password: password))
        .thenAnswer((_) async => sessionDto);

    var returned = false;
    final pending = repository
        .login(email: email, password: password)
        .whenComplete(() => returned = true);
    await pumpEventQueue();

    expect(returned, isFalse);
    verify(
      () => tokenStorage.saveSession(accessToken: accessToken, refreshToken: refreshToken),
    ).called(1);

    saving.complete();
    expect(await pending, Success<LoginOutcome>(sessionDto.toDomain()));
  });

  test('login 401 returns UnauthorizedFailure and saves nothing', () async {
    when(() => remote.login(email: email, password: password))
        .thenThrow(httpError(HttpStatus.unauthorized));

    expect(
      await repository.login(email: email, password: password),
      const Error<LoginOutcome>(UnauthorizedFailure()),
    );
    verifyNever(
      () => tokenStorage.saveSession(
        accessToken: any(named: 'accessToken'),
        refreshToken: any(named: 'refreshToken'),
      ),
    );
  });

  test('login 403 returns UnknownFailure for now', () async {
    when(() => remote.login(email: email, password: password))
        .thenThrow(httpError(HttpStatus.forbidden));

    expect(
      await repository.login(email: email, password: password),
      const Error<LoginOutcome>(UnknownFailure()),
    );
  });

  test('resetPassword success saves both tokens and returns the session', () async {
    const token = 'reset-token';
    when(() => remote.resetPassword(token: token, password: password))
        .thenAnswer((_) async => sessionDto);

    expect(
      await repository.resetPassword(token: token, password: password),
      Success<LoginOutcome>(sessionDto.toDomain()),
    );
    verify(
      () => tokenStorage.saveSession(accessToken: accessToken, refreshToken: refreshToken),
    ).called(1);
  });

  test('malformed success body missing "data" returns UnknownFailure and does not throw', () async {
    final dio = Dio(BaseOptions(baseUrl: ApiConfig.authBaseUrl))
      ..httpClientAdapter = JsonBodyAdapter('{}');
    final realRepository = AuthRepositoryImpl(
      AuthRemoteDataSourceImpl(AuthApi(dio), ProfileApi(dio)),
      tokenStorage,
    );

    expect(
      await realRepository.login(email: email, password: password),
      const Error<LoginOutcome>(UnknownFailure()),
    );
    expect(await realRepository.isOnboarded(), const Error<bool>(UnknownFailure()));
    verifyNever(
      () => tokenStorage.saveSession(
        accessToken: any(named: 'accessToken'),
        refreshToken: any(named: 'refreshToken'),
      ),
    );
  });

  test('isOnboarded success returns the flag', () async {
    when(() => remote.getProfile())
        .thenAnswer((_) async => const ProfileDto(onboarded: false));

    expect(await repository.isOnboarded(), const Success(false));
  });

  test('clearSession calls TokenStorage.clear once', () async {
    await repository.clearSession();

    verify(() => tokenStorage.clear()).called(1);
  });
}

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/constants/api_config.dart';
import 'package:masarifak/core/constants/api_headers.dart';
import 'package:masarifak/core/network/auth_interceptor.dart';
import 'package:masarifak/core/network/token_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockTokenProvider extends Mock implements TokenProvider {}

class StatusAdapter implements HttpClientAdapter {
  StatusAdapter(this.status);

  final int status;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString('{}', status);

  @override
  void close({bool force = false}) {}
}

void main() {
  const accessToken = 'access-token';
  late MockTokenProvider tokenProvider;
  late int expiredCalls;

  setUp(() {
    tokenProvider = MockTokenProvider();
    expiredCalls = 0;
    when(() => tokenProvider.clear()).thenAnswer((_) async {});
  });

  Dio buildDio(int status) => Dio(BaseOptions(baseUrl: ApiConfig.apiBaseUrl))
    ..httpClientAdapter = StatusAdapter(status)
    ..interceptors.add(
      AuthInterceptor(tokenProvider, onSessionExpired: () => expiredCalls++),
    );

  test('401 on a request that carried a bearer token clears the token and expires the session once', () async {
    when(() => tokenProvider.readAccessToken()).thenAnswer((_) async => accessToken);

    await expectLater(
      buildDio(HttpStatus.unauthorized).get<dynamic>(ApiConfig.apiBaseUrl),
      throwsA(isA<DioException>()),
    );

    verify(() => tokenProvider.clear()).called(1);
    expect(expiredCalls, 1);
  });

  test('401 on a request without a bearer token neither clears nor expires', () async {
    when(() => tokenProvider.readAccessToken()).thenAnswer((_) async => null);

    await expectLater(
      buildDio(HttpStatus.unauthorized).get<dynamic>(ApiConfig.apiBaseUrl),
      throwsA(isA<DioException>()),
    );

    verifyNever(() => tokenProvider.clear());
    expect(expiredCalls, 0);
  });

  test('successful response neither clears nor expires', () async {
    when(() => tokenProvider.readAccessToken()).thenAnswer((_) async => accessToken);

    final response = await buildDio(HttpStatus.ok).get<dynamic>(ApiConfig.apiBaseUrl);

    expect(
      response.requestOptions.headers[ApiHeaders.authorization],
      '${ApiHeaders.bearerPrefix}$accessToken',
    );
    verifyNever(() => tokenProvider.clear());
    expect(expiredCalls, 0);
  });
}

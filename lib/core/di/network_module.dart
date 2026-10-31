import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../constants/di_names.dart';
import '../network/auth_interceptor.dart';
import '../network/device_id_provider.dart';
import '../network/dio_factory.dart';
import '../network/headers_interceptor.dart';
import '../network/token_provider.dart';
import '../storage/token_storage.dart';

@module
abstract class NetworkModule {
  @singleton
  FlutterSecureStorage storage() => const FlutterSecureStorage();

  @singleton
  TokenProvider tokenProvider(TokenStorage tokenStorage) => tokenStorage;

  @singleton
  DeviceIdProvider deviceIdProvider(FlutterSecureStorage storage) =>
      DeviceIdProvider(storage);

  @singleton
  HeadersInterceptor headersInterceptor(DeviceIdProvider deviceIdProvider) =>
      HeadersInterceptor(deviceIdProvider: deviceIdProvider);

  @singleton
  DioFactory dioFactory(
    HeadersInterceptor headersInterceptor,
    AuthInterceptor authInterceptor,
  ) => DioFactory(
    headersInterceptor: headersInterceptor,
    authInterceptor: authInterceptor,
  );

  @Named(DiNames.authDio)
  @singleton
  Dio authDio(DioFactory dioFactory) => dioFactory.createAuthDio();

  @Named(DiNames.apiDio)
  @singleton
  Dio apiDio(DioFactory dioFactory) => dioFactory.createApiDio();
}

import 'package:dio/dio.dart';

import '../constants/api_config.dart';
import 'auth_interceptor.dart';
import 'headers_interceptor.dart';

class DioFactory {
  DioFactory({
    required HeadersInterceptor headersInterceptor,
    required AuthInterceptor authInterceptor,
  }) : _headersInterceptor = headersInterceptor,
       _authInterceptor = authInterceptor;

  final HeadersInterceptor _headersInterceptor;
  final AuthInterceptor _authInterceptor;

  Dio createAuthDio() =>
      _create(ApiConfig.authBaseUrl)..interceptors.add(_headersInterceptor);

  Dio createApiDio() => _create(ApiConfig.apiBaseUrl)
    ..interceptors.addAll([_headersInterceptor, _authInterceptor]);

  Dio _create(String baseUrl) => Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(milliseconds: ApiConfig.connectTimeoutMs),
      receiveTimeout: const Duration(milliseconds: ApiConfig.receiveTimeoutMs),
      contentType: ApiConfig.jsonContentType,
    ),
  );
}

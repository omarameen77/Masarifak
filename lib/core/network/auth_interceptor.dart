import 'dart:io';

import 'package:dio/dio.dart';

import '../constants/api_headers.dart';
import 'token_provider.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(TokenProvider tokenProvider) : _tokenProvider = tokenProvider;

  final TokenProvider _tokenProvider;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!options.headers.containsKey(ApiHeaders.authorization)) {
      final token = await _tokenProvider.readAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers[ApiHeaders.authorization] =
            '${ApiHeaders.bearerPrefix}$token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final sentBearer = err.requestOptions.headers[ApiHeaders.authorization];
    final carriedBearer =
        sentBearer is String && sentBearer.startsWith(ApiHeaders.bearerPrefix);
    if (carriedBearer &&
        err.response?.statusCode == HttpStatus.unauthorized) {
      await _tokenProvider.clear();
    }
    handler.next(err);
  }
}

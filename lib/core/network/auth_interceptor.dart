import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../constants/api_headers.dart';
import '../session/session_expiry_notifier.dart';
import 'token_provider.dart';

@injectable
class AuthInterceptor extends Interceptor {
  AuthInterceptor(
    TokenProvider tokenProvider,
    SessionExpiryNotifier sessionExpiryNotifier,
  ) : _tokenProvider = tokenProvider,
      _sessionExpiryNotifier = sessionExpiryNotifier;

  final TokenProvider _tokenProvider;
  final SessionExpiryNotifier _sessionExpiryNotifier;

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
      _sessionExpiryNotifier.notifyExpired();
    }
    handler.next(err);
  }
}

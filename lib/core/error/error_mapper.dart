import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_error_fields.dart';
import 'failure.dart';

Failure mapDioError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return const TimeoutFailure();
    case DioExceptionType.connectionError:
      return const NetworkFailure();
    case DioExceptionType.badResponse:
      return _mapResponse(error);
    case DioExceptionType.badCertificate:
    case DioExceptionType.cancel:
    case DioExceptionType.unknown:
      return _unknown(error);
  }
}

Failure _mapResponse(DioException error) {
  final status = error.response?.statusCode;
  final body = error.response?.data;
  if (status == HttpStatus.unauthorized) return const UnauthorizedFailure();
  if (status == HttpStatus.conflict) return ConflictFailure(_errorCode(body));
  if (status == HttpStatus.unprocessableEntity) {
    return ValidationFailure(_errorFields(body), step: _errorStep(body));
  }
  if (status == HttpStatus.tooManyRequests) return const RateLimitFailure();
  if (status != null &&
      status >= HttpStatus.internalServerError &&
      status <= HttpStatus.networkConnectTimeoutError) {
    return const ServerFailure();
  }
  return _unknown(error);
}

Map<String, dynamic>? _errorObject(Object? body) {
  if (body is! Map<String, dynamic>) return null;
  final error = body[ApiErrorFields.error];
  return error is Map<String, dynamic> ? error : null;
}

String? _errorCode(Object? body) {
  final code = _errorObject(body)?[ApiErrorFields.code];
  return code is String ? code : null;
}

Map<String, dynamic>? _errorFields(Object? body) {
  final fields = _errorObject(body)?[ApiErrorFields.fields];
  return fields is Map<String, dynamic> ? fields : null;
}

int? _errorStep(Object? body) {
  final step = _errorObject(body)?[ApiErrorFields.step];
  return step is int ? step : null;
}

Failure _unknown(DioException error) {
  if (kDebugMode) {
    debugPrint('${error.type} ${error.response?.statusCode}');
  }
  return const UnknownFailure();
}

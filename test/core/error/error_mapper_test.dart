import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/constants/api_error_fields.dart';
import 'package:masarifak/core/error/error_mapper.dart';
import 'package:masarifak/core/error/failure.dart';

void main() {
  final request = RequestOptions();

  DioException badResponse(int status, [Object? data]) => DioException(
    requestOptions: request,
    type: DioExceptionType.badResponse,
    response: Response<Object?>(
      requestOptions: request,
      statusCode: status,
      data: data,
    ),
  );

  Map<String, dynamic> errorBody(Map<String, dynamic> error) => {
    ApiErrorFields.error: error,
  };

  test('401 maps to UnauthorizedFailure', () {
    expect(mapDioError(badResponse(401)), const UnauthorizedFailure());
  });

  test('409 maps to ConflictFailure with the documented error code', () {
    expect(
      mapDioError(badResponse(409, errorBody({ApiErrorFields.code: 'email_taken'}))),
      const ConflictFailure('email_taken'),
    );
  });

  test('422 maps to ValidationFailure with fields when present', () {
    final fields = {'email': 'invalid'};
    expect(
      mapDioError(badResponse(422, errorBody({ApiErrorFields.fields: fields}))),
      ValidationFailure(fields),
    );
  });

  test('422 carries the onboarding step when present', () {
    expect(
      mapDioError(badResponse(422, errorBody({ApiErrorFields.step: 2}))),
      const ValidationFailure(null, step: 2),
    );
  });

  test('429 maps to RateLimitFailure', () {
    expect(mapDioError(badResponse(429)), const RateLimitFailure());
  });

  test('5xx maps to ServerFailure', () {
    expect(mapDioError(badResponse(500)), const ServerFailure());
    expect(mapDioError(badResponse(503)), const ServerFailure());
  });

  test('timeouts map to TimeoutFailure', () {
    for (final type in [
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
    ]) {
      expect(
        mapDioError(DioException(requestOptions: request, type: type)),
        const TimeoutFailure(),
      );
    }
  });

  test('connection error maps to NetworkFailure', () {
    expect(
      mapDioError(
        DioException(requestOptions: request, type: DioExceptionType.connectionError),
      ),
      const NetworkFailure(),
    );
  });

  test('malformed body with an unmapped status yields UnknownFailure', () {
    expect(
      mapDioError(badResponse(400, '<html>Bad Gateway</html>')),
      const UnknownFailure(),
    );
  });

  test('malformed body never produces an error code', () {
    expect(mapDioError(badResponse(409, '<html/>')), const ConflictFailure(null));
    expect(
      mapDioError(badResponse(409, {ApiErrorFields.code: 'top_level_only'})),
      const ConflictFailure(null),
    );
    expect(
      mapDioError(badResponse(409, errorBody({ApiErrorFields.code: 42}))),
      const ConflictFailure(null),
    );
  });

  test('403 is not mapped yet and yields UnknownFailure', () {
    expect(mapDioError(badResponse(403)), const UnknownFailure());
  });
}

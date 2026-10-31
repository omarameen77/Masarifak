import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../error/error_mapper.dart';
import '../error/failure.dart';
import '../result/result.dart';

Future<Result<T>> guardRequest<T>(Future<T> Function() action) async {
  try {
    return Success(await action());
  } on DioException catch (error) {
    return Error(mapDioError(error));
  } catch (error) {
    if (kDebugMode) debugPrint('${error.runtimeType}');
    return Error<T>(const UnknownFailure());
  }
}

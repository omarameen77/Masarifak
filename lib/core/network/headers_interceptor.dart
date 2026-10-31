import 'package:dio/dio.dart';

import '../constants/api_config.dart';
import '../constants/api_headers.dart';
import '../constants/app_locales.dart';
import 'device_id_provider.dart';

typedef LanguageCodeProvider = String Function();

class HeadersInterceptor extends Interceptor {
  HeadersInterceptor({
    required DeviceIdProvider deviceIdProvider,
    LanguageCodeProvider? languageCode,
  }) : _deviceIdProvider = deviceIdProvider,
       _languageCode = languageCode ?? _fallbackLanguageCode;

  final DeviceIdProvider _deviceIdProvider;
  final LanguageCodeProvider _languageCode;

  static String _fallbackLanguageCode() => AppLocales.fallback.languageCode;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      options.headers.addAll({
        ApiHeaders.acceptLanguage: _languageCode(),
        ApiHeaders.appKey: ApiConfig.appKey,
        ApiHeaders.appVersion: ApiConfig.appVersion,
        ApiHeaders.platform: ApiConfig.platform,
        ApiHeaders.deviceId: await _deviceIdProvider.deviceId(),
      });
      handler.next(options);
    } catch (error, stackTrace) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}

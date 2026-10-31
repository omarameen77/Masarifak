import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/constants/api_config.dart';
import 'package:masarifak/core/constants/api_headers.dart';
import 'package:masarifak/core/constants/app_locales.dart';
import 'package:masarifak/core/network/device_id_provider.dart';
import 'package:masarifak/core/network/headers_interceptor.dart';
import 'package:mocktail/mocktail.dart';

class MockDeviceIdProvider extends Mock implements DeviceIdProvider {}

class CapturingAdapter implements HttpClientAdapter {
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    return ResponseBody.fromString('{}', 200);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  const deviceId = 'device-123';
  late MockDeviceIdProvider deviceIdProvider;
  late CapturingAdapter adapter;

  setUp(() {
    deviceIdProvider = MockDeviceIdProvider();
    when(() => deviceIdProvider.deviceId()).thenAnswer((_) async => deviceId);
    adapter = CapturingAdapter();
  });

  Future<Map<String, dynamic>> sentHeaders(HeadersInterceptor interceptor) async {
    final dio = Dio()
      ..httpClientAdapter = adapter
      ..interceptors.add(interceptor);
    await dio.get<dynamic>(ApiConfig.apiBaseUrl);
    return adapter.lastRequest!.headers;
  }

  test('sets all five headers on every request', () async {
    final headers = await sentHeaders(
      HeadersInterceptor(deviceIdProvider: deviceIdProvider),
    );

    expect(headers[ApiHeaders.acceptLanguage], AppLocales.fallback.languageCode);
    expect(headers[ApiHeaders.appKey], ApiConfig.appKey);
    expect(headers[ApiHeaders.appVersion], ApiConfig.appVersion);
    expect(headers[ApiHeaders.platform], ApiConfig.platform);
    expect(headers[ApiHeaders.deviceId], deviceId);
  });

  test('Accept-Language follows the provided locale function', () async {
    var current = AppLocales.arabic.languageCode;
    final interceptor = HeadersInterceptor(
      deviceIdProvider: deviceIdProvider,
      languageCode: () => current,
    );

    expect(
      (await sentHeaders(interceptor))[ApiHeaders.acceptLanguage],
      AppLocales.arabic.languageCode,
    );

    current = AppLocales.english.languageCode;
    expect(
      (await sentHeaders(interceptor))[ApiHeaders.acceptLanguage],
      AppLocales.english.languageCode,
    );
  });
}

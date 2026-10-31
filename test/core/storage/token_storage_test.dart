import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/constants/storage_keys.dart';
import 'package:masarifak/core/storage/token_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  const accessToken = 'access-token';
  const refreshToken = 'refresh-token';
  late MockSecureStorage secureStorage;
  late Map<String, String> values;
  late TokenStorage tokenStorage;

  setUp(() {
    secureStorage = MockSecureStorage();
    values = {};
    when(() => secureStorage.read(key: any(named: 'key'))).thenAnswer(
      (invocation) async => values[invocation.namedArguments[#key] as String],
    );
    when(
      () => secureStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((invocation) async {
      values[invocation.namedArguments[#key] as String] =
          invocation.namedArguments[#value] as String;
    });
    when(() => secureStorage.delete(key: any(named: 'key'))).thenAnswer(
      (invocation) async =>
          values.remove(invocation.namedArguments[#key] as String),
    );
    tokenStorage = TokenStorage(secureStorage);
  });

  test('readAccessToken returns null when nothing is stored', () async {
    expect(await tokenStorage.readAccessToken(), isNull);
  });

  test('saveSession stores both tokens and readAccessToken returns the access token', () async {
    await tokenStorage.saveSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    expect(await tokenStorage.readAccessToken(), accessToken);
    expect(values[StorageKeys.accessToken], accessToken);
    expect(values[StorageKeys.refreshToken], refreshToken);
  });

  test('clear deletes both tokens', () async {
    await tokenStorage.saveSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    await tokenStorage.clear();

    expect(await tokenStorage.readAccessToken(), isNull);
    expect(values, isEmpty);
    verify(() => secureStorage.delete(key: StorageKeys.accessToken)).called(1);
    verify(() => secureStorage.delete(key: StorageKeys.refreshToken)).called(1);
  });

  test('refresh token is never read', () async {
    await tokenStorage.saveSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
    await tokenStorage.readAccessToken();

    verifyNever(() => secureStorage.read(key: StorageKeys.refreshToken));
  });
}

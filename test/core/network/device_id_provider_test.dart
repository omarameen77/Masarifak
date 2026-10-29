import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/constants/storage_keys.dart';
import 'package:masarifak/core/network/device_id_provider.dart';

class FakeSecureStorage extends Fake implements FlutterSecureStorage {
  final values = <String, String>{};
  var writes = 0;

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => values[key];

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    writes++;
    if (value == null) {
      values.remove(key);
    } else {
      values[key] = value;
    }
  }
}

void main() {
  const generatedId = 'generated-id';
  late FakeSecureStorage storage;
  late int generateCalls;

  String generate() {
    generateCalls++;
    return generatedId;
  }

  setUp(() {
    storage = FakeSecureStorage();
    generateCalls = 0;
  });

  test('generates and stores an id once, then returns the same id', () async {
    final provider = DeviceIdProvider(storage, generateId: generate);

    final first = await provider.deviceId();
    final second = await provider.deviceId();

    expect(first, generatedId);
    expect(second, first);
    expect(generateCalls, 1);
    expect(storage.writes, 1);
    expect(storage.values[StorageKeys.deviceId], generatedId);
  });

  test('reuses the stored id across provider instances', () async {
    await DeviceIdProvider(storage, generateId: generate).deviceId();
    final restored = await DeviceIdProvider(storage, generateId: generate).deviceId();

    expect(restored, generatedId);
    expect(generateCalls, 1);
  });

  test('default generator produces a uuid v4', () async {
    final id = await DeviceIdProvider(storage).deviceId();

    expect(
      RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$')
          .hasMatch(id),
      isTrue,
    );
  });
}

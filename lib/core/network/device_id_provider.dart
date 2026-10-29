import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

import '../constants/storage_keys.dart';

class DeviceIdProvider {
  DeviceIdProvider(
    FlutterSecureStorage storage, {
    String Function()? generateId,
  }) : _storage = storage,
       _generateId = generateId ?? const Uuid().v4;

  final FlutterSecureStorage _storage;
  final String Function() _generateId;
  String? _cached;

  Future<String> deviceId() async {
    final cached = _cached;
    if (cached != null) return cached;

    final stored = await _storage.read(key: StorageKeys.deviceId);
    if (stored != null && stored.isNotEmpty) return _cached = stored;

    final generated = _generateId();
    await _storage.write(key: StorageKeys.deviceId, value: generated);
    return _cached = generated;
  }
}

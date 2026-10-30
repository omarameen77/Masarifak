import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../constants/storage_keys.dart';
import '../network/token_provider.dart';

@singleton
class TokenStorage implements TokenProvider {
  TokenStorage(FlutterSecureStorage storage) : _storage = storage;

  final FlutterSecureStorage _storage;

  @override
  Future<String?> readAccessToken() async {
    final token = await _storage.read(key: StorageKeys.accessToken);
    return token == null || token.isEmpty ? null : token;
  }

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: StorageKeys.accessToken, value: accessToken);
    await _storage.write(key: StorageKeys.refreshToken, value: refreshToken);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: StorageKeys.accessToken);
    await _storage.delete(key: StorageKeys.refreshToken);
  }
}

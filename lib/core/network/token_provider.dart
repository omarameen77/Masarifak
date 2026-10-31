abstract interface class TokenProvider {
  Future<String?> readAccessToken();

  Future<void> clear();
}

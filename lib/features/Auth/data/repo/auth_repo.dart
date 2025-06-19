abstract class AuthRepo {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });
  Future<bool> isLoggedIn();
  Future<void> logout();
  Future<void> saveTokens(String token, String refreshToken, String userId);
  Future<void> clearTokens();
}

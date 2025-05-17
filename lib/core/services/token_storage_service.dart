/// Интерфейс для хранения токенов и пользовательских данных
abstract class TokenStorageService {
  Future<void> saveAccessToken(String token);
  Future<void> saveRefreshToken(String token);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();

  Future<void> saveUserId(String userId);
  Future<void> savePhoneNumber(String phoneNumber);
  Future<String?> getUserId();
  Future<String?> getPhoneNumber();

  Future<void> clearTokens(); // удаляет только access/refresh
  Future<void> clearAll(); // удаляет всё
}

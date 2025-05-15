import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorageService {
  final FlutterSecureStorage _storage;

  TokenStorageService([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveTokens({
    required String userId,
    required String accessToken,
    required String refreshToken,
    required String phoneNumber,
  }) async {
    await _storage.write(key: 'userId', value: userId);
    await _storage.write(key: 'accessToken', value: accessToken);
    await _storage.write(key: 'refreshToken', value: refreshToken);
    await _storage.write(key: 'phoneNumber', value: phoneNumber);
  }

  Future<Map<String, String?>> readTokens() async {
    final userId = await _storage.read(key: 'userId');
    final accessToken = await _storage.read(key: 'accessToken');
    final refreshToken = await _storage.read(key: 'refreshToken');
    final phoneNumber = await _storage.read(key: 'phoneNumber');
    return {
      'userId': userId,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'phoneNumber': phoneNumber,
    };
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
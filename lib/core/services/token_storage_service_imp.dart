import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'token_storage_service.dart';

class TokenStorageServiceImpl implements TokenStorageService {
  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'ACCESS_TOKEN';
  static const _refreshTokenKey = 'REFRESH_TOKEN';
  static const _userIdKey = 'USER_ID';
  static const _phoneNumberKey = 'PHONE_NUMBER';

  TokenStorageServiceImpl([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  @override
  Future<String?> getAccessToken() async {
    return _storage.read(key: _accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _storage.read(key: _refreshTokenKey);
  }

  @override
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  @override
  Future<void> savePhoneNumber(String phoneNumber) async {
    await _storage.write(key: _phoneNumberKey, value: phoneNumber);
  }

  @override
  Future<String?> getUserId() async {
    return _storage.read(key: _userIdKey);
  }

  @override
  Future<String?> getPhoneNumber() async {
    return _storage.read(key: _phoneNumberKey);
  }

  @override
  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
    ]);
  }

  @override
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}

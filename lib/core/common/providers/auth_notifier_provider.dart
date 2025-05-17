import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_riverpod/core/common/models/user_model.dart';
import 'package:my_riverpod/core/services/token_storage_service_provider.dart';
import 'package:my_riverpod/features/auth/data/repositories_impl/auth_repository_impl.dart';

final authNotifierProvider =
    NotifierProvider<AuthNotifier, UserModel?>(() => AuthNotifier());

class AuthNotifier extends Notifier<UserModel?> {
  @override
  UserModel? build() => null;

  Future<void> saveLogin({
    required String userId,
    required String accessToken,
    required String refreshToken,
    required String phoneNumber,
  }) async {
    state = UserModel(
      userId: userId,
      accessToken: accessToken,
      refreshToken: refreshToken,
      phoneNumber: phoneNumber,
    );

    final storage = ref.read(tokenStorageServiceProvider);
    await storage.saveAccessToken(accessToken);
    await storage.saveRefreshToken(refreshToken);
    await storage.saveUserId(userId);
    await storage.savePhoneNumber(phoneNumber);
  }

  Future<void> init() async {
    final storage = ref.read(tokenStorageServiceProvider);

    final accessToken = await storage.getAccessToken();
    final refreshToken = await storage.getRefreshToken();
    final userId = await storage.getUserId();
    final phoneNumber = await storage.getPhoneNumber();

    if (accessToken != null &&
        refreshToken != null &&
        userId != null &&
        phoneNumber != null) {
      state = UserModel(
        userId: userId,
        accessToken: accessToken,
        refreshToken: refreshToken,
        phoneNumber: phoneNumber,
      );
    } else {
      state = null;
    }
  }

  Future<void> logout() async {
    state = null;
    final storage = ref.read(tokenStorageServiceProvider);
    await storage.clearTokens(); // только access и refresh токены
  }

  Future<UserModel> refreshToken() async {
    final storage = ref.read(tokenStorageServiceProvider);

    final refreshToken = await storage.getRefreshToken();
    final userId = await storage.getUserId();
    final phoneNumber = await storage.getPhoneNumber();

    if (refreshToken == null || userId == null || phoneNumber == null) {
      await logout();
      throw Exception('Refresh token or user info missing');
    }

    final repository = ref.read(authRepositoryProvider);
    final newLogin = await repository.refreshToken(refreshToken);

    await saveLogin(
      userId: userId,
      phoneNumber: phoneNumber,
      accessToken: newLogin.accessToken!,
      refreshToken: newLogin.refreshToken!,
    );

    return UserModel(
      userId: userId,
      accessToken: newLogin.accessToken!,
      refreshToken: newLogin.refreshToken!,
      phoneNumber: phoneNumber,
    );
  }
}

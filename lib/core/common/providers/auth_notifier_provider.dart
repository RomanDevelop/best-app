import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_riverpod/core/services/token_storage_service_provider.dart';
import '../../../../../core/common/models/user_model.dart';

final authNotifierProvider =
    NotifierProvider<AuthNotifier, UserModel?>(() => AuthNotifier());

class AuthNotifier extends Notifier<UserModel?> {
  @override
  UserModel? build() => null;

  void saveLogin({
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
    await storage.saveTokens(
      userId: userId,
      accessToken: accessToken,
      refreshToken: refreshToken,
      phoneNumber: phoneNumber,
    );
  }

  Future<void> init() async {
    final storage = ref.read(tokenStorageServiceProvider);
    final tokens = await storage.readTokens();

    if (tokens['accessToken'] != null && tokens['userId'] != null) {
      state = UserModel(
        userId: tokens['userId']!,
        accessToken: tokens['accessToken']!,
        refreshToken: tokens['refreshToken']!,
        phoneNumber: tokens['phoneNumber']!,
      );
    }
  }

  Future<void> logout() async {
    state = null;
    final storage = ref.read(tokenStorageServiceProvider);
    await storage.clear();
  }
}

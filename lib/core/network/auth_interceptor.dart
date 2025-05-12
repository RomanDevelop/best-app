import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_riverpod/core/common/providers/auth_notifier_provider.dart';
import 'package:my_riverpod/core/services/token_storage_service_provider.dart';
import 'package:my_riverpod/features/auth/data/models/login_data_model.dart';
import 'package:my_riverpod/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:my_riverpod/features/auth/domain/repositories/auth_repository.dart';

class AuthInterceptor extends Interceptor {
  final Ref ref;

  AuthInterceptor(this.ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final user = ref.read(authNotifierProvider);
    if (user != null) {
      options.headers['Authorization'] = 'Bearer ${user.accessToken}';
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    // Только если 401
    if (err.response?.statusCode == 401) {
      final storage = ref.read(tokenStorageServiceProvider);
      final refreshToken = (await storage.readTokens())['refreshToken'];
      final userId = (await storage.readTokens())['userId'];
      final phoneNumber = (await storage.readTokens())['phoneNumber'];

      if (refreshToken == null || userId == null || phoneNumber == null) {
        await ref.read(authNotifierProvider.notifier).logout();
        return handler.reject(err);
      }

      try {
        final repository = ref.read(authRepositoryProvider);
        final newLogin = await repository.refreshToken(refreshToken);

        // обновляем userModel + secure storage
        await ref.read(authNotifierProvider.notifier).saveLogin(
              userId: userId,
              phoneNumber: phoneNumber,
              accessToken: newLogin.accessToken!,
              refreshToken: newLogin.refreshToken!,
            );

        // повторяем оригинальный запрос
        final cloneRequest =
            await _retry(err.requestOptions, newLogin.accessToken!);
        return handler.resolve(cloneRequest);
      } catch (_) {
        await ref.read(authNotifierProvider.notifier).logout();
        return handler.reject(err);
      }
    }

    return handler.reject(err);
  }

  Future<Response<dynamic>> _retry(
      RequestOptions requestOptions, String newToken) {
    final options = Options(
      method: requestOptions.method,
      headers: Map.of(requestOptions.headers)
        ..['Authorization'] = 'Bearer $newToken',
    );

    final dio = Dio(); // можно заменить на ref.read(dioProvider) при DI
    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}

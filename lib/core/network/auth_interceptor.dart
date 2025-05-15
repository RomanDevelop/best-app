import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_riverpod/core/common/providers/auth_notifier_provider.dart';

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
    if (err.response?.statusCode == 401) {
      try {
        final refreshed =
            await ref.read(authNotifierProvider.notifier).refreshToken();

        final cloneRequest =
            await _retry(err.requestOptions, refreshed.accessToken);
        return handler.resolve(cloneRequest);
      } catch (e) {
        throw Exception('AuthInterceptor.onError catch: e=e, stack=st');
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

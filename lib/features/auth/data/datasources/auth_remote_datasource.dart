import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_riverpod/core/error/app_exception.dart';
import 'package:my_riverpod/core/network/api_client_provider.dart';
import '../models/login_request_model.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = ref.watch(apiClientProvider);
  return AuthRemoteDataSource(dio);
});

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<Either<AppException, Map<String, dynamic>>> login(
    LoginRequestModel model,
  ) async {
    try {
      final response = await dio.post(
        'https://your.api.endpoint/login',
        data: model.toJson(),
      );

      return right(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      return left(AppException.from(e));
    } catch (e) {
      return left(AppException.unknown(e.toString()));
    }
  }

  Future<Map<String, dynamic>> refresh(String refreshToken) async {
    try {
      final response = await dio.post(
        'https://your.api.endpoint/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      } else {
        throw AppException.server('Failed to refresh token');
      }
    } catch (e) {
      // ⬇️ вот это обязательно:
      throw AppException.from(e);
    }
  }

  // Future<Map<String, dynamic>> refresh(String refreshToken) async {
  //   final response = await dio.post(
  //     'https://your.api.endpoint/auth/refresh', // замени на реальный URL
  //     data: {
  //       'refreshToken': refreshToken,
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     return response.data as Map<String, dynamic>;
  //   } else {
  //     throw Exception('Failed to refresh token');
  //   }
  // }
}

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_riverpod/core/error/app_exception.dart';
import 'package:my_riverpod/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:my_riverpod/features/auth/data/models/login_data_model.dart';
import 'package:my_riverpod/features/auth/data/models/login_request_model.dart';
import 'package:my_riverpod/features/auth/domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remote = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remote);
});

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<Either<AppException, void>> login(String phone) async {
    try {
      final response = await remote.login(
        LoginRequestModel(phone: phone),
      );
      return response.fold(
        (failure) => left(failure),
        (_) => const Right(null),
      );
    } catch (e) {
      return left(AppException.from(e));
    }
  }

  @override
  Future<Either<AppException, LoginDataModel>> verifyOTP(
    String phone,
    String? otp,
    String? hash,
  ) async {
    try {
      final response = await remote.login(
        LoginRequestModel(phone: phone, otp: otp, hash: hash),
      );
      return response.fold(
        (failure) => left(failure),
        (data) => right(LoginDataModel.fromJson(data)),
      );
    } catch (e) {
      return left(AppException.from(e));
    }
  }

  @override
  Future<LoginDataModel> refreshToken(String refreshToken) async {
    final response = await remote.refresh(refreshToken);

    return LoginDataModel.fromJson(response);
  }
}

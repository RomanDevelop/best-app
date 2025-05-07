import 'package:dartz/dartz.dart';
import 'package:my_riverpod/core/error/app_exception.dart';
import '../../data/models/login_data_model.dart';

abstract class AuthRepository {
  Future<void> login(String phone);

  Future<Either<AppException, LoginDataModel>> verifyOTP(
    String phone,
    String? otp,
    String? hash,
  );
}

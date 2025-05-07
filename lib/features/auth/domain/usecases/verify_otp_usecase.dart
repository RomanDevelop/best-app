import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/login_data_model.dart';
import '../../data/repositories_impl/auth_repository_impl.dart';
import '../repositories/auth_repository.dart';
import 'package:my_riverpod/core/error/app_exception.dart';

final verifyOtpUseCaseProvider = Provider<VerifyOTPUseCase>((ref) {
  return VerifyOTPUseCase(ref.read(authRepositoryProvider));
});

class VerifyOTPUseCase {
  final AuthRepository repository;

  VerifyOTPUseCase(this.repository);

  Future<Either<AppException, LoginDataModel>> execute(
    String phone,
    String? otp,
    String? hash,
  ) {
    return repository.verifyOTP(phone, otp, hash);
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_riverpod/core/common/providers/auth_notifier_provider.dart';
import 'package:my_riverpod/features/auth/domain/entities/verify_otp_state.dart';
import '../../domain/usecases/verify_otp_usecase.dart';

class VerifyOTPNotifier extends Notifier<VerifyOtpState> {
  @override
  VerifyOtpState build() => VerifyOtpState();

  Future<void> verifyOTP(String phone, String otp, String hash) async {
    state = state.copyWith(isLoading: true, data: null);

    final useCase = ref.read(verifyOtpUseCaseProvider);
    final result = await useCase.execute(phone, otp, hash);

    result.fold(
      (failure) {
        // TODO: handle error (в оригинале — пусто)
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (data) {
        ref.read(authNotifierProvider.notifier).saveLogin(
              userId: data.userId!,
              accessToken: data.accessToken!,
              refreshToken: data.refreshToken!,
              phoneNumber: phone,
            );
        state = state.copyWith(isLoading: false, data: data);
      },
    );
  }
}

final verifyOtpProvider = NotifierProvider<VerifyOTPNotifier, VerifyOtpState>(
  () => VerifyOTPNotifier(),
);

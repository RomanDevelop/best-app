import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:my_riverpod/core/error/app_exception.dart';

import 'package:my_riverpod/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:my_riverpod/features/auth/data/models/login_data_model.dart';
import 'package:my_riverpod/core/common/providers/auth_notifier_provider.dart';
import 'package:my_riverpod/features/auth/presentation/providers/verify_otp_provider.dart';

class MockVerifyOtpUseCase extends Mock implements VerifyOTPUseCase {}

/// ✅ Поддельный AuthNotifier, который ничего не делает, но не ломается
class FakeAuthNotifier extends AuthNotifier {
  @override
  Future<void> saveLogin({
    required String userId,
    required String accessToken,
    required String refreshToken,
    required String phoneNumber,
  }) async {
    // no-op
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockVerifyOtpUseCase mockUseCase;
  late FakeAuthNotifier fakeAuthNotifier;
  late ProviderContainer container;

  setUp(() {
    mockUseCase = MockVerifyOtpUseCase();
    fakeAuthNotifier = FakeAuthNotifier();

    container = ProviderContainer(
      overrides: [
        verifyOtpUseCaseProvider.overrideWithValue(mockUseCase),
        authNotifierProvider.overrideWith(() => fakeAuthNotifier),
      ],
    );
  });

  test('should update state with error on failure', () async {
    const phone = '1234567890';
    const otp = '000000';
    const hash = 'abc';

    final exception = AppException.server('Invalid OTP');

    when(() => mockUseCase.execute(phone, otp, hash))
        .thenAnswer((_) async => Left(exception));

    final notifier = container.read(verifyOtpProvider.notifier);
    await notifier.verifyOTP(phone, otp, hash);

    final state = container.read(verifyOtpProvider);

    expect(state.isLoading, false);
    expect(state.data, isNull);
    expect(state.error, 'Invalid OTP');
  });

  test('should update state with LoginDataModel on success', () async {
    const phone = '1234567890';
    const otp = '123456';
    const hash = 'abc';

    final loginData = LoginDataModel(
      userId: 'u1',
      accessToken: 'a1',
      refreshToken: 'r1',
    );

    when(() => mockUseCase.execute(phone, otp, hash))
        .thenAnswer((_) async => Right(loginData));

    final notifier = container.read(verifyOtpProvider.notifier);
    await notifier.verifyOTP(phone, otp, hash);

    final state = container.read(verifyOtpProvider);
    expect(state.isLoading, false);
    expect(state.data, loginData);
    expect(state.error, isNull);
  });
}

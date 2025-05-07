import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:my_riverpod/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:my_riverpod/features/auth/domain/repositories/auth_repository.dart';
import 'package:my_riverpod/features/auth/data/models/login_data_model.dart';
import 'package:my_riverpod/core/error/app_exception.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late VerifyOTPUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = VerifyOTPUseCase(mockRepository);
  });

  test('returns Right(LoginDataModel)', () async {
    const phone = '1234567890';
    const otp = '123456';
    const hash = 'abc';

    final loginData = LoginDataModel(
      userId: 'u1',
      accessToken: 'a1',
      refreshToken: 'r1',
    );

    when(() => mockRepository.verifyOTP(phone, otp, hash))
        .thenAnswer((_) async => Right(loginData));

    final result = await useCase.execute(phone, otp, hash);

    expect(result.isRight(), true);
    expect(result.getOrElse(() => throw 'fail'), equals(loginData));
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:my_riverpod/features/auth/domain/usecases/login_usecase.dart';
import 'package:my_riverpod/features/auth/domain/repositories/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  test('should call login() on AuthRepository with correct phone number',
      () async {
    // arrange
    const phone = '1234567890';
    when(() => mockRepository.login(phone)).thenAnswer((_) async {});

    // act
    await useCase.execute(phone);

    // assert
    verify(() => mockRepository.login(phone)).called(1);
  });
}

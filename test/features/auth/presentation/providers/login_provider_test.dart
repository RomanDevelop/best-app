import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:my_riverpod/features/auth/domain/entities/login_state.dart';
import 'package:my_riverpod/features/auth/domain/usecases/login_usecase.dart';
import 'package:my_riverpod/features/auth/presentation/providers/login_provider.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late MockLoginUseCase mockUseCase;
  late ProviderContainer container;

  setUp(() {
    mockUseCase = MockLoginUseCase();

    container = ProviderContainer(
      overrides: [
        loginUseCaseProvider.overrideWithValue(mockUseCase),
      ],
    );
  });

  test('should update state isLoading true → false and call useCase', () async {
    const phone = '1234567890';

    when(() => mockUseCase.execute(phone)).thenAnswer((_) async {});

    final notifier = container.read(loginProvider.notifier);
    expect(container.read(loginProvider).isLoading, false);

    final future = notifier.login(phone);

    expect(container.read(loginProvider).isLoading, true); // before await

    await future;

    expect(container.read(loginProvider).isLoading, false);
    expect(container.read(loginProvider).error, isNull);

    verify(() => mockUseCase.execute(phone)).called(1);
  });
}

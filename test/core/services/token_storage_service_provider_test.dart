import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:my_riverpod/core/services/token_storage_service.dart';
import 'package:my_riverpod/core/services/token_storage_service_imp.dart';
import 'package:my_riverpod/core/services/token_storage_service_provider.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockSecureStorage();

    // stub write
    when(() => mockStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'))).thenAnswer((_) async {});
  });

  test('tokenStorageServiceProvider provides TokenStorageServiceImpl',
      () async {
    final container = ProviderContainer(
      overrides: [
        // Переопределяем зависимость, если бы она использовалась в провайдере напрямую
        tokenStorageServiceProvider.overrideWithValue(
          TokenStorageServiceImpl(mockStorage),
        ),
      ],
    );

    final service = container.read(tokenStorageServiceProvider);

    expect(service, isA<TokenStorageService>());
    await service.saveAccessToken('abc123');

    verify(() => mockStorage.write(key: 'ACCESS_TOKEN', value: 'abc123'))
        .called(1);
  });
}

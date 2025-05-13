import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:my_riverpod/core/common/providers/auth_notifier_provider.dart';
import 'package:my_riverpod/core/services/token_storage_service.dart';
import 'package:my_riverpod/core/services/token_storage_service_provider.dart';

class MockTokenStorageService extends Mock implements TokenStorageService {}

void main() {
  late ProviderContainer container;
  late MockTokenStorageService mockStorage;

  setUp(() {
    mockStorage = MockTokenStorageService();

    container = ProviderContainer(
      overrides: [
        tokenStorageServiceProvider.overrideWithValue(mockStorage),
      ],
    );
  });

  test('saveLogin() should store user and save tokens', () async {
    when(() => mockStorage.saveTokens(
          userId: any(named: 'userId'),
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
          phoneNumber: any(named: 'phoneNumber'),
        )).thenAnswer((_) async {});

    final notifier = container.read(authNotifierProvider.notifier);

    await notifier.saveLogin(
      userId: 'user123',
      accessToken: 'access123',
      refreshToken: 'refresh123',
      phoneNumber: '+1234567890',
    );

    final user = container.read(authNotifierProvider);

    expect(user?.userId, 'user123');
    expect(user?.accessToken, 'access123');

    verify(() => mockStorage.saveTokens(
          userId: 'user123',
          accessToken: 'access123',
          refreshToken: 'refresh123',
          phoneNumber: '+1234567890',
        )).called(1);
  });

  test('logout() should clear user and storage', () async {
    when(() => mockStorage.clear()).thenAnswer((_) async {});

    final notifier = container.read(authNotifierProvider.notifier);
    await notifier.logout();

    final user = container.read(authNotifierProvider);
    expect(user, isNull);

    verify(() => mockStorage.clear()).called(1);
  });

  test('init() should restore user if tokens exist', () async {
    when(() => mockStorage.readTokens()).thenAnswer((_) async => {
          'userId': 'u1',
          'accessToken': 'a1',
          'refreshToken': 'r1',
          'phoneNumber': '+380123456789',
        });

    final notifier = container.read(authNotifierProvider.notifier);
    await notifier.init();

    final user = container.read(authNotifierProvider);
    expect(user?.userId, 'u1');
    expect(user?.accessToken, 'a1');
  });

  test('init() should set state to null if tokens missing', () async {
    when(() => mockStorage.readTokens()).thenAnswer((_) async => {});

    final notifier = container.read(authNotifierProvider.notifier);
    await notifier.init();

    final user = container.read(authNotifierProvider);
    expect(user, isNull);
  });
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:my_riverpod/core/common/models/user_model.dart';
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
    when(() => mockStorage.saveAccessToken(any())).thenAnswer((_) async {});
    when(() => mockStorage.saveRefreshToken(any())).thenAnswer((_) async {});
    when(() => mockStorage.saveUserId(any())).thenAnswer((_) async {});
    when(() => mockStorage.savePhoneNumber(any())).thenAnswer((_) async {});

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

    verify(() => mockStorage.saveAccessToken('access123')).called(1);
    verify(() => mockStorage.saveRefreshToken('refresh123')).called(1);
    verify(() => mockStorage.saveUserId('user123')).called(1);
    verify(() => mockStorage.savePhoneNumber('+1234567890')).called(1);
  });

  test('logout() should clear user and storage', () async {
    when(() => mockStorage.clearTokens()).thenAnswer((_) async {});

    final notifier = container.read(authNotifierProvider.notifier);
    await notifier.logout();

    final user = container.read(authNotifierProvider);
    expect(user, isNull);

    verify(() => mockStorage.clearTokens()).called(1);
  });

  test('init() should restore user if tokens exist', () async {
    when(() => mockStorage.getUserId()).thenAnswer((_) async => 'u1');
    when(() => mockStorage.getAccessToken()).thenAnswer((_) async => 'a1');
    when(() => mockStorage.getRefreshToken()).thenAnswer((_) async => 'r1');
    when(() => mockStorage.getPhoneNumber())
        .thenAnswer((_) async => '+380123456789');

    final notifier = container.read(authNotifierProvider.notifier);
    await notifier.init();

    final user = container.read(authNotifierProvider);
    expect(user, isA<UserModel>());
    expect(user?.userId, 'u1');
    expect(user?.accessToken, 'a1');
  });

  test('init() should set state to null if tokens missing', () async {
    when(() => mockStorage.getUserId()).thenAnswer((_) async => null);
    when(() => mockStorage.getAccessToken()).thenAnswer((_) async => null);
    when(() => mockStorage.getRefreshToken()).thenAnswer((_) async => null);
    when(() => mockStorage.getPhoneNumber()).thenAnswer((_) async => null);

    final notifier = container.read(authNotifierProvider.notifier);
    await notifier.init();

    final user = container.read(authNotifierProvider);
    expect(user, isNull);
  });
}

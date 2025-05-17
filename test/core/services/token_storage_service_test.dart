import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:my_riverpod/core/services/token_storage_service.dart';
import 'package:my_riverpod/core/services/token_storage_service_imp.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockSecureStorage mockStorage;
  late TokenStorageService service;

  setUp(() {
    mockStorage = MockSecureStorage();

    when(() => mockStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'))).thenAnswer((_) async {});
    when(() => mockStorage.read(key: any(named: 'key')))
        .thenAnswer((_) async => null);
    when(() => mockStorage.delete(key: any(named: 'key')))
        .thenAnswer((_) async {});
    when(() => mockStorage.deleteAll()).thenAnswer((_) async {});

    service = TokenStorageServiceImpl(mockStorage);
  });

  test('should save all tokens and user info', () async {
    await service.saveAccessToken('access');
    await service.saveRefreshToken('refresh');
    await service.saveUserId('user123');
    await service.savePhoneNumber('1234567890');

    verify(() => mockStorage.write(key: 'ACCESS_TOKEN', value: 'access'))
        .called(1);
    verify(() => mockStorage.write(key: 'REFRESH_TOKEN', value: 'refresh'))
        .called(1);
    verify(() => mockStorage.write(key: 'USER_ID', value: 'user123')).called(1);
    verify(() => mockStorage.write(key: 'PHONE_NUMBER', value: '1234567890'))
        .called(1);
  });

  test('should read all saved values', () async {
    when(() => mockStorage.read(key: any(named: 'key')))
        .thenAnswer((invocation) async {
      final key = invocation.namedArguments[#key];
      return {
        'ACCESS_TOKEN': 'access',
        'REFRESH_TOKEN': 'refresh',
        'USER_ID': 'user123',
        'PHONE_NUMBER': '1234567890',
      }[key];
    });

    expect(await service.getAccessToken(), 'access');
    expect(await service.getRefreshToken(), 'refresh');
    expect(await service.getUserId(), 'user123');
    expect(await service.getPhoneNumber(), '1234567890');
  });

  test('should clear only tokens', () async {
    await service.clearTokens();

    verify(() => mockStorage.delete(key: 'ACCESS_TOKEN')).called(1);
    verify(() => mockStorage.delete(key: 'REFRESH_TOKEN')).called(1);
  });

  test('should clear all when clearAll is called', () async {
    await service.clearAll();
    verify(() => mockStorage.deleteAll()).called(1);
  });
}

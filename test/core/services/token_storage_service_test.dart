import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:my_riverpod/core/services/token_storage_service.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockSecureStorage mockStorage;
  late TokenStorageService service;

  setUp(() {
    mockStorage = MockSecureStorage();

    // ✅ Заглушки для всех async методов
    when(() => mockStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'))).thenAnswer((_) async {});
    when(() => mockStorage.deleteAll()).thenAnswer((_) async {});

    service = TokenStorageService(mockStorage);
  });

  test('should save tokens using secure storage', () async {
    await service.saveTokens(
      userId: 'u1',
      accessToken: 'a1',
      refreshToken: 'r1',
      phoneNumber: '1234567890',
    );

    verify(() => mockStorage.write(key: 'userId', value: 'u1')).called(1);
    verify(() => mockStorage.write(key: 'accessToken', value: 'a1')).called(1);
    verify(() => mockStorage.write(key: 'refreshToken', value: 'r1')).called(1);
    verify(() => mockStorage.write(key: 'phoneNumber', value: '1234567890'))
        .called(1);
  });

  test('should read tokens from secure storage', () async {
    when(() => mockStorage.read(key: any(named: 'key')))
        .thenAnswer((invocation) async {
      final key = invocation.namedArguments[#key];
      return {
        'userId': 'u1',
        'accessToken': 'a1',
        'refreshToken': 'r1',
        'phoneNumber': '1234567890',
      }[key];
    });

    final result = await service.readTokens();

    expect(result['userId'], 'u1');
    expect(result['accessToken'], 'a1');
    expect(result['refreshToken'], 'r1');
    expect(result['phoneNumber'], '1234567890');
  });

  test('should clear secure storage', () async {
    await service.clear();
    verify(() => mockStorage.deleteAll()).called(1);
  });
}

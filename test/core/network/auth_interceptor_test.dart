import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_riverpod/core/network/auth_interceptor.dart';
import 'package:my_riverpod/core/common/models/user_model.dart';
import 'package:my_riverpod/core/common/providers/auth_notifier_provider.dart';

class MockRequestHandler extends Mock implements RequestInterceptorHandler {}

class MockRef extends Mock implements Ref {}

/// ✅ Добавить fake для RequestOptions
class FakeRequestOptions extends Fake implements RequestOptions {}

void main() {
  late MockRef mockRef;
  late AuthInterceptor interceptor;
  late RequestOptions requestOptions;
  late MockRequestHandler handler;

  /// ✅ Зарегистрировать fallback value
  setUpAll(() {
    registerFallbackValue(FakeRequestOptions());
  });

  setUp(() {
    mockRef = MockRef();
    interceptor = AuthInterceptor(mockRef);
    requestOptions = RequestOptions(path: '/test');
    handler = MockRequestHandler();
  });

  test('should add Authorization header if accessToken is available', () {
    final user = UserModel(
      userId: '123',
      accessToken: 'abc123',
      refreshToken: 'refresh123',
      phoneNumber: '1234567890',
    );

    when(() => mockRef.read(authNotifierProvider)).thenReturn(user);
    when(() => handler.next(any())).thenAnswer((_) {});

    interceptor.onRequest(requestOptions, handler);

    expect(requestOptions.headers['Authorization'], 'Bearer abc123');
    verify(() => handler.next(requestOptions)).called(1);
  });

  test('should not add Authorization header if user is not authenticated', () {
    // Мокаем отсутствие пользователя (не авторизован)
    when(() => mockRef.read(authNotifierProvider)).thenReturn(null);
    when(() => handler.next(any())).thenAnswer((_) {});

    // Убедимся, что до вызова заголовок не существует
    requestOptions.headers.remove('Authorization');

    interceptor.onRequest(requestOptions, handler);

    // Проверяем, что заголовок не добавлен
    expect(requestOptions.headers.containsKey('Authorization'), isFalse);
    // Проверяем, что handler.next вызван
    verify(() => handler.next(requestOptions)).called(1);
  });
}

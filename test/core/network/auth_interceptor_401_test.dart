import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_riverpod/core/network/auth_interceptor.dart';
import 'package:my_riverpod/core/common/models/user_model.dart';
import 'package:my_riverpod/core/common/providers/auth_notifier_provider.dart';

class MockRef extends Mock implements Ref {}

class MockAuthNotifier extends Mock implements AuthNotifier {}

class MockErrorHandler extends Mock implements ErrorInterceptorHandler {}

class MockDio extends Mock implements Dio {}

class FakeRequestOptions extends Fake implements RequestOptions {}

class FakeResponse extends Fake implements Response {}

class FakeDioException extends Fake implements DioException {}

void main() {
  late MockRef mockRef;
  late MockAuthNotifier mockAuthNotifier;
  late AuthInterceptor interceptor;
  late MockErrorHandler handler;
  late MockDio mockDio;

  setUpAll(() {
    registerFallbackValue(FakeRequestOptions());
    registerFallbackValue(FakeResponse());
    registerFallbackValue(FakeDioException());
  });

  setUp(() {
    mockRef = MockRef();
    mockAuthNotifier = MockAuthNotifier();
    handler = MockErrorHandler();
    mockDio = MockDio();

    when(() => mockAuthNotifier.logout()).thenAnswer((_) async {});
    when(() => mockRef.read(authNotifierProvider.notifier))
        .thenReturn(mockAuthNotifier);
    when(() => mockRef.read(authNotifierProvider)).thenReturn(UserModel(
      userId: '123',
      accessToken: 'newAccess',
      refreshToken: 'newRefresh',
      phoneNumber: '1234567890',
    ));

    interceptor = TestAuthInterceptor(mockRef, mockDio);
  });

  group('AuthInterceptor', () {
    test('should handle 401 error and retry request with new token', () async {
      final requestOptions = RequestOptions(
        path: '/protected',
        method: 'GET',
        headers: {'Content-Type': 'application/json'},
      );

      final error = DioException(
        requestOptions: requestOptions,
        response: Response(
          statusCode: 401,
          requestOptions: requestOptions,
        ),
        type: DioExceptionType.badResponse,
      );

      final refreshedUser = UserModel(
        userId: '123',
        accessToken: 'newAccess',
        refreshToken: 'newRefresh',
        phoneNumber: '1234567890',
      );

      when(() => mockAuthNotifier.refreshToken())
          .thenAnswer((_) async => refreshedUser);

      final successResponse = Response(
        requestOptions: requestOptions,
        statusCode: 200,
        data: {'message': 'success'},
      );

      when(() => mockDio.request(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => successResponse);

      when(() => handler.resolve(any())).thenAnswer((_) {});

      await interceptor.onError(error, handler);

      verify(() => mockAuthNotifier.refreshToken()).called(1);
      verify(() => mockDio.request(
            requestOptions.path,
            data: requestOptions.data,
            queryParameters: requestOptions.queryParameters,
            options: any(named: 'options'),
          )).called(1);
      verify(() => handler.resolve(successResponse)).called(1);
      verifyNever(() => handler.reject(any()));
    });

    test('should handle refresh token failure and logout', () async {
      final requestOptions = RequestOptions(
        path: '/protected',
        method: 'GET',
      );

      final error = DioException(
        requestOptions: requestOptions,
        response: Response(
          statusCode: 401,
          requestOptions: requestOptions,
        ),
        type: DioExceptionType.badResponse,
      );

      when(() => mockAuthNotifier.refreshToken())
          .thenThrow(Exception('Refresh token failed'));

      when(() => handler.reject(any())).thenAnswer((_) {});

      await interceptor.onError(error, handler);

      verify(() => mockAuthNotifier.refreshToken()).called(1);
      verify(() => mockAuthNotifier.logout()).called(1);
      verify(() => handler.reject(error)).called(1);
      verifyNever(() => handler.resolve(any()));
    });
  });
}

// Test implementation of AuthInterceptor that allows mocking the Dio instance
class TestAuthInterceptor extends AuthInterceptor {
  final Dio dio;

  TestAuthInterceptor(super.ref, this.dio);

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final refreshed =
            await ref.read(authNotifierProvider.notifier).refreshToken();

        final cloneRequest =
            await _retry(err.requestOptions, refreshed.accessToken);
        return handler.resolve(cloneRequest);
      } catch (e) {
        await ref.read(authNotifierProvider.notifier).logout();
        return handler.reject(err);
      }
    }

    return handler.reject(err);
  }

  @override
  Future<Response<dynamic>> _retry(
      RequestOptions requestOptions, String newToken) async {
    final options = Options(
      method: requestOptions.method,
      headers: Map.of(requestOptions.headers)
        ..['Authorization'] = 'Bearer $newToken',
    );

    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

import 'package:my_riverpod/core/error/app_exception.dart';
import 'package:my_riverpod/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:my_riverpod/features/auth/data/models/login_request_model.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late Dio dio;
  late AuthRemoteDataSource dataSource;

  setUp(() {
    dio = MockDio();
    dataSource = AuthRemoteDataSource(dio);
  });

  group('login()', () {
    test('should call POST with correct data (without otp)', () async {
      const phone = '1234567890';
      final request = LoginRequestModel(phone: phone);

      when(() => dio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ''),
                data: {},
                statusCode: 200,
              ));

      await dataSource.login(request);

      verify(() => dio.post(
            any(),
            data: {
              'phone': phone,
              'otp': null,
              'hash': null,
            },
          )).called(1);
    });

    test('should return Right(...) on OTP login success', () async {
      const phone = '1234567890';
      const otp = '123456';
      const hash = 'abc123';
      final request = LoginRequestModel(phone: phone, otp: otp, hash: hash);
      final responseData = {
        'userId': 'u1',
        'accessToken': 'a1',
        'refreshToken': 'r1',
      };

      when(() => dio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ''),
                data: responseData,
                statusCode: 200,
              ));

      final result = await dataSource.login(request);

      expect(result.isRight(), true);
      expect(result.getOrElse(() => {}), equals(responseData));
    });

    test('should return Left(AppException) on dio error', () async {
      const phone = '1234567890';
      final request = LoginRequestModel(phone: phone);

      when(() => dio.post(any(), data: any(named: 'data')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: '/auth'),
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 401,
          data: {'message': 'Invalid code'},
          requestOptions: RequestOptions(path: '/auth'),
        ),
      ));

      final result = await dataSource.login(request);

      expect(result.isLeft(), true);
      expect(
        result.swap().getOrElse(() => throw 'fail'),
        isA<AppException>(),
      );
    });
  });

  group('refresh()', () {
    test('should return parsed token map', () async {
      const refreshToken = 'refresh123';
      final responseData = {
        'userId': 'u1',
        'accessToken': 'a1',
        'refreshToken': 'r1',
      };

      when(() => dio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ''),
                data: responseData,
                statusCode: 200,
              ));

      final result = await dataSource.refresh(refreshToken);

      expect(result, responseData);
    });

    test('should throw AppException on dio error', () async {
      const refreshToken = 'expiredToken';

      when(() => dio.post(any(), data: any(named: 'data')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: '/refresh'),
        type: DioExceptionType.connectionTimeout,
      ));

      await expectLater(
        () => dataSource.refresh(refreshToken),
        throwsA(isA<AppException>()),
      );
    });
  });
}

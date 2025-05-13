import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:my_riverpod/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:my_riverpod/features/auth/data/models/login_data_model.dart';
import 'package:my_riverpod/features/auth/data/models/login_request_model.dart';
import 'package:my_riverpod/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:my_riverpod/core/error/app_exception.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late MockAuthRemoteDataSource mockRemote;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockRemote = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(mockRemote);
  });

  test('login() should call remote.login with phone only', () async {
    const phone = '1234567890';
    final request = LoginRequestModel(phone: phone);

    when(() => mockRemote.login(request))
        .thenAnswer((_) async => Right(<String, dynamic>{}));

    await repository.login(phone);

    verify(() => mockRemote.login(request)).called(1);
  });

  test('verifyOtp() should return Right(LoginDataModel)', () async {
    const phone = '1234567890';
    const otp = '123456';
    const hash = 'abc123';
    final request = LoginRequestModel(phone: phone, otp: otp, hash: hash);

    final mockResponse = {
      'userId': 'u1',
      'accessToken': 'a1',
      'refreshToken': 'r1',
    };

    when(() => mockRemote.login(request))
        .thenAnswer((_) async => Right(mockResponse));

    final result = await repository.verifyOTP(phone, otp, hash);

    expect(result.isRight(), true);
    expect(
      result.getOrElse(() => throw 'fail'),
      LoginDataModel.fromJson(mockResponse),
    );
  });

  test('refreshToken() should return parsed LoginDataModel', () async {
    const token = 'refresh123';
    final mockResponse = {
      'userId': 'u1',
      'accessToken': 'a1',
      'refreshToken': 'r1',
    };

    when(() => mockRemote.refresh(token)).thenAnswer((_) async => mockResponse);

    final result = await repository.refreshToken(token);

    expect(result, LoginDataModel.fromJson(mockResponse));
  });

  test('verifyOtp() should return Left(AppException) on failure', () async {
    const phone = '1234567890';
    const otp = '000000';
    const hash = 'bad-hash';
    final request = LoginRequestModel(phone: phone, otp: otp, hash: hash);

    final error = AppException.server('Invalid OTP');

    when(() => mockRemote.login(request)).thenAnswer((_) async => Left(error));

    final result = await repository.verifyOTP(phone, otp, hash);

    expect(result.isLeft(), true);
    expect(result.swap().getOrElse(() => throw 'fail'), equals(error));
  });
}

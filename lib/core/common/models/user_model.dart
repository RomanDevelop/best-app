import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String userId,
    required String accessToken,
    required String refreshToken,
    required String phoneNumber,
  }) = _UserModel;
}

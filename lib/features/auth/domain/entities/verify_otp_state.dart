import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_otp_state.freezed.dart';

@freezed
class VerifyOtpState with _$VerifyOtpState {
  const factory VerifyOtpState({
    @Default(false) bool isLoading,
    String? error,
    Object? data,
  }) = _VerifyOtpState;
}

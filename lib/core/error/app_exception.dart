import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_exception.freezed.dart';

@freezed
class AppException with _$AppException {
  const factory AppException.server(String message) = ServerException;
  const factory AppException.network(String message) = NetworkException;
  const factory AppException.unknown(String message) = UnknownException;

  factory AppException.from(Object error) {
    // Здесь ты можешь обрабатывать любые исключения, например:
    if (error.toString().contains('SocketException')) {
      return const AppException.network('Network error');
    }

    return AppException.unknown(error.toString());
  }
}

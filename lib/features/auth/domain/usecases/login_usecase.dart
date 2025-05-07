import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_riverpod/features/auth/data/repositories_impl/auth_repository_impl.dart';

import '../repositories/auth_repository.dart';

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return LoginUseCase(repo);
});

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<void> execute(String phone) {
    return repository.login(phone);
  }
}

// final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
//   final dio = Dio(); // временно — позже подключим api_client
//   final dataSource = AuthRemoteDataSource(dio);
//   final repository = AuthRepositoryImpl(dataSource);
//   return LoginUseCase(repository);
// });

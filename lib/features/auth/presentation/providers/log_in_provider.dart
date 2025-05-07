import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_riverpod/features/auth/domain/entities/log_in_state.dart';
import 'package:my_riverpod/features/auth/domain/usecases/login_usecase.dart';

final loginProvider = NotifierProvider<LoginNotifier, LogInState>(
  () => LoginNotifier(),
);

class LoginNotifier extends Notifier<LogInState> {
  @override
  LogInState build() => const LogInState();

  Future<void> login(String phone) async {
    state = state.copyWith(isLoading: true, error: null, data: null);

    try {
      final useCase = ref.read(loginUseCaseProvider);
      await useCase.execute(phone);
      state = state.copyWith(isLoading: false, data: 'OK');
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

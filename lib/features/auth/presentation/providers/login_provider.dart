import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_riverpod/features/auth/domain/entities/login_state.dart';
import 'package:my_riverpod/features/auth/domain/usecases/login_usecase.dart';

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  Future<void> login(String phone) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final useCase = ref.read(loginUseCaseProvider);
      await useCase.execute(phone);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final loginProvider =
    NotifierProvider<LoginNotifier, LoginState>(() => LoginNotifier());

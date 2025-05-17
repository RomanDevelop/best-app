import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_riverpod/features/home/domain/providers/home_usecase_provider.dart';
import '../../data/models/home_model.dart';

final homeNotifierProvider =
    NotifierProvider<HomeNotifier, AsyncValue<List<HomeModel>>>(
  () => HomeNotifier(),
);

class HomeNotifier extends Notifier<AsyncValue<List<HomeModel>>> {
  @override
  AsyncValue<List<HomeModel>> build() => const AsyncLoading();

  Future<void> getHomeData() async {
    final usecase = ref.read(homeUseCaseProvider);

    state = const AsyncLoading();

    try {
      final data = await usecase.execute();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

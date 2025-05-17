import '../../data/models/home_model.dart';
import '../repositories/home_repository.dart';

class HomeUseCase {
  final HomeRepository repository;

  HomeUseCase(this.repository);

  Future<List<HomeModel>> execute() {
    return repository.getHomeData();
  }
}

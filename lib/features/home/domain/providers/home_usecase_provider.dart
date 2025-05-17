import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_riverpod/core/network/dio_provider.dart';
import '../usecases/home_usecase.dart';
import '../repositories/home_repository.dart';
import '../../data/repositories_impl/home_repository_impl.dart';

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => HomeRepositoryImpl(ref.read(dioProvider)),
);

final homeUseCaseProvider = Provider<HomeUseCase>(
  (ref) => HomeUseCase(ref.read(homeRepositoryProvider)),
);

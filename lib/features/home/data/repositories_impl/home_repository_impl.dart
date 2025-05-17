import 'package:dio/dio.dart';

import '../../domain/repositories/home_repository.dart';
import '../models/home_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final Dio dio;

  HomeRepositoryImpl(this.dio);

  @override
  Future<List<HomeModel>> getHomeData() async {
    try {
      final response = await dio.get('/home');

      final data = response.data as List;

      return data.map((json) => HomeModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

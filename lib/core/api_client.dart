import 'package:dio/dio.dart';

final apiClient = Dio(BaseOptions(
  baseUrl: 'https://your-api-url.com', // поставь свой
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
  headers: {
    'Content-Type': 'application/json',
  },
));

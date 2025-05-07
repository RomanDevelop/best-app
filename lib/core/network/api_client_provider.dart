import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_riverpod/core/api_client.dart';

final apiClientProvider = Provider<Dio>((ref) => apiClient);

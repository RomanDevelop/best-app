import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'token_storage_service.dart';

final tokenStorageServiceProvider = Provider<TokenStorageService>(
  (ref) => TokenStorageService(),
);

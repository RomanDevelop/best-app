import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_riverpod/core/services/token_storage_service_imp.dart';

import 'token_storage_service.dart';

final tokenStorageServiceProvider = Provider<TokenStorageService>(
  (ref) => TokenStorageServiceImpl(const FlutterSecureStorage()),
);

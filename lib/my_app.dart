import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/app_theme.dart';
import 'config/router/app_router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Riverpod Best Practice',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // это мы сейчас тоже создадим
      routerConfig: router,
    );
  }
}

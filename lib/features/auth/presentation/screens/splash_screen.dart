import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/common/providers/auth_notifier_provider.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeSession();
  }

  void _initializeSession() async {
    await ref.read(authNotifierProvider.notifier).init();
    final user = ref.read(authNotifierProvider);

    if (user == null) {
      context.go('/login');
    } else {
      context.go('/home');
    }
  }

  // void _checkAuth() async {
  //   await Future.delayed(const Duration(seconds: 2)); // splash delay

  //   final user = ref.read(authNotifierProvider);
  //   if (user == null) {
  //     context.go('/login');
  //   } else {
  //     context.go('/home'); // позже подключим домашний экран
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

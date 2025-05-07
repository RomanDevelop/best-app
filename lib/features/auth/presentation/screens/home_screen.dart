import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/common/providers/auth_notifier_provider.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("No user found")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text("User ID: ${user.userId}"),
            Text("Phone: ${user.phoneNumber}"),
            Text("Access Token: ${user.accessToken}"),
            const SizedBox(height: 20),
            const Text(
              "Это ваш личный кабинет. Здесь можно добавить функционал профиля, заказов, подписок и прочего.",
            ),
          ],
        ),
      ),
    );
  }
}

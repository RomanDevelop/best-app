import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:my_riverpod/core/common/providers/auth_notifier_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);
    final notifier = ref.read(authNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await notifier.logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: Center(
        child: user == null
            ? const Text('No user data')
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('User ID: ${user.userId}'),
                  Text('Phone: ${user.phoneNumber}'),
                ],
              ),
      ),
    );
  }
}

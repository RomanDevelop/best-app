import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_riverpod/features/auth/presentation/providers/verify_otp_provider.dart';

class OtpScreen extends ConsumerWidget {
  final String phone;
  final String hash;

  const OtpScreen({
    super.key,
    required this.phone,
    required this.hash,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    final state = ref.watch(verifyOtpProvider);
    final notifier = ref.read(verifyOtpProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('We sent a code to $phone'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Enter OTP'),
            ),
            const SizedBox(height: 20),
            state.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      await notifier.verifyOTP(phone, controller.text, hash);
                      if (state.error == null) {
                        context.go('/home');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.error!)),
                        );
                      }
                    },
                    child: const Text('Verify'),
                  ),
          ],
        ),
      ),
    );
  }
}

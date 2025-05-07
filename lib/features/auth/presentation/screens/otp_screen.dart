import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_riverpod/features/auth/presentation/providers/verify_otp_provider.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  final phone = '1234567890'; // заменить на передаваемый из Login

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(verifyOtpProvider);
    final notifier = ref.read(verifyOtpProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("OTP Verification")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: otpController,
              decoration: const InputDecoration(labelText: "Enter OTP"),
            ),
            const SizedBox(height: 20),
            if (state.isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: () {
                  notifier.verifyOTP(
                    phone,
                    otpController.text,
                    'hash123', // пока захардкожено
                  );
                },
                child: const Text("Verify"),
              ),
            if (state.error != null) ...[
              const SizedBox(height: 20),
              Text(state.error!, style: const TextStyle(color: Colors.red)),
            ]
          ],
        ),
      ),
    );
  }
}

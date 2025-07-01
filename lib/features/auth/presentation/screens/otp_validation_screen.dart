import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_providers.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';

class OtpValidationScreen extends ConsumerStatefulWidget {
  final String email;

  const OtpValidationScreen({super.key, required this.email});

  @override
  ConsumerState<OtpValidationScreen> createState() => _OtpValidationScreenState();
}

class _OtpValidationScreenState extends ConsumerState<OtpValidationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  Timer? _resendTimer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _remainingSeconds = 60;
    });

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  void _resendOtp() {
    if (_remainingSeconds == 0) {
      ref.read(forgotPasswordFormStateProvider.notifier).forgotPassword(widget.email);
      _startResendTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP code has been resent to your email'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _validateOtp() {
    if (_formKey.currentState!.validate()) {
      ref.read(validateOtpFormStateProvider.notifier).validateOtp(
        widget.email,
        _otpController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final validateOtpFormState = ref.watch(validateOtpFormStateProvider);
    final isLoading = validateOtpFormState is AsyncLoading<String?>;

    ref.listen<AsyncValue<String?>>(validateOtpFormStateProvider, (_, state) {
      state.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        },
        data: (token) {
          if (token != null) {
            context.go('/reset-password', extra: {
              'email': widget.email,
              'token': token,
            });
          }
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Validation'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.lock_clock,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ).animate().fadeIn().scale(),
                  const SizedBox(height: 32),
                  Text(
                    'Enter OTP',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 16),
                  Text(
                    'Please enter the OTP code sent to your email\n${widget.email}',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 32),
                  AuthTextField(
                    controller: _otpController,
                    label: 'OTP Code',
                    hint: 'Enter the OTP code',
                    icon: Icons.lock_outline,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the OTP code';
                      }
                      if (value.length != 6) {
                        return 'OTP code must be 6 digits';
                      }
                      return null;
                    },
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 32),
                  AuthButton(
                    label: 'Verify OTP',
                    onPressed: isLoading ? null : _validateOtp,
                    isLoading: isLoading,
                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 24),
                  Column(
                    children: [
                      TextButton(
                        onPressed: _remainingSeconds == 0 ? _resendOtp : null,
                        child: Text(
                          _remainingSeconds > 0
                              ? 'Resend OTP (${_remainingSeconds}s)'
                              : 'Resend OTP',
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.go('/forgot-password');
                        },
                        child: const Text('Use Different Email'),
                      ),
                    ],
                  ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 
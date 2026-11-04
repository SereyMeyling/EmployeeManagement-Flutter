import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(Icons.badge_rounded, size: 72, color: scheme.primary),
                    const SizedBox(height: 12),
                    Text('Employee Manager',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Sign in to continue',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: scheme.outline)),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: controller.phoneCtrl,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Phone number',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Phone number is required' : null,
                    ),
                    const SizedBox(height: 16),
                    Obx(() => TextFormField(
                          controller: controller.passCtrl,
                          obscureText: controller.obscure.value,
                          onFieldSubmitted: (_) => controller.login(),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(controller.obscure.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined),
                              onPressed: () =>
                                  controller.obscure.value = !controller.obscure.value,
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Password is required';
                            if (v.length < 6) return 'At least 6 characters';
                            return null;
                          },
                        )),
                    const SizedBox(height: 24),
                    Obx(() => FilledButton(
                          onPressed: controller.isLoading.value ? null : controller.login,
                          style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16)),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2))
                              : const Text('Login'),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

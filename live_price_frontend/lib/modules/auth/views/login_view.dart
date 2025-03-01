import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/modules/auth/controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Live Price Admin',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: controller.usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Kullanıcı Adı',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kullanıcı adı gerekli';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controller.passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Şifre',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Şifre gerekli';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller.login(),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Giriş Yap'),
                      ),
                    ),
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

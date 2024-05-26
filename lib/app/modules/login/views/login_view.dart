import 'package:evital/app/modules/login/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final LoginController loginController = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _mobileController,
                decoration: const InputDecoration(labelText: 'Mobile'),
                keyboardType: TextInputType.phone,
                validator: (value) => loginController.validateMobile(value!),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => loginController.validatePassword(value!),
              ),
              const SizedBox(height: 20),
              Obx(() => loginController.isLoading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          String mobile = _mobileController.text;
                          String password = _passwordController.text;
                          loginController.login(mobile, password);
                        }
                      },
                      child: const Text('Login'),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}

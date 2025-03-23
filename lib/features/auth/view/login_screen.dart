import 'package:chattingapp/core/routes.dart';
import 'package:chattingapp/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: GetBuilder<AuthController>(
        builder: (ctrl) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Email", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 6),
              Container(
                decoration: boxStyle(),
                child: TextField(
                  controller: ctrl.emailTextEditingController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: inputStyle(ctrl.emailError),
                ),
              ),
              const SizedBox(height: 16),

              const Text("Password", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 6),
              Container(
                decoration: boxStyle(),
                child: TextField(
                  controller: ctrl.passwordTextEditingController,
                  obscureText: true,
                  decoration: inputStyle(ctrl.passwordError),
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => ctrl.performLogin(context, ctrl),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Login", style: TextStyle(fontSize: 16)),
                ),
              ),
              TextButton(
                onPressed: () => Get.offNamed(Routes.registerView),
                child: const Text("Don't have an account? Register"),
              )
            ],
          ),
        ),
      ),
    );
  }


  BoxDecoration boxStyle() {
    return BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          blurRadius: 8,
          offset: const Offset(2, 4),
        ),
      ],
    );
  }

  InputDecoration inputStyle(String? errorText) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.transparent,
      errorText: errorText?.isNotEmpty == true ? errorText : null,
    );
  }
}

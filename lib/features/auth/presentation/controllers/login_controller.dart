import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inten/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:inten/features/auth/domain/usecases/login_usecase.dart';

class LoginController extends GetxController {
  final LoginUseCase loginUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;

  LoginController({
    required this.loginUseCase,
    required this.forgotPasswordUseCase,
  });

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  // Email Validation Regex
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid Gmail / Email address';
    }
    return null;
  }

  // Password Validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Login Function
  Future<void> submitLogin() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      final user = await loginUseCase(
        emailController.text.trim(),
        passwordController.text,
      );

      // Centered Success Dialog
      await Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.arrow_right, color: Colors.orange, size: 28),
              SizedBox(width: 10),
              Text('Success!'),
            ],
          ),
          content: Text('Logged in successfully as ${user.email}'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Get.back(); // Close dialog
                // Get.offAllNamed(Routes.HOME); // Navigate to Home
              },
              child: const Text('OK',),
            ),
          ],
        ),
        barrierDismissible: false,
      );

    } catch (e) {
      // Centered Error Dialog
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.redAccent, size: 28),
              SizedBox(width: 10),
              Text('Login Failed'),
            ],
          ),
          content: Text(e.toString().replaceAll('Exception: ', '')),
          actions: [
            TextButton(
              onPressed: () => Get.back(), // Close dialog
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Forgot Password Action
  Future<void> handleForgotPassword() async {
    final email = emailController.text.trim();

    // Validation Check Dialog
    if (validateEmail(email) != null) {
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
              SizedBox(width: 10),
              Text('Email Required'),
            ],
          ),
          content: const Text('Please enter a valid email address first to reset password.'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      isLoading.value = true;
      await forgotPasswordUseCase(email);

      // Success Dialog
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.mark_email_read, color: Colors.blue, size: 28),
              SizedBox(width: 10),
              Text('Reset Link Sent'),
            ],
          ),
          content: Text('A password reset link has been sent to $email'),
          actions: [
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Error Dialog
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.redAccent, size: 28),
              SizedBox(width: 10),
              Text('Error'),
            ],
          ),
          content: const Text('Could not send reset email.'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
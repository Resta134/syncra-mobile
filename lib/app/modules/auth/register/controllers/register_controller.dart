import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  //TODO: Implement RegisterController
 
  void goToLogin() {
    Get.toNamed('/login');
  }

final passwordC = TextEditingController();
 Future<void> goRegisterSuccess() async {
  final password = passwordC.text.trim();

  // VALIDASI PASSWORD
  if (password == '123' || password.length < 6) {
    Get.snackbar(
      'Registration Failed',
      'Password must be at least 6 characters',
      backgroundColor: Colors.red.shade400,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      icon: const Icon(
        Icons.error_outline,
        color: Colors.white,
      ),
      duration: const Duration(seconds: 3),
    );

    return;
  }

  // LOADING
  Get.dialog(
    Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const CircularProgressIndicator(),
      ),
    ),
    barrierDismissible: false,
  );

  await Future.delayed(const Duration(seconds: 2));

  Get.back();

  // SUCCESS CHECK
  Get.dialog(
    Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 21,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Registration Successful',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );

  await Future.delayed(
    const Duration(milliseconds: 1500),
  );

  Get.back();
  Get.offAllNamed('/login');
}
}

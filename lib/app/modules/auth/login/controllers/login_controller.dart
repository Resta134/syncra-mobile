import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController

  void goToSignUp() {
    Get.toNamed('/register');
  }

  final TextEditingController usernameC = TextEditingController();

  Future<void> goToHome() async {
    Get.dialog(
      Center(child: CircularProgressIndicator(color: Colors.white)),
      barrierDismissible: false,
    );

    await Future.delayed(Duration(seconds: 2));

    // Ambil text dari TextField
    final username = usernameC.text.trim();

    // Cek role/login
    if (username == 'speaker') {
      // Arahkan pemateri ke Dashboard Speaker (Portal/Lobi) terlebih dahulu
      Get.offAllNamed('/dashboard-speak');
    } else if (username == 'moderator') {
      // Arahkan moderator ke Dashboard Moderator
      Get.offAllNamed('/dashboard-mod');
    } else if (username == 'gatekeeper') {
      // Arahkan peserta biasa ke Dashboard umum
      Get.offAllNamed('/dashboard-gatekeeper');
    } else {
      Get.offAllNamed('/dashboard');
    }
  }

}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart'; // Import relatif otomatis menyesuaikan folder auth

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller di dalam folder auth/splash
    Get.put(SplashController());

    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih bersih
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Gambar Logo Utama (logo.png)
            Image.asset(
              'assets/images/logo_syncro.png',
              height: 100,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.api_rounded, size: 100, color: Colors.blueAccent
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 2. Gambar Tulisan Merek (syncro.png)
            Image.asset(
              'assets/images/syncroo.png',
              height: 40,
              errorBuilder: (context, error, stackTrace) => const Text(
                "SYNCRA AI",
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.w900, 
                  color: Colors.blueAccent,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
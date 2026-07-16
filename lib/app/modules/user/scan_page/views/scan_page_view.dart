import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import '../controllers/scan_page_controller.dart';
import 'scanner_overlay.dart'; 

class ScanPageView extends GetView<ScanPageController> {
  const ScanPageView({super.key});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: const Color(0xFF051424), // Background gelap dari desain
      appBar: AppBar(
        backgroundColor: const Color(0xFF051424),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF89CEFF), size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Camera Scan",
          style: TextStyle(
            color: Color(0xFF89CEFF),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on, color: Color(0xFF89CEFF)),
            onPressed: () {
              // Logika nyalakan flash opsional
            },
          ),
        ],
      ),
      body: Obx(() {
        if (!controller.isCameraInitialized.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF89CEFF)),
          );
        }

        final cameraRatio = controller.cameraController.value.aspectRatio;

        return Stack(
          children: [
            // 1. Kamera Proporsional di Background
            Center(
              child: AspectRatio(
                aspectRatio: 1 / cameraRatio,
                child: CameraPreview(controller.cameraController),
              ),
            ),

            // 2. Chip Status "Scanning in progress..."
            Positioned(
              top: 30, // Jarak dari AppBar
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF010f1f).withOpacity(0.8), // Glassmorphism dark
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF00dbe7).withOpacity(0.5), 
                      width: 1.5
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Titik berkedip/indikator
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00dbe7),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Scanning in progress...",
                        style: TextStyle(
                          color: Color(0xFF00dbe7),
                          fontFamily: 'JetBrains Mono',
                          fontSize: 14,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 3. Overlay Brackets & Animasi Garis
            const Center(
              child: ScannerOverlay(
                width: 280,
                height: 280,
              ),
            ),
          ],
        );
      }),
    );
  }
}
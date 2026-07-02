import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:tranlator_v1/app/modules/user/scan_page/views/scanner_overlay.dart';

import '../controllers/face_vertivication_controller.dart';

class FaceVertivicationView extends GetView<FaceVertivicationController> {
  const FaceVertivicationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF051424,
      ), // Background gelap dari desain Informatics Precision
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF89CEFF)),
          onPressed: () => controller.dashboard(),
        ),
        title: const Text(
          'Gatekeeper Verification',
          style: TextStyle(
            color: Color(0xFF89CEFF),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.help_outline_rounded,
              color: Color(0xFF89CEFF),
            ),
            onPressed: () {
              Get.snackbar(
                'Bantuan',
                'Posisikan wajah pengunjung di dalam kotak scanner.',
                backgroundColor: const Color(0xFF010f1f).withOpacity(0.8),
                colorText: Colors.white,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // TEKS INSTRUKSI ATAS
            const Text(
              'Please position the face clearly within\nthe frame below to complete\nattendance check-in.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFbec8d2), // on-surface-variant
                height: 1.4,
              ),
            ),

            const Spacer(),

            // AREA SCAN MUKA REAL-TIME DENGAN OVERLAY SIKU-SIKU
            // Di dalam body, pada bagian Stack CameraPreview:
            // AREA SCAN MUKA REAL-TIME DENGAN OVERLAY SIKU-SIKU
            // Ganti bagian Stack CameraPreview di FaceVertivicationView dengan ini:
            SizedBox(
              width: 320,
              height: 320,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      10,
                    ), // Lingkaran sempurna
                    child: Obx(() {
                      if (!controller.isCameraInitialized.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF89CEFF),
                          ),
                        );
                      }
                      return FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: controller
                              .cameraController
                              .value
                              .previewSize!
                              .height,
                          height: controller
                              .cameraController
                              .value
                              .previewSize!
                              .width,
                          child: CameraPreview(controller.cameraController),
                        ),
                      );
                    }),
                  ),
                  const ScannerOverlay(width: 320, height: 320),
                ],
              ),
            ),
            const Spacer(),

            // AREA TOMBOL BAWAH
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // 1. Status Info (Biru Cyan)
                  const SizedBox(height: 16),

                  // 2. Tombol Manual QR Scan (Putih/Ghost Style)
                  // Ganti bagian Column tombol bawah dengan ini:
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        // Indikator Status (Tetap informatif)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF010f1f),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '🔄 Scanning face...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF89CEFF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Tombol Utama (Manual QR Scan)
                        ElevatedButton.icon(
                          onPressed: () => controller.qr(),
                          icon: const Icon(Icons.qr_code_scanner_rounded),
                          label: const Text('Manual QR Scan'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: const Color(0xFF89CEFF),
                            foregroundColor: const Color(0xFF010f1f),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // TEKS LAPORAN ISSUE BAWAH
                  InkWell(
                    onTap: () {
                      // controller.report();
                    },
                    child: const Text(
                      'Report Verification Issue',
                      style: TextStyle(
                        color: Color(0xFF88929b), // outline color
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

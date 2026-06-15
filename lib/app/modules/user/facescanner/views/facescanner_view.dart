import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/facescanner_controller.dart';

class FaceScannerView extends GetView<FaceScannerController> {
  const FaceScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background hitam agar fokus
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Registrasi Wajah', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Obx(() {
        // Jika kamera belum siap, tampilkan loading premium
        if (!controller.isCameraInitialized.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
        }

        // --- SOLUSI MUKA LONJONG: Pakai AspectRatio ---
        // Ambil perbandingan asli dari kamera controller
        final cameraAspectRatio = controller.cameraController!.value.aspectRatio;

        return Stack(
          alignment: Alignment.center,
          children: [
            // 1. Tampilan Kamera Latar Belakang (Dibuat PROPORSIONAL)
            Center(
              child: AspectRatio(
                aspectRatio: 1 / cameraAspectRatio, // Dibalik karena portrait
                child: CameraPreview(controller.cameraController!),
              ),
            ),

            // 2. Overlay Masking Premium (Latar Belakang Gelap Berlubang)
            ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.srcOut),
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(color: Colors.black, backgroundBlendMode: BlendMode.dstOut),
                  ),
                  // LINGKARAN LUBANG TENGAH (Pemasangan Warna yang Benar)
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 320,
                      width: 320,
                      decoration: BoxDecoration(
                        color: Colors.red, // Warna ini jadi transparan, bukan lubang
                        borderRadius: BorderRadius.circular(160),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 3. Garis Frame Scanner Animasi & Instruksi
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Garis Pinggir Biru Neon
                Container(
                  height: 320,
                  width: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blueAccent.withOpacity(0.5), width: 3),
                  ),
                ),
                const SizedBox(height: 50),
                
                // Teks Instruksi Dinamis
                Obx(() => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: controller.hasBlinked.value ? Colors.green.withOpacity(0.8) : Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white10)
                  ),
                  child: Text(
                    controller.instructionText.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                )),
              ],
            ),
          ],
        );
      }),
    );
  }
}
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/qr_scanner_controller.dart';

class QrScannerView extends GetView<QrScannerController> {
  const QrScannerView({super.key});
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      // Background gelap premium selaras dengan mockup
      backgroundColor: const Color(0xFF1A1C24),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Scan Ticket QR',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              const Spacer(),

              // ==========================================
              // AREA FRAME KOTAK QR SCANNER + GARIS LASER
              // ==========================================
              Stack(
                alignment: Alignment.center,
                children: [
                  // Kotak Scanner
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05), // Dummy feed kamera gelap
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.blue.shade700,
                        width: 3.0, // Aksentuasi border biru
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.15),
                          blurRadius: 15,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                  ),
                  
                  // Sudut penanda kotak (Aksen siku-siku biru)
                  Positioned(
                    top: 12, left: 12,
                    child: _buildCornerAccent(),
                  ),
                  Positioned(
                    top: 12, right: 12,
                    child: RotatedBox(quarterTurns: 1, child: _buildCornerAccent()),
                  ),
                  Positioned(
                    bottom: 12, right: 12,
                    child: RotatedBox(quarterTurns: 2, child: _buildCornerAccent()),
                  ),
                  Positioned(
                    bottom: 12, left: 12,
                    child: RotatedBox(quarterTurns: 3, child: _buildCornerAccent()),
                  ),

                  // Garis Laser Scan Biru
                  Container(
                    width: 260,
                    height: 3,
                    color: Colors.blue.shade400,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // TEKS INSTRUKSI BAWAH KOTAK
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Align QR code within the frame to scan\nautomatically',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ),

              const Spacer(),

              // ==========================================
              // AREA TOMBOL BAWAH
              // ==========================================
              
              // 1. Tombol Switch to Face Scan (Background Putih)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                   controller.vermuk();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.face_retouching_natural, color: Colors.blue.shade700, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        'Switch to Face Scan',
                        style: TextStyle(color: Colors.blue.shade700, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),

              // 2. Tombol Manual Name Search (Outlined / Gelap)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Arahkan ke halaman pencarian nama manual
                    Get.snackbar('Manual Search', 'Membuka daftar pencarian nama peserta...');
                    controller.goToValidation();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white54, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, color: Colors.white, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Manual Name Search',
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Widget kecil untuk membuat sudut L di tiap pojok frame
  Widget _buildCornerAccent() {
    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.blue, width: 4),
          left: BorderSide(color: Colors.blue, width: 4),
        ),
      ),
    );
  }
}

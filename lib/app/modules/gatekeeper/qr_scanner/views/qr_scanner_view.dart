import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // Pastikan package ini terinstall
import '../controllers/qr_scanner_controller.dart';

class QrScannerView extends GetView<QrScannerController> {
  const QrScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Camera Preview sebagai Background
          MobileScanner(
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                controller.handleQrResult(barcode.rawValue ?? "");
              }
            },
          ),

          // 2. Overlay Gelap di luar frame scanner
          ColorFiltered(
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.srcOut),
            child: Stack(
              children: [
                Container(decoration: const BoxDecoration(color: Colors.black, backgroundBlendMode: BlendMode.dstOut)),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 280,
                    height: 280,
                  ),
                ),
              ],
            ),
          ),

          // 3. UI Frame & Instruksi (di atas kamera)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildAppBar(),
                  const Spacer(),
                  _buildScannerFrame(),
                  const SizedBox(height: 30),
                  const Text(
                    'Posisikan QR dalam kotak untuk scan',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const Spacer(flex: 2),
                  _buildActionButtons(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() => Row(
    children: [
      IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      const Expanded(child: Text("Scan QR Tiket", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
      const SizedBox(width: 48), // Spacer untuk keseimbangan
    ],
  );

  Widget _buildScannerFrame() => Stack(
    alignment: Alignment.center,
    children: [
      Container(width: 280, height: 280, decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.blue.shade400, width: 2))),
      // Sudut L
      ...List.generate(4, (index) => Positioned(
        top: index < 2 ? 0 : null, bottom: index >= 2 ? 0 : null,
        left: index == 0 || index == 3 ? 0 : null, right: index == 1 || index == 2 ? 0 : null,
        child: Container(width: 40, height: 40, decoration: BoxDecoration(border: Border(top: index < 2 ? const BorderSide(color: Colors.blue, width: 5) : BorderSide.none, left: index == 0 || index == 3 ? const BorderSide(color: Colors.blue, width: 5) : BorderSide.none, bottom: index >= 2 ? const BorderSide(color: Colors.blue, width: 5) : BorderSide.none, right: index == 1 || index == 2 ? const BorderSide(color: Colors.blue, width: 5) : BorderSide.none))),
      )),
    ],
  );

  Widget _buildActionButtons() => Column(
    children: [
      ElevatedButton.icon(
        onPressed: () => controller.vermuk(),
        icon: const Icon(Icons.face_retouching_natural),
        label: const Text("Ganti ke Face Scan"),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.blue.shade900, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
      ),
      const SizedBox(height: 15),
      OutlinedButton.icon(
        onPressed: () => controller.goToValidation(),
        icon: const Icon(Icons.search, color: Colors.white),
        label: const Text("Cari Nama Manual", style: TextStyle(color: Colors.white)),
        style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white54), minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
      ),
    ],
  );
}
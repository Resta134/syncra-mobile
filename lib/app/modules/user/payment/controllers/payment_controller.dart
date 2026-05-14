import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  //TODO: Implement PaymentController

  final countPayment = {
    'count':'Rp.200.000'
  }
   .obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }
  void processSuccessPayment() {
  print("berhasil membayar...");

  // 1. Tampilkan Dialog Sukses di Tengah Layar
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ukuran kotak menyesuaikan isi
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              "Payment Successful!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Redirecting to Face Registration...",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false, // User tidak bisa menutup dialog dengan klik area luar
  );

  // 2. Tunggu 2 detik, tutup dialog, lalu navigasi
  Future.delayed(const Duration(seconds: 2), () {
    // Tutup dialog terlebih dahulu agar tidak meninggalkan *memory leak*
    if (Get.isDialogOpen == true) {
      Get.back(); 
    }
    
    // Pindah ke halaman Face Registration (tanpa bisa *back* ke pembayaran)
    Get.offNamed('/faceregistration'); 
  });
}
}

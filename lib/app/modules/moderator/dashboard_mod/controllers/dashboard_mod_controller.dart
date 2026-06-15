import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardModController extends GetxController {
  final TextEditingController broadcastController = TextEditingController();

  void goToTranscript() => Get.toNamed('/transcript');
  void goToQA() => Get.toNamed('/qa');
  void goToNotifikasi() => Get.toNamed('/notifikasi');
  void goToProfil() => Get.toNamed('/profil');

  // Fitur Broadcast
  void fillBroadcast(String message) {
    broadcastController.text = message;
  }

  void sendBroadcast() {
    if (broadcastController.text.trim().isNotEmpty) {
      Get.snackbar(
        "Berhasil", 
        "Pesan broadcast telah dikirim ke peserta",
        backgroundColor: Colors.blue.shade50,
        snackPosition: SnackPosition.BOTTOM
      );
      broadcastController.clear();
    }
  }

  @override
  void onClose() {
    broadcastController.dispose();
    super.onClose();
  }
}
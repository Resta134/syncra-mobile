import 'package:get/get.dart';

class FaceregistrationController extends GetxController {
  // Variabel untuk menangkap data event dari halaman Pembayaran
  late Map<String, dynamic> eventData;

  @override
  void onInit() {
    super.onInit();
    // Tangkap data arguments yang dikirim
    if (Get.arguments != null) {
      eventData = Get.arguments as Map<String, dynamic>;
    } else {
      eventData = {};
    }
  }

  void goToRegrestration() {
    // Pindah ke halaman scan muka, sambil bawa data event-nya
    Get.toNamed('/facescanner', arguments: eventData);
  }

  void goToTicket() {
    // Lewati scan muka, langsung ke halaman tiket QR Code
    // Pakai offAllNamed agar user tidak bisa back ke halaman registrasi wajah lagi
    Get.offAllNamed('/ticket', arguments: eventData); 
  }
}
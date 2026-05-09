import 'package:get/get.dart';

class DashboardModController extends GetxController {
  //TODO: Implement DashboardModController

   void goToTranscript() {
    print('sudah klik transcripts');
    Get.toNamed('/transcript');
  }
   void goToQA() {
    print('sudah klik qa');
    Get.toNamed('/qa');
  }
  void goToNotifikasi() {
    print("Membuka halaman profil...");
    Get.toNamed('/notifikasi');
  }
   void goToProfil() {
    print("Membuka halaman profil...");
    Get.toNamed('/profil');
  }
}

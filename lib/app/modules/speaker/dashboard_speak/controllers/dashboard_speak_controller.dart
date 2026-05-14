import 'package:get/get.dart';

class DashboardSpeakController extends GetxController {
  //TODO: Implement DashboardSpeakController

void goToPresent() {
    Get.toNamed('/speaker');
  }
  void goToProfil() {
    print("Membuka halaman profil...");
    Get.toNamed('/profil');
  }
}

import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  var name = "Rhiki Sulistiyo".obs;  

  void goToProfil() {
    Get.toNamed('/profil');
  }

  void goToHistory() {
    Get.toNamed('/history');
  }

  void goToDashboard() {
    Get.toNamed('/dashboard');
  }

  void goToRegister() {
    Get.toNamed('/register');
  }
}

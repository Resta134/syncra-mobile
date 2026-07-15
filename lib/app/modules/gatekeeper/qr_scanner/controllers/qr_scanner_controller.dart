import 'package:get/get.dart';

class QrScannerController extends GetxController {
  //TODO: Implement QrScannerController

  void vermuk() {
    Get.toNamed('/face-vertivication');
  }

  void goToValidation() {
    Get.toNamed('/user-validation');
  }

  void handleQrResult(String s) {}
   void dashboard() {
    Get.toNamed('/dashboard-gatekeeper');
  }
}

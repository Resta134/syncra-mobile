import 'package:get/get.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController

  void goToSignUp() {
    Get.toNamed('/register');
  }
  
  void goToHome() {
    Get.toNamed('/home');
  }
}

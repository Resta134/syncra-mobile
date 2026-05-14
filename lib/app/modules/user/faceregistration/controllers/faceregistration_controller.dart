import 'package:get/get.dart';

class FaceregistrationController extends GetxController {
  //TODO: Implement FaceregistrationController

  void goToRegrestration(){
    Get.toNamed('/facescanner');
  }
  void goToTicket(){
    Get.toNamed('/ticket');
  }
}

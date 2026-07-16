import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // GANTI lazyPut MENJADI Get.put
    // Get.put memaksa GetX langsung membuat tepat 1 instance nyata yang langsung dikunci ke layar
    Get.put<LoginController>(LoginController());
  }
}
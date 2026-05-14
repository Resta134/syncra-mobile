import 'package:get/get.dart';

import '../controllers/faceregistration_controller.dart';

class FaceregistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaceregistrationController>(
      () => FaceregistrationController(),
    );
  }
}

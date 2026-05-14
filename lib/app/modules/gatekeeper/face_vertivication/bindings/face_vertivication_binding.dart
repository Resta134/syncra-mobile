import 'package:get/get.dart';

import '../controllers/face_vertivication_controller.dart';

class FaceVertivicationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaceVertivicationController>(
      () => FaceVertivicationController(),
    );
  }
}

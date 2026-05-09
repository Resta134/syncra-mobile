import 'package:get/get.dart';

import '../controllers/q_a_speak_controller.dart';

class QASpeakBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QASpeakController>(
      () => QASpeakController(),
    );
  }
}

import 'package:get/get.dart';

import '../controllers/dashboard_speak_controller.dart';

class DashboardSpeakBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardSpeakController>(
      () => DashboardSpeakController(),
    );
  }
}

import 'package:get/get.dart';

import '../controllers/dashboard_mod_controller.dart';

class DashboardModBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardModController>(
      () => DashboardModController(),
    );
  }
}

import 'package:get/get.dart';

import '../controllers/dashboard_gatekeeper_controller.dart';

class DashboardGatekeeperBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardGatekeeperController>(
      () => DashboardGatekeeperController(),
    );
  }
}

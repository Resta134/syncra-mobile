import 'package:get/get.dart';

import '../controllers/scan_page_controller.dart';

class ScanPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanPageController>(
      () => ScanPageController(),
    );
  }
}

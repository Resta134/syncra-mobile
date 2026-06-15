import 'package:get/get.dart';

import '../controllers/facescanner_controller.dart';

class FacescannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaceScannerController>(
      () => FaceScannerController(),
    );
  }
}

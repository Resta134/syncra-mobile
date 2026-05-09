import 'package:get/get.dart';

import '../controllers/qa_controller.dart';

class QaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QaController>(
      () => QaController(),
    );
  }
}

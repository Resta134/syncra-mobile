import 'package:get/get.dart';

import '../controllers/user_validation_controller.dart';

class UserValidationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserValidationController>(
      () => UserValidationController(),
    );
  }
}

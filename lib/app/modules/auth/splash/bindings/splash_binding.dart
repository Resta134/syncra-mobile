import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class AuthSplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(),
    );
  }
}

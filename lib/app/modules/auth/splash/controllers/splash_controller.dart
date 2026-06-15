import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _startSplashScreen();
  }

  void _startSplashScreen() async {
    // Menahan layar splash selama 2,5 detik
    await Future.delayed(const Duration(milliseconds: 2500));
    
    // Setelah selesai, langsung lempar ke halaman login
    Get.offAllNamed('/login'); 
  }
}
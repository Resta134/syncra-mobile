import 'package:get/get.dart';

class FaceVertivicationController extends GetxController {
  //TODO: Implement FaceVertivicationController

  void report() {
    Get.snackbar('Report', 'Membuka formulir pelaporan ke Admin...');
  }
  void qr(){
  Get.toNamed('qr-scanner');
}
}

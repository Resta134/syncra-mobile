import 'package:get/get.dart';

class TicketController extends GetxController {
  //TODO: Implement TicketController

  
  void goToEventDetail() {
    print("Membuka halaman detail acara...");
    Get.toNamed('/event-detail');
  }
}

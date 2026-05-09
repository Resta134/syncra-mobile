import 'package:get/get.dart';

class SpeakerController extends GetxController {
  //TODO: Implement SpeakerController

 var currentSlide = 1.obs;     // Menyimpan posisi slide saat ini (dimulai dari 1)
  var totalSlides = 24.obs;     // Total keseluruhan slide (contoh: 24)

  // Fungsi untuk Next Slide
  void nextSlide() {
    if (currentSlide.value < totalSlides.value) {
      currentSlide.value++;
    }
  }

  // Fungsi untuk Previous Slide (Mundur)
  void previousSlide() {
    if (currentSlide.value > 1) {
      currentSlide.value--;
    }
  }
  void goToQA() {
    Get.toNamed('/qa-speak');
  }

  // ==========================================
  // STATE UNTUK Q&A (Yang sudah kita buat sebelumnya)
  // ==========================================
  // ... (kode isMicMuted, questions, dll biarkan saja di sini)
}

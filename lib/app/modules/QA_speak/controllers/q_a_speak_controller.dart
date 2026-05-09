import 'package:get/get.dart';

class QASpeakController extends GetxController {
  //TODO: Implement QASpeakController

  var isMicMuted = false.obs;
  var aiStatus = 'AI SYNC: ONLINE'.obs;
  var remainingTime = '5:30 Remaining'.obs;

  // Daftar Pertanyaan Dummy (Reaktif)
  var questions = <Map<String, dynamic>>[
    {
      'id': 1,
      'name': 'Yulia Petrovna',
      'avatar': 'https://i.pravatar.cc/150?img=1',
      'question': 'Bagaimana kita mengatasi bias-bias algoritma kepolisian?',
      'isLive': true, // Ini yang sedang tayang di layar besar
    },
    {
      'id': 2,
      'name': 'David Chen',
      'avatar': 'https://i.pravatar.cc/150?img=11',
      'question': 'Apakah AI generatif akan menghentikan proses seni kreatif?',
      'isLive': true,
    },
    {
      'id': 3,
      'name': 'Omar Khalid',
      'avatar': 'https://i.pravatar.cc/150?img=12',
      'question': 'Bagaimana dengan AI dan privasi?',
      'isLive': false,
    },
  ].obs;

  // Fungsi Aksi
  void toggleMic() {
    isMicMuted.value = !isMicMuted.value;
  }

  void markAsAnswered(int id) {
    // Menghapus dari daftar karena sudah dijawab
    questions.removeWhere((q) => q['id'] == id);
    Get.snackbar('Sukses', 'Pertanyaan ditandai sudah dijawab', 
        snackPosition: SnackPosition.BOTTOM);
  }

  void skipQuestion(int id) {
    // Menghapus dari daftar (dilewati)
    questions.removeWhere((q) => q['id'] == id);
  }

  void goToDashboard() {
    Get.toNamed('/dashboard-speak');
  }
}

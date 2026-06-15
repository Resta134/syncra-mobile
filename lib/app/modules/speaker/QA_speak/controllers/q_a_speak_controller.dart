import 'package:get/get.dart';

class QASpeakController extends GetxController {
  var isMicMuted = false.obs;
  var aiStatus = 'AI SYNC: ONLINE'.obs;
  var remainingTime = '5:30 Remaining'.obs;

  // Daftar Pertanyaan dengan atribut 'status'
  var questions = <Map<String, dynamic>>[
    {
      'id': 1,
      'name': 'Yulia Petrovna',
      'avatar': 'https://i.pravatar.cc/150?img=1',
      'question': 'Bagaimana kita mengatasi bias-bias algoritma kepolisian?',
      'isLive': true,
      'status': 'pending', // Status awal: pending
    },
    {
      'id': 2,
      'name': 'David Chen',
      'avatar': 'https://i.pravatar.cc/150?img=11',
      'question': 'Apakah AI generatif akan menghentikan proses seni kreatif?',
      'isLive': false,
      'status': 'pending',
    },
  ].obs;

  void toggleMic() {
    isMicMuted.value = !isMicMuted.value;
  }

  // Fungsi untuk menandai sudah terjawab
  void markAsAnswered(int id) {
    int index = questions.indexWhere((q) => q['id'] == id);
    if (index != -1) {
      questions[index]['status'] = 'answered'; // Update status, jangan di-remove
      questions.refresh(); // Wajib panggil ini agar UI terupdate
      Get.snackbar('Sukses', 'Pertanyaan ditandai sudah dijawab', 
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void skipQuestion(int id) {
    int index = questions.indexWhere((q) => q['id'] == id);
    if (index != -1) {
      questions[index]['status'] = 'skipped';
      questions.refresh();
    }
  }

  void goToDashboard() {
    Get.toNamed('/dashboard-speak');
  }
}
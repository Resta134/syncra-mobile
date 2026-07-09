import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tranlator_v1/app/utils/audit_log.dart';
import 'package:flutter/material.dart';

class QASpeakController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  var isMicMuted = false.obs;
  var aiStatus = 'AI SYNC: ONLINE'.obs;
  var remainingTime = '5:30 Remaining'.obs;

  // Variabel penampung data REAL dari database
  var questions = <Map<String, dynamic>>[].obs;

  String eventId = '';

  @override
  void onInit() {
    super.onInit();

    // Tangkap ID Event agar pertanyaan tidak bercampur dengan event lain
    if (Get.arguments != null && Get.arguments['id'] != null) {
      eventId = Get.arguments['id'].toString();
    }

    // Mulai streaming data riil
    _listenToApprovedQuestions();
  }

  // ==========================================
  // 1. TARIK DATA REAL DARI DATABASE
  // ==========================================
  void _listenToApprovedQuestions() {
    // A. Buat fungsi pemroses data agar bisa dipanggil dengan aman
    void processData(List<Map<String, dynamic>> data) async {
      List<Map<String, dynamic>> tempQuestions = [];
      List<String> userIds = [];

      // Ambil teks pertanyaan riil dari tabel 'questions'
      for (var item in data) {
        String dbStatus = item['status'] ?? '';

        if (dbStatus == 'approved' ||
            dbStatus == 'answered' ||
            dbStatus == 'skipped') {
          String uiStatus = dbStatus == 'approved' ? 'pending' : dbStatus;

          String userId = item['user_id']?.toString() ?? '';
          if (userId.isNotEmpty && !userIds.contains(userId)) {
            userIds.add(userId);
          }

          tempQuestions.add({
            'id': item['id'].toString(),
            'user_id': userId,
            'question': item['text'] ?? '', // Data asli dari kolom 'text'
            'status': uiStatus,
            'isLive': true,
          });
        }
      }

      // Ambil nama & foto riil dari tabel 'profiles' berdasarkan user_id
      Map<String, Map<String, dynamic>> userProfiles = {};
      if (userIds.isNotEmpty) {
        try {
          final profilesResponse = await _supabase
              .from('profiles')
              .select('id, full_name, name, avatar_url, avatar')
              .inFilter('id', userIds);

          for (var profile in profilesResponse) {
            userProfiles[profile['id'].toString()] = profile;
          }
        } catch (e) {
          print("Error fetch profil riil: $e");
        }
      }

      // Gabungkan Pertanyaan dengan Nama Riil menjadi satu kesatuan
      List<Map<String, dynamic>> finalQuestions = [];

      for (var q in tempQuestions) {
        String uid = q['user_id'];

        String realName = '';
        String realAvatar =
            'https://ui-avatars.com/api/?name=User&background=0D8ABC&color=fff';

        if (userProfiles.containsKey(uid)) {
          var p = userProfiles[uid]!;
          realName = p['full_name'] ?? realName;
          realAvatar = p['avatar_url'] ?? p['avatar'] ?? realAvatar;
        }

        finalQuestions.add({
          'id': q['id'],
          'name': realName,
          'avatar': realAvatar,
          'question': q['question'],
          'isLive': q['isLive'],
          'status': q['status'],
        });
      }

      // Update UI dengan data yang sudah 100% riil
      questions.value = finalQuestions.reversed.toList();
    }

    // B. Jalankan Stream dan panggil fungsi processData di atas
    if (eventId.isNotEmpty) {
      _supabase
          .from('questions')
          .stream(primaryKey: ['id'])
          .eq('event_id', eventId)
          .listen(processData); // <-- Panggil di sini
    } else {
      _supabase
          .from('questions')
          .stream(primaryKey: ['id'])
          .listen(processData); // <-- Dan panggil di sini
    }
  }

  void toggleMic() {
    isMicMuted.value = !isMicMuted.value;
  }

  // ==========================================
  // 2. UPDATE STATUS KE DATABASE RIIL
  // ==========================================
  Future<void> markAsAnswered(String id) async {
    try {
      await _supabase
          .from('questions')
          .update({'status': 'answered'})
          .eq('id', id);
      await AuditLog.record(
        'SPEAKER_ANSWERED_QUESTION',
        'Pemateri menandai pertanyaan ID: $id sebagai Terjawab.',
      );
      Get.snackbar(
        'Sukses',
        'Pertanyaan ditandai sudah dijawab',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue.withOpacity(0.1),
      );
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengupdate database: $e');
    }
  }

  Future<void> skipQuestion(String id) async {
    try {
      await _supabase
          .from('questions')
          .update({'status': 'skipped'})
          .eq('id', id);
      await AuditLog.record(
        'SPEAKER_SKIPPED_QUESTION',
        'Pemateri melewati pertanyaan ID: $id.',
      );
    } catch (e) {
      Get.snackbar('Error', 'Gagal melewati pertanyaan: $e');
    }
  }

  void goToDashboard() {
    Get.toNamed('/dashboard-speak');
  }
}

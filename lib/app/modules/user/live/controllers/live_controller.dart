import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LiveController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  // =========================================
  // STATE & CONTROLLER UI
  // =========================================
  final selectedTab = 0.obs;
  late PageController pageController;
  final questionController = TextEditingController();

  final isPlaying = true.obs;
  final playbackSpeed = 1.0.obs;

  // =========================================
  // DATA REAL-TIME (DARI SUPABASE)
  // =========================================
  final communityQuestions = <Map<String, dynamic>>[].obs;
  final myQuestions = <Map<String, dynamic>>[].obs;
  final transcripts = <Map<String, dynamic>>[].obs; // <-- Untuk Subtitle Terjemahan

  // Variabel Sesi
  late String eventId;
  String? userId;
  String userName = 'User Syncra';
  String userInitial = 'U';

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
    
    // 1. Ambil Data User Saat Ini
    _getUserData();

    // 2. Tangkap ID Event dari halaman sebelumnya
    final eventData = Get.arguments;
    if (eventData != null && eventData['id'] != null) {
      eventId = eventData['id'];
      
      // 3. Mulai dengarkan database secara LIVE!
      _listenToQuestions();
      _listenToTranscripts();
    } else {
      Get.snackbar('Error', 'Sesi Live tidak valid.', backgroundColor: Colors.red.withOpacity(0.1));
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    questionController.dispose();
    super.onClose();
  }

  // =========================================
  // FUNGSI INISIALISASI & REAL-TIME STREAMS
  // =========================================
  
  void _getUserData() {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      userId = user.id;
      userName = user.userMetadata?['full_name'] ?? user.userMetadata?['name'] ?? 'Peserta Syncra';
      
      // Ambil 2 huruf pertama untuk avatar (misal: Resta Sabrina -> RS)
      List<String> nameParts = userName.split(' ');
      if (nameParts.length > 1) {
        userInitial = '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
      } else if (nameParts.isNotEmpty && nameParts[0].isNotEmpty) {
        userInitial = nameParts[0].substring(0, min(2, nameParts[0].length)).toUpperCase();
      }
    }
  }

  // Mendengarkan Tabel Questions secara Real-time
  void _listenToQuestions() {
    _supabase
        .from('questions')
        .stream(primaryKey: ['id'])
        .eq('event_id', eventId)
        .order('created_at', ascending: false) // Yang terbaru di atas
        .listen((List<Map<String, dynamic>> data) {
          
      final List<Map<String, dynamic>> community = [];
      final List<Map<String, dynamic>> mine = [];

      for (var row in data) {
        // Format jam (Contoh: 10:24)
        DateTime createdAt = DateTime.parse(row['created_at']).toLocal();
        String timeStr = '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';

        // Tentukan nama pengirim (Jika ini pertanyaan kita, pakai nama kita)
        bool isMyQuestion = row['user_id'] == userId;
        String senderName = isMyQuestion ? userName : 'Peserta Acara';
        String initial = isMyQuestion ? userInitial : 'P';

        Map<String, dynamic> questionData = {
          'id': row['id'],
          'initial': initial,
          'name': senderName,
          'time': timeStr,
          'text': row['text'],
          'status': row['status'],
        };

        // Pisahkan ke tab masing-masing
        if (isMyQuestion) {
          mine.add(questionData);
        }
        
        // Hanya munculkan di komunitas jika statusnya sudah di-approve Admin
        if (row['status'] == 'approved') {
          community.add(questionData);
        }
      }

      communityQuestions.value = community;
      myQuestions.value = mine;
    });
  }

  // Mendengarkan Tabel Transcripts secara Real-time
  void _listenToTranscripts() {
    _supabase
        .from('transcripts')
        .stream(primaryKey: ['id'])
        .eq('event_id', eventId)
        .order('created_at', ascending: true) // Teks mengalir dari atas ke bawah
        .listen((List<Map<String, dynamic>> data) {
      transcripts.value = data;
    });
  }

  // =========================================
  // FUNGSI - FUNGSI AKSI (ACTIONS)
  // =========================================

  // Fungsi kirim pertanyaan ke Database
  Future<void> sendQuestion() async {
    final text = questionController.text.trim();
    if (text.isEmpty || userId == null) return;

    // Supaya UI terasa responsif, kita kosongkan dulu formnya
    questionController.clear(); 
    
    try {
      await _supabase.from('questions').insert({
        'event_id': eventId,
        'user_id': userId,
        'text': text,
        'status': 'pending', // Menunggu persetujuan moderator
      });

      Get.snackbar(
        'Terkirim',
        'Pertanyaan sedang di-review oleh Moderator.',
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green[800],
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar('Gagal', 'Gagal mengirim pertanyaan: $e', backgroundColor: Colors.red.withOpacity(0.1));
    }
  }

  // Fungsi pindah tab Q&A
  void switchTab(int index) {
    selectedTab.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Fungsi play/pause audio AI
  void togglePlay() {
    isPlaying.value = !isPlaying.value;
    Get.snackbar(
      isPlaying.value ? 'Memutar' : 'Dijeda',
      isPlaying.value ? 'Melanjutkan live audio...' : 'Live audio dijeda',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 1),
    );
  }

  // Fungsi ubah speed audio AI
  void changeSpeed() {
    if (playbackSpeed.value == 1.0) {
      playbackSpeed.value = 1.25;
    } else if (playbackSpeed.value == 1.25) {
      playbackSpeed.value = 1.5;
    } else if (playbackSpeed.value == 1.5) {
      playbackSpeed.value = 2.0;
    } else {
      playbackSpeed.value = 1.0;
    }

    Get.snackbar(
      'Kecepatan Diubah',
      'Kecepatan audio diatur ke ${playbackSpeed.value}x',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.blue.shade50,
    );
  }

  int min(int a, int b) => a < b ? a : b; // Helper matematika sederhana
}
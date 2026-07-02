import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LiveController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  // =========================================
  // STATE & CONTROLLER UI
  // =========================================
  final selectedTab = 0.obs;
  final questionController = TextEditingController();
  final isPlaying = true.obs;
  final playbackSpeed = 1.0.obs;

  // =========================================
  // DATA APP BAR (DINAMIS DARI HOME)
  // =========================================
  var eventTitle = 'Memuat Event...'.obs;
  var speakerName = 'Memuat...'.obs;
  var viewerCount = '0'.obs;

  // =========================================
  // DATA REAL-TIME (DARI SUPABASE)
  // =========================================
  final communityQuestions = <Map<String, dynamic>>[].obs;
  final myQuestions = <Map<String, dynamic>>[].obs;
  final transcripts = <Map<String, dynamic>>[].obs; 

  // Variabel Sesi
  late String eventId;
  String? userId;
  String userName = 'User Syncra';
  String userInitial = 'U';

  @override
  void onInit() {
    super.onInit();
    
    // 1. Amankan Data Profil User
    _getUserData();

    // 2. Tangkap Data Event dari Halaman Sebelumnya
    final eventData = Get.arguments;
    if (eventData != null && eventData['id'] != null) {
      eventId = eventData['id'];
      
      // Isi data AppBar secara dinamis
      eventTitle.value = eventData['title'] ?? 'Event Tanpa Judul';
      speakerName.value = eventData['speaker'] ?? 'Admin Syncra';
      
      // Simulasi/Ambil viewer count jika ada di tabel events
      viewerCount.value = eventData['viewers']?.toString() ?? '1.2K';
      
      // 3. Mulai Buka Keran Data Real-time Supabase!
      _listenToQuestions();
      _listenToTranscripts();
    } else {
      Get.snackbar(
        'Error', 
        'Data event tidak valid atau kosong.', 
        backgroundColor: Colors.red.withOpacity(0.1)
      );
    }
  }

  @override
  void onClose() {
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
      
      // Mencegah crash jika nama kosong setelah di-trim
      String cleanName = userName.trim();
      if (cleanName.isEmpty) {
        userInitial = 'P';
        return;
      }

      // Ambil inisial dengan aman menggunakan Regex
      List<String> nameParts = cleanName.split(RegExp(r'\s+')); 
      if (nameParts.length > 1) {
        userInitial = '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
      } else {
        userInitial = nameParts[0].substring(0, min(2, nameParts[0].length)).toUpperCase();
      }
    } else {
      userId = null;
      userName = 'Peserta Anonim';
      userInitial = 'A';
    }
  }

  // Mendengarkan Tabel Q&A secara Real-time
  void _listenToQuestions() {
    _supabase
        .from('questions')
        .stream(primaryKey: ['id'])
        .eq('event_id', eventId)
        .order('created_at', ascending: false) // Terbaru di atas
        .listen((List<Map<String, dynamic>> data) {
          
      final List<Map<String, dynamic>> community = [];
      final List<Map<String, dynamic>> mine = [];

      for (var row in data) {
        DateTime createdAt = DateTime.parse(row['created_at']).toLocal();
        String timeStr = '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';

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

        if (isMyQuestion) mine.add(questionData);
        // Hanya muncul di tab Komunitas jika disetujui admin
        if (row['status'] == 'approved') community.add(questionData);
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
        .order('created_at', ascending: true) // Dari lama ke baru
        .listen((List<Map<String, dynamic>> data) {
      transcripts.value = data;
    });
  }

  // =========================================
  // FUNGSI - FUNGSI AKSI (ACTIONS)
  // =========================================

  Future<void> sendQuestion() async {
    final text = questionController.text.trim();
    if (text.isEmpty) return;

    if (userId == null) {
      Get.snackbar('Gagal', 'Anda harus login untuk bertanya.', backgroundColor: Colors.orange.shade100);
      return;
    }

    questionController.clear(); 
    
    try {
      await _supabase.from('questions').insert({
        'event_id': eventId,
        'user_id': userId,
        'text': text,
        'status': 'pending', // Menunggu persetujuan
      });

      Get.snackbar(
        'Terkirim',
        'Pertanyaan sedang di-review oleh Moderator.',
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green[800],
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      // TAMBAHKAN PRINT INI UNTUK MELIHAT TERSANGKANYA DI TERMINAL
      print("========== ERROR KIRIM PERTANYAAN ==========");
      print(e);
      print("============================================");
      
      Get.snackbar('Gagal', 'Gagal mengirim pertanyaan.', backgroundColor: Colors.red.withOpacity(0.1));
    }
  }

  void togglePlay() {
    isPlaying.value = !isPlaying.value;
  }

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
  }
}
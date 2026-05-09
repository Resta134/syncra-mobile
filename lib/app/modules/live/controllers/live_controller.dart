import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveController extends GetxController {
  // =========================================
  // 1. KONTROL TAB (Community & My Question)
  // =========================================
  final selectedTab = 0.obs;
  late PageController pageController;

  final isPlaying = true.obs;
  final playbackSpeed = 1.0.obs;


  final communityQuestions = [
    {
      'initial': 'RS',
      'name': 'Rhiki Sulistiyo',
      'time': '10:24 AM',
      'text': 'Bagaimana cara AI menangani dialek lokal yang sulit diterjemahkan secara akurat?'
    },
    {
      'initial': 'AL',
      'name': 'Alan',
      'time': '10:26 AM',
      'text': 'Sesi Tanya Jawab akan dimulai, silahkan ajukan pertanyaanmu jangan malu-malu yaa'
    },
  ].obs;

  // Daftar Pertanyaan Saya
  final myQuestions = [
    {
      'initial': 'RS', // Sesuai nama lu
      'name': 'Rhiki Sulistiyo',
      'time': '10:24 AM',
      'text': 'Bagaimana cara AI menangani dialek lokal yang sulit diterjemahkan secara akurat?'
    },
  ].obs;
  


  // Controller untuk text input (Tanya Pembicara)
  final questionController = TextEditingController();


  // =========================================
  // INIT & DISPOSE (Wajib buat PageController)
  // =========================================
  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
  }

  @override
  void onClose() {
    pageController.dispose();
    questionController.dispose();
    super.onClose();
  }


  // =========================================
  // FUNGSI - FUNGSI AKSI (ACTIONS)
  // =========================================

  // Fungsi pindah tab Q&A
  void switchTab(int index) {
    selectedTab.value = index;
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Fungsi play/pause audio
  void togglePlay() {
    isPlaying.value = !isPlaying.value;
    Get.snackbar(
      isPlaying.value ? 'Memutar' : 'Dijeda',
      isPlaying.value ? 'Melanjutkan live audio...' : 'Live audio dijeda',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 1),
    );
  }

  // Fungsi ubah speed audio
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

  // Fungsi kirim pertanyaan
  void sendQuestion() {
    if (questionController.text.trim().isEmpty) {
      return; // Kalau teks kosong, ga usah ngapa-ngapain
    }

    // Nambahin teks ke list "My Question" secara lokal (simulasi)
    myQuestions.add({
      'initial': 'RS',
      'name': 'Rhiki Sulistiyo',
      'role': 'Peserta',
      'time': 'Just Now',
      'text': questionController.text,
    });

    questionController.clear(); // Bersihin kolom input

    // Kasih notif sukses
    Get.snackbar(
      'Terkirim',
      'Pertanyaan sedang di-review oleh Moderator.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }
}

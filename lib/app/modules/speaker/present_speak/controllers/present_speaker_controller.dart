import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:translator/translator.dart';

class SpeakerController extends GetxController {
  // ======================================================
  // UI STATE
  // ======================================================

  final TextEditingController notesController = TextEditingController();

  final isMicOn = false.obs;
  final elapsedTime = "00:00".obs;
  final liveText = ''.obs;

  final transcriptList = <Map<String, dynamic>>[].obs;

  // ======================================================
  // SERVICES
  // ======================================================

  final SpeechToText speech = SpeechToText();
  final GoogleTranslator translator = GoogleTranslator();

  final SupabaseClient supabase = Supabase.instance.client;

  late RealtimeChannel transcriptChannel;

  // ======================================================
  // SESSION
  // ======================================================

  String speakerName = "Speaker";
  String eventId = "";

  // ======================================================
  // INIT
  // ======================================================

  @override
  void onInit() {
    super.onInit();

    _loadSession();

    transcriptChannel = supabase.channel('syncra-transcript');

    transcriptChannel.subscribe();
  }

  // AMANKAN FUNGSI LOAD SESSION
  void _loadSession() {
    final user = supabase.auth.currentUser;

    if (user != null) {
      speakerName =
          user.userMetadata?['full_name'] ??
          user.userMetadata?['name'] ??
          user.email ??
          "Speaker";
    }

    print("========== GET ARGUMENT ==========");
    print(Get.arguments);

    if (Get.arguments != null) {
      final data = Get.arguments;
      if (data is Map && data.containsKey('id')) {
        // JANGAN gunakan .toString() dulu agar tipe asli dari database terjaga
        eventId = data['id'];
      }
    }
    print("EVENT ID LOADED : $eventId");
  }

  // ======================================================
  // MIC CONTROL
  // ======================================================
  Future<void> toggleMic() async {
    isMicOn.toggle(); // Ubah status UI duluan

    if (isMicOn.value) {
      _startTimer(); // Mulai timer HANYA saat tombol ditekan user
      await _startListening();
    } else {
      await _stopListening();
    }
  }

  // ======================================================
  // START STT
  // ======================================================
  Future<void> _startListening() async {
    bool available = await speech.initialize(
      onStatus: (status) async {
        // <-- Ubah jadi async
        print("STT Status: $status");

        if (status == 'done' || status == 'notListening') {
          // 🔥 TRIK RAMPAS PAKSA:
          // Jika mic mati karena hening tapi masih ada teks yang tertinggal di papan (belum masuk list)
          if (liveText.value.trim().isNotEmpty) {
            final kalimatTerakhir = liveText.value.trim();
            liveText.value = ''; // Langsung bersihkan papan agar tidak double
            await _processTranscript(
              kalimatTerakhir,
            ); // Eksekusi masuk list & database
          }

          // Logika Auto-Restart
          if (isMicOn.value) {
            print("Keheningan terdeteksi. Auto-Restarting Mic...");
            Future.delayed(const Duration(milliseconds: 500), () {
              if (isMicOn.value) _listenActively();
            });
          }
        }
      },
      onError: (error) => print("STT Error: $error"),
    );

    if (!available) {
      Get.snackbar("Error", "Speech Recognition tidak tersedia");
      isMicOn.value = false;
      return;
    }

    _listenActively();
  }

  // Fungsi khusus untuk mengeksekusi pendengaran dengan logika potong kalimat saat hening
  // Fungsi khusus pendengaran
  void _listenActively() async {
    if (!isMicOn.value) return;

    await speech.listen(
      localeId: "id_ID",
      listenMode: ListenMode.dictation,
      partialResults: true,
      pauseFor: const Duration(seconds: 3), // Batas hening 3 detik
      listenFor: const Duration(hours: 24),
      onResult: (result) async {
        // 1. Selalu tampilkan hasil tangkapan di papan secara real-time
        liveText.value = result.recognizedWords;

        // 2. JAGA-JAGA: Jika sistem HP-mu (kebetulan) mengirimkan sinyal final dengan benar
        if (result.finalResult && result.recognizedWords.trim().isNotEmpty) {
          final kalimatSelesai = result.recognizedWords.trim();
          liveText.value = ''; // Bersihkan papan
          await _processTranscript(kalimatSelesai); // Masuk list & database
        }
      },
    );
  }

  // ======================================================
  // STOP STT
  // ======================================================
  Future<void> _stopListening() async {
    await speech.stop();
    _timer?.cancel();
  }

  // ======================================================
  // TRANSLATION (TRIK BANDING GANDA)
  // ======================================================

  Future<void> _processTranscript(String originalText) async {
    try {
      // 1. Langsung translate ke dua bahasa sekaligus tanpa pusing mikirin 'detectedLang'
      var toEnglish = await translator.translate(originalText, to: 'en');
      var toIndo = await translator.translate(originalText, to: 'id');

      String finalTranslatedText = '';
      String finalSourceLang = '';

      // Bersihkan teks dari spasi berlebih dan ubah ke huruf kecil untuk perbandingan yang akurat
      String textAsli = originalText.toLowerCase().trim();
      String textInggris = toEnglish.text.toLowerCase().trim();

      // 2. LOGIKA KUNCI: Cek kemiripan teks
      if (textAsli == textInggris) {
        // Jika teks asli SAMA dengan hasil translate Inggris, berarti aslinya adalah Inggris!
        finalTranslatedText = toIndo.text; // Tampilkan hasil Indonesia
        finalSourceLang = 'en';
        print(
          "🔀 DETEKSI: Bahasa Inggris -> Diterjemahkan ke Indonesia: $finalTranslatedText",
        );
      } else {
        // Jika berbeda, berarti aslinya bukan Inggris (Indonesia)
        finalTranslatedText = toEnglish.text; // Tampilkan hasil Inggris
        finalSourceLang = 'id';
        print(
          "🔀 DETEKSI: Bahasa Indonesia -> Diterjemahkan ke Inggris: $finalTranslatedText",
        );
      }

      // 3. Masukkan ke List Papan Berjalan di UI
      transcriptList.insert(0, {
        'original_text': originalText,
        'translated_text': finalTranslatedText,
        'language': finalSourceLang,
      });

      // 4. Kirim dan Simpan ke Database
      await _saveTranscript(
        originalText: originalText,
        translatedText: finalTranslatedText,
        language: finalSourceLang,
      );
    } catch (e) {
      print("TRANSLATION ERROR: $e");
      Get.snackbar("Translation Error", e.toString());
    }
  }

  // ======================================================
  // SAVE DATABASE
  // ======================================================

  Future<void> _saveTranscript({
    required String originalText,
    required String translatedText,
    required String language,
  }) async {
    try {
      print("========== SAVE TRANSCRIPT ==========");
      print("event_id: $eventId");
      print("speaker: $speakerName");
      print("original_text: $originalText");
      print("translated_text: $translatedText");

      final result = await supabase.from('transcripts').insert({
        'event_id': eventId,
        'speaker': speakerName,
        'original_text': originalText,
        'translated_text': translatedText,
        'language': language,
      }).select();

      print("INSERT SUCCESS");
      print(result);

      await transcriptChannel.sendBroadcastMessage(
        event: 'new-text',
        payload: {
          'event_id': eventId,
          'speaker': speakerName,
          'original_text': originalText,
          'translated_text': translatedText,
          'language': language,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      print("BROADCAST SUCCESS");
    } catch (e) {
      print("INSERT ERROR");
      print(e);

      Get.snackbar("Database Error", e.toString());
    }
  }

  // ======================================================
  // TIMER
  // ======================================================

  Timer? _timer;

  int _secondsElapsed = 0;

  void _startTimer() {
    _secondsElapsed = 0;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _secondsElapsed++;

      final m = (_secondsElapsed ~/ 60).toString().padLeft(2, '0');

      final s = (_secondsElapsed % 60).toString().padLeft(2, '0');

      elapsedTime.value = "$m:$s";
    });
  }

  // ======================================================
  // NAVIGATION
  // ======================================================

  void goToQA() {
    Get.toNamed('/qa-speak');
  }

  // ======================================================
  // DISPOSE
  // ======================================================

  @override
  void onClose() {
    speech.stop();

    _timer?.cancel();

    notesController.dispose();

    supabase.removeChannel(transcriptChannel);

    super.onClose();
  }
}

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
    if (isMicOn.value) {
      await _stopListening();
    } else {
      await _startListening();
    }

    isMicOn.toggle();
  }

  // ======================================================
  // START STT
  // ======================================================

  Future<void> _startListening() async {
    bool available = await speech.initialize();

    if (!available) {
      Get.snackbar("Error", "Speech Recognition tidak tersedia");
      return;
    }

    _startTimer();

    await speech.listen(
      localeId: "id_ID",
      listenMode: ListenMode.dictation,
      partialResults: true,
      onResult: (result) async {
        liveText.value = result.recognizedWords;

        if (result.finalResult && result.recognizedWords.trim().isNotEmpty) {
          await _processTranscript(result.recognizedWords.trim());
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
  // TRANSLATION
  // ======================================================

  Future<void> _processTranscript(String originalText) async {
    try {
      bool isIndonesian = RegExp(
        r'\b(yang|dan|di|ke|untuk|dengan|saya|kami|anda|ini|itu|adalah)\b',
        caseSensitive: false,
      ).hasMatch(originalText);

      String sourceLanguage = isIndonesian ? "id" : "en";

      String targetLanguage = isIndonesian ? "en" : "id";

      final translation = await translator.translate(
        originalText,
        from: sourceLanguage,
        to: targetLanguage,
      );

      final translatedText = translation.text;

      transcriptList.insert(0, {
        'original_text': originalText,
        'translated_text': translatedText,
        'language': sourceLanguage,
      });

      await _saveTranscript(
        originalText: originalText,
        translatedText: translatedText,
        language: sourceLanguage,
      );
    } catch (e) {
      print("TRANSLATION ERROR");
      print(e);

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

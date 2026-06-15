import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SpeakerController extends GetxController {
  // Input Catatan
  final TextEditingController notesController = TextEditingController();
  
  // State Timer
  var isMicOn = false.obs;
  var elapsedTime = "00:00".obs;
  var remainingTime = "00:00".obs;
  
  Timer? _timer;
  int _secondsElapsed = 0;
  int totalDurationSeconds = 60 * 60; // Default 60 menit (bisa diubah sesuai event)

  @override
  void onInit() {
    super.onInit();
    // Inisialisasi sisa waktu awal
    _updateRemainingTime(totalDurationSeconds);
  }

  void toggleMic() {
    isMicOn.value = !isMicOn.value;
    if (isMicOn.value) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _secondsElapsed++;
        
        // Update waktu berjalan
        int m = _secondsElapsed ~/ 60;
        int s = _secondsElapsed % 60;
        elapsedTime.value = "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
        
        // Update sisa waktu
        _updateRemainingTime(totalDurationSeconds - _secondsElapsed);
      });
    } else {
      _timer?.cancel();
    }
  }

  void _updateRemainingTime(int seconds) {
    if (seconds < 0) seconds = 0;
    int m = seconds ~/ 60;
    int s = seconds % 60;
    remainingTime.value = "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  void goToQA() {
    Get.toNamed('/qa-speak');
  }

  @override
  void onClose() {
    notesController.dispose();
    _timer?.cancel();
    super.onClose();
  }
}
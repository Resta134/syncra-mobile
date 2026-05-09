import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QaController extends GetxController {
  //TODO: Implement QaController
  var questions = [
    {
      'id': '1',
      'sender': 'Dr. Emily Chen',
      'text':
          'How does the proposed transformer model address the vanishing gradient problem in extremely long context windows?',
      'status': 'projecting', // Status: pending, approved, projecting
    },
    {
      'id': '2',
      'sender': 'Anonymous Attendee',
      'text':
          'Could you elaborate on the ethical implications of using synthetic data to train these moderation algorithms?',
      'status': 'pending',
    },
    {
      'id': '3',
      'sender': 'Markus R.',
      'text':
          'Is the latency acceptable for real-time applications like autonomous driving?',
      'status': 'pending',
    },
    {
      'id': '4',
      'sender': 'Sarah J.',
      'text':
          'What hardware acceleration is strictly necessary to run this framework locally?',
      'status': 'approved',
    },
    {
      'id': '5',
      'sender': 'Budi.',
      'text':
          'What hardware acceleration is strictly necessary to run this framework locally?',
      'status': 'pending',
    },
    {
      'id': '6',
      'sender': 'Ujang.',
      'text':
          'What hardware acceleration is strictly necessary to run this framework locally?',
      'status': 'pending',
    },
    {
      'id': '7',
      'sender': 'Tuan.',
      'text':
          'What hardware acceleration is strictly necessary to run this framework locally?',
      'status': 'pending',
    },
    {
      'id': '8',
      'sender': 'Yanto.',
      'text':
          'What hardware acceleration is strictly necessary to run this framework locally?',
      'status': 'pending',
    },
  ].obs;

  // fungsi dri hapus
  void dismissQuestion(String id) {
    questions.removeWhere((q) => q['id'] == id);
    Get.snackbar(
      'Dismissed',
      'Pertanyaan berhasil dihapus dari antrean.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.grey.withOpacity(0.4),
    );
  }

  void stopQuestion() {
    Get.snackbar(
      'Q&A session has ended',
      'Questions are currently closed',
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.only(top: 60),
      backgroundColor: Colors.grey.withOpacity(0.4),
    );
  }

  // fungsi aprobve
  void approveQuestion(String id) {
    var index = questions.indexWhere((q) => q['id'] == id);
    if (index != -1) {
      var q = questions[index];
      q['status'] = 'approved';
      questions[index] = q;
    }
  }

  // fungsi to scren
  void projectToScreen(String id) {
    // 1. Turunin status pertanyaan yang lagi "Projecting" balik jadi "Approved"
    for (var i = 0; i < questions.length; i++) {
      if (questions[i]['status'] == 'projecting') {
        var q = questions[i];
        q['status'] = 'approved';
        questions[i] = q;
      }
    }
    // 2. Naikin pertanyaan yang diklik jadi "Projecting"
    var index = questions.indexWhere((q) => q['id'] == id);
    if (index != -1) {
      var q = questions[index];
      q['status'] = 'projecting';
      questions[index] = q;
    }

    Get.snackbar(
      'On Screen',
      'Pertanyaan dikirim ke Proyektor & Layar Pembicara!',
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.only(top: 60),
      backgroundColor: Colors.blue.withOpacity(0.4),
      colorText: Colors.black,
    );
  }
}

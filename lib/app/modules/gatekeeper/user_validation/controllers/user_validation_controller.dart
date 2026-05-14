import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserValidationController extends GetxController {
  //TODO: Implement UserValidationController
  var participants = [
  {'id': 'SYNC-001', 'name': 'Rhiki Sulistiyo', 'status': 'Present'},
  {'id': 'SYNC-002', 'name': 'Resta Sabrina', 'status': 'Present'},
  {'id': 'SYNC-003', 'name': 'Budi Santoso', 'status': 'Absent'},
  {'id': 'SYNC-004', 'name': 'Sarah Jenkins', 'status': 'Present'},
  {'id': 'SYNC-005', 'name': 'Andi Pratama', 'status': 'Present'},
  {'id': 'SYNC-006', 'name': 'Clara Wijaya', 'status': 'Present'},
  {'id': 'SYNC-007', 'name': 'Dimas Saputra', 'status': 'Present'},
  {'id': 'SYNC-008', 'name': 'Nadia Putri', 'status': 'Present'},
  {'id': 'SYNC-009', 'name': 'Kevin Hartono', 'status': 'Present'},
  {'id': 'SYNC-010', 'name': 'Michelle Tan', 'status': 'Absent'},
  {'id': 'SYNC-011', 'name': 'Farhan Akbar', 'status': 'Present'},
  {'id': 'SYNC-012', 'name': 'Alicia Gomez', 'status': 'Present'},
  {'id': 'SYNC-013', 'name': 'Rizky Maulana', 'status': 'Present'},
  {'id': 'SYNC-014', 'name': 'Stefani Lim', 'status': 'Present'},
  {'id': 'SYNC-015', 'name': 'Yoga Prasetyo', 'status': 'Absent'},
  {'id': 'SYNC-016', 'name': 'Cindy Natalia', 'status': 'Present'},
  {'id': 'SYNC-017', 'name': 'Jonathan Lee', 'status': 'Present'},
  {'id': 'SYNC-018', 'name': 'Putra Mahendra', 'status': 'Present'},
  {'id': 'SYNC-019', 'name': 'Felicia Wong', 'status': 'Present'},
  {'id': 'SYNC-020', 'name': 'Ahmad Fauzi', 'status': 'Present'},
  {'id': 'SYNC-021', 'name': 'Della Anastasya', 'status': 'Present'},
  {'id': 'SYNC-022', 'name': 'Reza Hidayat', 'status': 'Absent'},
  {'id': 'SYNC-023', 'name': 'Vanessa Ong', 'status': 'Present'},
  {'id': 'SYNC-024', 'name': 'Indra Kurniawan', 'status': 'Present'},
  {'id': 'SYNC-025', 'name': 'Shania Putri', 'status': 'Present'},
  {'id': 'SYNC-026', 'name': 'William Chen', 'status': 'Present'},
  {'id': 'SYNC-027', 'name': 'Tegar Ramadhan', 'status': 'Absent'},
  {'id': 'SYNC-028', 'name': 'Jessica Albert', 'status': 'Present'},
  {'id': 'SYNC-029', 'name': 'Rafi Nugraha', 'status': 'Present'},
  {'id': 'SYNC-030', 'name': 'Melisa Caroline', 'status': 'Present'},
].obs;
  // Fitur pencarian lokal
  var searchQuery = ''.obs;

  List<Map<String, String>> get filteredParticipants {
    if (searchQuery.value.isEmpty) return participants;
    return participants
        .where(
          (p) =>
              p['name']!.toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              ) ||
              p['id']!.toLowerCase().contains(searchQuery.value.toLowerCase()),
        )
        .toList();
  }

  void manualCheckIn(String id) {
    var index = participants.indexWhere((p) => p['id'] == id);
    if (index != -1) {
      var p = participants[index];
      p['status'] = 'Checked In';
      participants[index] = p; // Trigger Obx
      Get.snackbar(
        'Sukses',
        '${p['name']} berhasil Check-In manual!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}

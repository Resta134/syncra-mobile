import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranlator_v1/app/modules/user/payment/views/payment_view.dart';

class EventDetailController extends GetxController {
  //TODO: Implement EventDetailController

  final List<Map<String, String>> eventDetails = [
    {
      'title': 'AI Ethics & The Future of Work: A Global Perspective',
      'role': 'Cyber Security Specialist', // Key baru untuk jabatan
      'category': 'GLOBAL TECH IN WORLD',
      'viewers': '1.2k',
      'author': 'Dr. Rhiki', // Disesuaikan dengan deskripsi
      'lang': 'EN → ID',
      'description':
          'Join Dr. Rhiki as he explores the ethical implications of AI and its impact on the future of work. This session will provide a global perspective on how AI is shaping industries, job markets, and societal norms.',
    },
    {
      'title': 'Machine Learning Implementation in Healthcare',
      'role': 'AI Researcher & Professor',
      'category': 'GLOBAL TECH IN WORLD',
      'viewers': '850',
      'author': 'Prof. Alan',
      'lang': 'EN → ID',
      'description':
          'Discover how machine learning is revolutionizing healthcare with Prof. Alan. This session will cover real-world applications, challenges, and the future potential of AI in improving patient outcomes.',
    },
    {
      'title': 'Building Accessible User Interfaces in 2026',
      'role': 'UI/UX Designer at PT Garuda',
      'category': 'DESIGN TALKS',
      'viewers': '2.1k',
      'author': 'Sarah Jane',
      'lang': 'ID → EN',
      'description':
          'Learn about the latest trends and best practices in creating accessible user interfaces with Sarah Jane. This talk will focus on designing inclusive digital experiences for users of all abilities.',
    },
  ].obs;
  final date_location = [
    {'date': 'Today, 10:00 AM', 'location': 'Online'},
  ].obs;

  final user = [
    {
      'name': 'Rhiki Sulistiyo',
      'avatar': 'images/profil.png',
      'ticket1': 'TICKET CONFIRMATION',
      'ticket2': 'TICKET REQUIRED',
      'ticket_id': 'SYNCRA-102062023',
    },
  ].obs;

  final List<Map<String, String>> sistem = [
    {'status1': 'Live Now', 'status2': 'Up Coming'},
  ].obs;

  void goToLive() {
    Get.toNamed('/live');
  }

  void goToTicket() {
    Get.toNamed('/ticket');
  }

  void lockticket() {
    Get.snackbar(
      'Ticket Required',
      'Secure your ticket to access the live session.',
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      borderRadius: 14,
    );
  }

  void buyTicket() {
    // Simulasi loading sebentar biar keren
    Get.showOverlay(
      loadingWidget: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            'Loading... ',
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
        ),
      ),
      asyncFunction: () async {
        await Future.delayed(Duration(seconds: 3));
        hasTicket.value = true;
        Get.snackbar(
          'Sukses',
          'Tiket berhasil dibeli!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
    );
  }

  String get userName => user[0]['name'] ?? 'User';
  String get ticketID => user[0]['ticket_id'] ?? '-';

  // fungsi
  // Variabel untuk mengecek apakah user punya tiket acara INI
  var hasTicket = false.obs;
  void goToEventDetail(Map<String, String> eventData) {
    // Simulasi sementara:
    if (eventData['category'] == 'TECH') {
      hasTicket.value = true; // Anggap udah beli
    } else {
      hasTicket.value = false; // Anggap belum beli
    }
    Get.toNamed('/event-detail'); // Arahin ke halaman detail
  }

  void checkTicketStatus(Map<String, dynamic> eventData) {
    // Logic perkondisian lu semalam
    if (eventData['category'] == 'TECH') {
      hasTicket.value = true;
    } else {
      hasTicket.value = false;
    }

    // Baru setelah datanya siap, pindah halaman
    Get.toNamed('/event-detail');
  }
  void goToPembayaran() {
    print("Membuka halaman pembayaran...");
    Get.toNamed('/payment');
  }
  

}

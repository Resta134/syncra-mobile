import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:tranlator_v1/app/modules/user/event_detail/controllers/event_detail_controller.dart';

class DashboardController extends GetxController {
  final liveStreamData = [
    {
      'category': 'GLOBAL TECH SUMMIT',
      'viewers': '1.2k',
      'title': 'AI Ethics & The Future of Work: A Global Perspective',
      'author': 'Dr. Rhiki',
      'lang': 'EN → ID',
    },
    {
      'category': 'GLOBAL TECH SUMMIT',
      'viewers': '850',
      'title': 'Machine Learning Implementation in Healthcare',
      'author': 'Prof. Alan',
      'lang': 'EN → ID',
    },
    {
      'category': 'DESIGN TALKS',
      'viewers': '2.1k',
      'title': 'Building Accessible User Interfaces in 2026',
      'author': 'Sarah Jane',
      'lang': 'ID → EN',
    },
  ].obs;

  final upcomingEventsData = [
  {
    'thumbnail': 'images/profil.png',
    'time': 'Tomorrow, 10:00 AM',
    'tag': 'DESIGN',
    'titleupcoming': 'AI in Everyday Life: We Walk the talk',
    'authorUp': 'Dr. Mulyono',
    'location': 'Jaksel',
  },
  {
    'thumbnail': 'images/profil.png',
    'time': 'Tomorrow, 2:00 PM',
    'tag': 'TECH',
    'titleupcoming': 'UX/UI Patterns for Multi-language Interfaces',
    'authorUp': 'Dr. Bowo',
    'location': 'Bekasi',
  },
  {
    'thumbnail': 'images/profil.png',
    'time': 'Tomorrow, 4:00 PM',
    'tag': 'BUSINESS',
    'titleupcoming': 'Global Market Trends in the Age of AI',
    'authorUp': 'Dr. Mega',
    'location': 'Bekasi',
  },
  {
    'thumbnail': 'images/profil.png',
    'time': 'Tomorrow, 6:00 PM',
    'tag': 'EDUCATION',
    'titleupcoming': 'The Future of Learning: AI-Powered Education',
    'authorUp': 'Dr. O',
    'location': 'Online', // <-- GUA TAMBAHIN BIAR GAK BOLONG
  },
  {
    'thumbnail': 'images/profil.png',
    'time': 'Tomorrow, 8:00 PM',
    'tag': 'ENTERTAINMENT',
    'titleupcoming': 'AI in Entertainment: Revolutionizing Content Creation',
    'authorUp': 'Dr. O',
    'location': 'Online', // <-- GUA TAMBAHIN BIAR GAK BOLONG
  },
].obs;
 
  void goToHistory() {
    print("Membuka halaman riwayat...");
    Get.toNamed('/history');
  }

  void goToEvents() {
    // print("Membuka halaman detail acara...");
    Get.toNamed('/events');
  }

  void goToProfil() {
    print("Membuka halaman profil...");
    Get.toNamed('/profil');
  }

  void goToNotifikasi() {
    print("Membuka halaman profil...");
    Get.toNamed('/notifikasi');
  }

  void goToTicket() {
    print("Membuka halaman Ticket...");
    Get.toNamed('/ticket');
  }

  void goToEventDetail(Map<String, String> data) {
    print("Membuka halaman detail acara...");
    final detailController = Get.put(EventDetailController());

    // 2. Baru panggil fungsinya lewat variabel tersebut (huruf kecil depannya)
    detailController.checkTicketStatus(data);
  }
}

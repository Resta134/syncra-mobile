import 'package:get/get.dart';

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
      'titleupcoming': 'UX/UI Patterns for Multi-language Interfaces',
      'language':'EN -> IN',
    },
    {
      'thumbnail': 'images/profil.png',
      'time': 'Tomorrow, 2:00 PM',
      'tag': 'TECH',
      'titleupcoming': 'AI in Everyday Life: Opportunities and Challenges',
      'language':'ID -> EN',
    },
    {
      'thumbnail': 'images/profil.png',
      'time': 'Tomorrow, 4:00 PM',
      'tag': 'BUSINESS',
      'titleupcoming': 'Global Market Trends in the Age of AI',
      'language':'EN -> ID',
    },
    {
      'thumbnail': 'images/profil.png',
      'time': 'Tomorrow, 6:00 PM',
      'tag': 'EDUCATION',
      'titleupcoming': 'The Future of Learning: AI-Powered Education',
      'language':'ID -> EN',
    },
    {
      'thumbnail': 'images/profil.png',
      'time': 'Tomorrow, 8:00 PM',
      'tag': 'ENTERTAINMENT',
      'titleupcoming': 'AI in Entertainment: Revolutionizing Content Creation',
      'language':'EN -> ID',
    }
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

  void goToEventDetail() {
    print("Membuka halaman detail acara...");
    Get.toNamed('/event-detail');
  }


}

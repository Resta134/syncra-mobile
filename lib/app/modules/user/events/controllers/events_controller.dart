import 'package:get/get.dart';

class EventsController extends GetxController {
  //TODO: Implement EventsController

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
 void goToEventDetail(){
  Get.toNamed('/event-detail');
 }
}

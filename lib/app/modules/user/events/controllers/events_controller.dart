import 'package:get/get.dart';

class EventsController extends GetxController {
  //TODO: Implement EventsController

  final upcomingEventsData = [
  {
    'thumbnail': 'images/profil.png',
    'time': 'Tomorrow, 10:00 AM',
    'titleupcoming': 'AI in Everyday Life: We Walk the Talk',
    'authorUp': 'Dr. Mulyono',
    'location': 'Jakarta',
  },
  {
    'thumbnail': 'images/profil.png',
    'time': 'Tomorrow, 11:30 AM',
    'titleupcoming': 'UX/UI Patterns for Modern Applications',
    'authorUp': 'Dr. Bowo',
    'location': 'Bandung',
  },
  {
    'thumbnail': 'images/profil.png',
    'time': 'Tomorrow, 01:00 PM',
    'titleupcoming': 'Global Market Trends in the AI Era',
    'authorUp': 'Dr. Mega',
    'location': 'Bekasi',
  },
  {
    'thumbnail': 'images/profil.png',
    'time': 'Tomorrow, 02:30 PM',
    'titleupcoming': 'Cyber Security in the Digital Age',
    'authorUp': 'Dr. Jonathan',
    'location': 'Surabaya',
  },
  {
    'thumbnail': 'images/profil.png',
    'time': 'Tomorrow, 04:00 PM',
    'titleupcoming': 'Building Scalable Mobile Applications',
    'authorUp': 'Dr. Sarah',
    'location': 'Yogyakarta',
  },
  {
    'thumbnail': 'images/profil.png',
    'time': 'Tomorrow, 05:00 PM',
    'titleupcoming': 'Future of Artificial Intelligence',
    'authorUp': 'Dr. Kevin',
    'location': 'Depok',
  },
  {
    'thumbnail': 'images/profil.png',
    'time': 'Tomorrow, 06:30 PM',
    'titleupcoming': 'Machine Learning for Beginners',
    'authorUp': 'Dr. Alicia',
    'location': 'Bogor',
  },
  {
    'thumbnail': 'images/profil.png',
    'time': 'Tomorrow, 07:00 PM',
    'titleupcoming': 'Digital Branding and Social Media',
    'authorUp': 'Dr. Fernando',
    'location': 'Semarang',
  },
  {
    'thumbnail': 'images/profil.png',
    'time': 'Tomorrow, 08:00 PM',
    'titleupcoming': 'Cloud Computing Fundamentals',
    'authorUp': 'Dr. William',
    'location': 'Malang',
  },
  {
    'thumbnail': 'images/profil.png',
    'time': 'Tomorrow, 09:00 PM',
    'titleupcoming': 'Smart Cities and AI Innovation',
    'authorUp': 'Dr. Felicia',
    'location': 'Tangerang',
  },
  {
    'thumbnail': 'images/profil.png',
    'time': 'Friday, 09:00 AM',
    'titleupcoming': 'The Rise of Fintech Technology',
    'authorUp': 'Dr. Dimas',
    'location': 'Medan',
  },
  {
    'thumbnail': 'images/profil.png',
    'time': 'Friday, 10:30 AM',
    'titleupcoming': 'AI for Healthcare Systems',
    'authorUp': 'Dr. Michelle',
    'location': 'Batam',
  },
  {
    'thumbnail': 'images/profil.png',
    'time': 'Friday, 12:00 PM',
    'titleupcoming': 'Creative Thinking in Product Design',
    'authorUp': 'Dr. Clara',
    'location': 'Solo',
  },
  {
    'thumbnail': 'images/profil.png',
    'time': 'Friday, 01:30 PM',
    'titleupcoming': 'Data Science and Visualization',
    'authorUp': 'Dr. Rizky',
    'location': 'Makassar',
  },
  {
    'thumbnail': 'images/profil.png',
    'time': 'Friday, 03:00 PM',
    'titleupcoming': 'Business Strategy with AI',
    'authorUp': 'Dr. Vanessa',
    'location': 'Cirebon',
  },
  {
    'thumbnail': 'images/profil.png',
    'time': 'Friday, 04:30 PM',
    'titleupcoming': 'Cyber Ethics and Digital Privacy',
    'authorUp': 'Dr. Ahmad',
    'location': 'Bali',
  },
  {
    'thumbnail': 'images/profil.png',
    'time': 'Friday, 06:00 PM',
    'titleupcoming': 'Modern Front-End Development',
    'authorUp': 'Dr. Putra',
    'location': 'Palembang',
  },
  {
    'thumbnail': 'images/profil.png',
    'time': 'Friday, 07:30 PM',
    'titleupcoming': 'AI for Content Creation',
    'authorUp': 'Dr. Jessica',
    'location': 'Pontianak',
  },
  {
    'thumbnail': 'images/profil.png',
    'time': 'Friday, 08:30 PM',
    'titleupcoming': 'Future Careers in Technology',
    'authorUp': 'Dr. Reza',
    'location': 'Samarinda',
  },
  {
    'thumbnail': 'images/profil.png',
    'time': 'Friday, 09:30 PM',
    'titleupcoming': 'Interactive Design Systems',
    'authorUp': 'Dr. Cindy',
    'location': 'Pekalongan',
  },
].obs;

 void goToEventDetail(){
  Get.toNamed('/event-detail');
 }
}

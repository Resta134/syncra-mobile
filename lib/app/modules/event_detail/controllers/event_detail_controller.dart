import 'package:get/get.dart';

class EventDetailController extends GetxController {
  //TODO: Implement EventDetailController
    

    final List<Map<String, String>> eventDetails = [
    {
      'title': 'AI Ethics & The Future of Work: A Global Perspective',
      'category': 'GLOBAL TECH IN WORLD',
      'viewers': '1.2k',
      'author': 'Dr. RXXXYYY?',
      'lang': 'EN → ID',
      // deskripsi panjang untuk event detail
      'description': 'Join Dr. Rhiki as he explores the ethical implications of AI and its impact on the future of work. This session will provide a global perspective on how AI is shaping industries, job markets, and societal norms.', },
    {
      'title': 'Machine Learning Implementation in Healthcare',
      'category': 'GLOBAL TECH IN WORLD',
      'viewers': '850',
      'author': 'Prof. Alan',
      'lang': 'EN → ID',
      'description': 'Discover how machine learning is revolutionizing healthcare with Prof. Alan. This session will cover real-world applications, challenges, and the future potential of AI in improving patient outcomes.',
    },
    {
      'title': 'Building Accessible User Interfaces in 2026',
      'category': 'DESIGN TALKS',
      'viewers': '2.1k',
      'author': 'Sarah Jane',
      'lang': 'ID → EN',
      'description': 'Learn about the latest trends and best practices in creating accessible user interfaces with Sarah Jane. This talk will focus on designing inclusive digital experiences for users of all abilities.',
    },
  ].obs;

  final date_location = [
    {
      'date': 'Today, 10:00 AM',
      'location': 'Online',
    },
  ].obs;

  final user = [
    {
      'name': 'Rhiki Sulistiyo',
      'avatar': 'images/profil.png',
      'ticket': 'TICKET CONFIRMATION',
      'ticket_id': 'SYNCRA-102062023',
      
    },
  ].obs;
}

import 'package:get/get.dart';

class HistoryController extends GetxController {
  //TODO: Implement HistoryController

  final transcriptList = <Map<String, String>>[
    {
      'title': 'The Future of Neural Translation Models',
      'date': 'Oct 24, 2023',
      'author': 'Dr. Elena Rostova',
      'authorInitials': 'EL',
      'tag': 'AI',
    },
    {
      'title': 'Advancements in Quantum Machine Learning',
      'date': 'Nov 12, 2023',
      'author': 'Prof. Michael Chen',
      'authorInitials': 'MC',
      'tag': 'AI',
    },
    {
      'title': 'Exploring Ethical Boundaries in Artificial Intelligence',
      'date': 'Dec 5, 2023',
      'author': 'Dr. Sarah Johnson',
      'authorInitials': 'SJ',
      'tag': 'AI',
    },
    {
      'title': 'How Generative AI is Reshaping Digital Content',
      'date': 'Jan 8, 2024',
      'author': 'Alex Rivera',
      'authorInitials': 'AR',
      'tag': 'Tech',
    },
    {
      'title': 'The Rise of Edge Computing in IoT Systems',
      'date': 'Feb 14, 2024',
      'author': 'Dr. Priya Natarajan',
      'authorInitials': 'PN',
      'tag': 'IoT',
    },
    {
      'title': 'Cybersecurity Trends in the Age of AI',
      'date': 'Mar 3, 2024',
      'author': 'James O’Connor',
      'authorInitials': 'JO',
      'tag': 'Security',
    },
    {
      'title': 'Natural Language Processing for Low-Resource Languages',
      'date': 'Apr 21, 2024',
      'author': 'Dr. Lina Kovac',
      'authorInitials': 'LK',
      'tag': 'AI',
    },
    {
      'title': 'Building Scalable Microservices with Kubernetes',
      'date': 'May 10, 2024',
      'author': 'Daniel Schmidt',
      'authorInitials': 'DS',
      'tag': 'Backend',
    },
    {
      'title': 'Augmented Reality in Modern Mobile Applications',
      'date': 'Jun 18, 2024',
      'author': 'Emily Wong',
      'authorInitials': 'EW',
      'tag': 'AR',
    },
    // Lu bisa tambahin data lain di sini nanti
  ].obs;

  // Fungsi yang bakal dipanggil pas tombol Transcript diklik
  void downloadTranscript(String title) {
    print("Mendownload transcript untuk: $title");
    Get.snackbar("Downloading", "Menyiapkan file transcript...");
  }
}

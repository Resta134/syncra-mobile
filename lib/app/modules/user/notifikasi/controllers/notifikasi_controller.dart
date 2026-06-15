import 'package:get/get.dart';

class NotifikasiController extends GetxController {
  // Data dummy notifikasi dengan 3 tipe berbeda
  final notifications = [
    {
      'type': 'purchase', // Tipe: Pembelian Tiket
      'title': 'Pembelian Tiket Berhasil! 🎉',
      'message': 'Tiket untuk acara "Global Tech Summit 2026" berhasil ditambahkan ke akun Anda.',
      'time': 'Baru saja',
      'button_text': 'Lihat Tiket',
    },
    {
      'type': 'reminder', // Tipe: Pengingat Acara
      'title': 'Acara Segera Dimulai ⏰',
      'message': 'Live session "AI Ethics & Future of Work" bersama Dr. Mulyono akan dimulai dalam 15 Menit.',
      'time': '15 menit yang lalu',
      'button_text': 'Gabung Live',
    },
    {
      'type': 'new_event', // Tipe: Event Baru
      'title': 'Event Baru Dirilis! 🚀',
      'message': 'Jangan lewatkan event terbaru "AI in Healthcare Panel". Kuota terbatas, daftar sekarang!',
      'time': '2 jam yang lalu',
      'button_text': 'Lihat Detail',
    }
  ].obs;

  // Logika navigasi tombol berdasarkan tipe notifikasi
  void onNotificationTap(String type) {
    if (type == 'purchase') {
      Get.toNamed('/ticket'); // Arahkan ke menu tiket
    } else if (type == 'reminder') {
      Get.toNamed('/live'); // Arahkan ke ruang live
    } else if (type == 'new_event') {
      Get.toNamed('/dashboard'); // Arahkan ke detail event/home
    }
  }
}
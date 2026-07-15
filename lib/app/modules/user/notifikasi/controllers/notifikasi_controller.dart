import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotifikasiController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  var isLoading = false.obs;

  // List notifikasi dinamis
  final notifications = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      // 1. Ambil tiket milik user beserta detail event-nya
      final ticketsResponse = await _supabase
          .from('tickets')
          .select('''
        ticket_code,
        events (
          id,
          title,
          event_date,
          event_time,
          status
        )
      ''')
          .eq('user_id', userId);

      // 2. Ambil daftar event terbaru (limit 5)
      final eventsResponse = await _supabase
          .from('events')
          .select('id, title, event_date, status')
          .order('event_date', ascending: false)
          .limit(5);

      List<Map<String, String>> tempNotifications = [];

      // A. Generate notifikasi pembelian tiket (purchase) & pengingat (reminder)
      for (var item in ticketsResponse) {
        final event = item['events'];
        if (event == null) continue;

        final eventTitle = event['title'] ?? 'Event';
        final status = (event['status'] ?? '').toString().toLowerCase();

        // Notifikasi pembelian tiket
        tempNotifications.add({
          'type': 'purchase',
          'title': 'Pembelian Tiket Berhasil! 🎉',
          'message': 'Tiket untuk acara "$eventTitle" berhasil ditambahkan ke akun Anda.',
          'time': 'Aktif',
          'button_text': 'Lihat Tiket',
        });

        // Notifikasi pengingat acara (jika status live / ongoing)
        if (status == 'ongoing' || status == 'live') {
          tempNotifications.add({
            'type': 'reminder',
            'title': 'Acara Sedang Berlangsung! ⏰',
            'message': 'Live session untuk acara "$eventTitle" sedang berlangsung. Ayo gabung sekarang!',
            'time': 'Sekarang',
            'button_text': 'Gabung Live',
          });
        }
      }

      // B. Generate notifikasi event baru (new_event)
      for (var event in eventsResponse) {
        final eventTitle = event['title'] ?? 'Event Baru';
        final status = (event['status'] ?? '').toString().toLowerCase();
        
        if (status == 'upcoming') {
          tempNotifications.add({
            'type': 'new_event',
            'title': 'Event Baru Dirilis! 🚀',
            'message': 'Jangan lewatkan event terbaru "$eventTitle". Kuota terbatas, daftar sekarang!',
            'time': 'Baru',
            'button_text': 'Lihat Detail',
          });
        }
      }

      // C. Jika belum ada data sama sekali, tampilkan default welcome message
      if (tempNotifications.isEmpty) {
        tempNotifications.add({
          'type': 'new_event',
          'title': 'Selamat Datang di Syncra! 👋',
          'message': 'Temukan berbagai event menarik dan kelola tiket Anda secara langsung di aplikasi ini.',
          'time': 'Baru saja',
          'button_text': 'Lihat Event',
        });
      }

      notifications.value = tempNotifications;
    } catch (e) {
      print("Error fetching notifications: $e");
      Get.snackbar(
        'Gagal Memuat',
        'Tidak dapat memperbarui notifikasi.',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Logika navigasi tombol berdasarkan tipe notifikasi
  void onNotificationTap(String type) {
    if (type == 'purchase') {
      Get.toNamed('/ticket'); // Arahkan ke menu tiket
    } else if (type == 'reminder') {
      Get.toNamed('/live'); // Arahkan ke ruang live
    } else if (type == 'new_event') {
      Get.toNamed('/events'); // Arahkan ke menu daftar event
    }
  }
}
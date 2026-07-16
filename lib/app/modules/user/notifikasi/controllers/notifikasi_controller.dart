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

  final Map<String, dynamic> _liveEventDataCache = {};

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      // 1. PERBAIKAN: Hapus 'speaker' dan 'viewers' dari query select agar tidak error 42703!
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

      // 2. PERBAIKAN: Hapus juga dari query event terbaru
      final eventsResponse = await _supabase
          .from('events')
          .select('id, title, event_date, status')
          .order('event_date', ascending: false)
          .limit(5);

      List<Map<String, String>> tempNotifications = [];

      for (var item in ticketsResponse) {
        final event = item['events'];
        if (event == null) continue;

        final eventId = event['id']?.toString() ?? '';
        final eventTitle = event['title'] ?? 'Event';
        final status = (event['status'] ?? '').toString().toLowerCase();

        tempNotifications.add({
          'type': 'purchase',
          'title': 'Pembelian Tiket Berhasil! 🎉',
          'message': 'Tiket untuk acara "$eventTitle" berhasil ditambahkan ke akun Anda.',
          'time': 'Aktif',
          'button_text': 'Lihat Tiket',
          'event_id': eventId,
        });

        if (status == 'ongoing' || status == 'live') {
          // Gunakan nilai default untuk speaker dan viewers jika kolom tidak ada di DB
          _liveEventDataCache[eventId] = {
            'id': eventId,
            'title': eventTitle,
            'speaker': event['speaker_name'] ?? event['pembicara'] ?? 'Speaker Syncra',
            'viewers': '1.2K',
          };

          tempNotifications.add({
            'type': 'reminder',
            'title': 'Acara Sedang Berlangsung! ⏰',
            'message': 'Live session untuk acara "$eventTitle" sedang berlangsung. Ayo gabung sekarang!',
            'time': 'Sekarang',
            'button_text': 'Gabung Live',
            'event_id': eventId,
          });
        }
      }

      for (var event in eventsResponse) {
        final eventId = event['id']?.toString() ?? '';
        final eventTitle = event['title'] ?? 'Event Baru';
        final status = (event['status'] ?? '').toString().toLowerCase();
        
        if (status == 'upcoming') {
          tempNotifications.add({
            'type': 'new_event',
            'title': 'Event Baru Dirilis! 🚀',
            'message': 'Jangan lewatkan event terbaru "$eventTitle". Kuota terbatas, daftar sekarang!',
            'time': 'Baru',
            'button_text': 'Lihat Detail',
            'event_id': eventId,
          });
        }
      }

      if (tempNotifications.isEmpty) {
        tempNotifications.add({
          'type': 'new_event',
          'title': 'Selamat Datang di Syncra! 👋',
          'message': 'Temukan berbagai event menarik dan kelola tiket Anda secara langsung di aplikasi ini.',
          'time': 'Baru saja',
          'button_text': 'Lihat Event',
          'event_id': '',
        });
      }

      notifications.value = tempNotifications;
    } catch (e) {
      print("❌ Error fetching notifications: $e");
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

  // Fungsi navigasi saat tombol di notifikasi diklik
  void onNotificationTap(Map<String, String> notifItem) {
    final type = notifItem['type'] ?? '';
    final eventId = notifItem['event_id'] ?? '';

    if (type == 'purchase') {
      Get.toNamed('/ticket');
    } else if (type == 'reminder') {
      // Ambil data dari cache, atau gunakan data darurat jika eventId tidak ada di cache
      final eventArgs = _liveEventDataCache[eventId] ?? {
        'id': eventId.isNotEmpty ? eventId : 'default_live_id',
        'title': notifItem['message']?.replaceAll('Live session untuk acara "', '').replaceAll('" sedang berlangsung. Ayo gabung sekarang!', '') ?? 'Live Session Syncra',
        'speaker': 'Moderator Syncra',
        'viewers': '1.0K',
      };
      
      // Kirim arguments yang aman ke halaman Live!
      Get.toNamed('/live', arguments: eventArgs);
    } else if (type == 'new_event') {
      Get.toNamed('/events');
    }
  }
}
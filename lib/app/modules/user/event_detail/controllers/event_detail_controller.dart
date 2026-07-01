import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

class EventDetailController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  late Map<String, dynamic> eventData;
  var hasTicket = false.obs;
  var ticketCode = "".obs; 

  // ==========================================
  // TAMBAHAN BARU: Variabel Reaktif Pemateri
  // ==========================================
  var speaker1 = ''.obs;
  var speaker2 = ''.obs;
  var speaker3 = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      eventData = Get.arguments as Map<String, dynamic>;
      
      // Mengambil data pemateri dari arguments (Jika null, jadikan string kosong)
      speaker1.value = eventData['speaker_1'] ?? '';
      speaker2.value = eventData['speaker_2'] ?? '';
      speaker3.value = eventData['speaker_3'] ?? '';

      // Begitu halaman dibuka, langsung cek ke database apakah user ini udah beli tiket
      checkTicketStatus(); 
    } else {
      eventData = {'title': 'Event Tidak Ditemukan', 'description': ''};
    }
  }

  // ==========================================
  // 1. FUNGSI CEK DATABASE: Apakah tiket sudah dibeli?
  // ==========================================
  Future<void> checkTicketStatus() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return; 

      final eventId = eventData['id']; 

      final response = await _supabase
          .from('tickets')
          .select()
          .eq('user_id', userId)
          .eq('event_id', eventId);

      if (response.isNotEmpty) {
        hasTicket.value = true;
        ticketCode.value = response.first['ticket_code']; 
      } else {
        hasTicket.value = false;
      }
    } catch (e) {
      print("Error cek tiket: $e");
    }
  }

  // ==========================================
  // 2. FUNGSI SIMPAN DATABASE: Proses Beli Tiket
  // ==========================================
  void buyTicket() {
    Get.showOverlay(
      loadingWidget: Container(
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.8)),
        child: const Center(child: CircularProgressIndicator()),
      ),
      asyncFunction: () async {
        try {
          final userId = _supabase.auth.currentUser?.id;
          final eventId = eventData['id'];
          
          if (userId == null || eventId == null) {
            Get.snackbar('Error', 'Data user atau event tidak valid.');
            return;
          }

          final newTicketCode = "SYNCRA-${Random().nextInt(9000) + 1000}";

          await _supabase.from('tickets').insert({
            'user_id': userId,
            'event_id': eventId,
            'ticket_code': newTicketCode,
          });

          hasTicket.value = true;
          ticketCode.value = newTicketCode;

          Get.snackbar(
            'Pembelian Berhasil!',
            'Tiket Anda telah tersimpan di database.',
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green,
            snackPosition: SnackPosition.TOP,
          );
        } catch (e) {
          Get.snackbar('Gagal Membeli Tiket', e.toString(), backgroundColor: Colors.red.withOpacity(0.1));
        }
      },
    );
  }

  // ==========================================
  // FUNGSI NAVIGASI & AKSI
  // ==========================================
  void goToLive() {
    if (hasTicket.value) {
      Get.toNamed('/live', arguments: eventData);
    } else {
      lockticket();
    }
  }

  void goToPembayaran() {
    Get.toNamed('/payment', arguments: eventData);
  }

  void lockticket() {
    Get.snackbar(
      'Akses Terkunci', 
      'Silakan beli tiket terlebih dahulu.', 
      backgroundColor: Colors.red.withOpacity(0.1), 
      colorText: Colors.red,
      snackPosition: SnackPosition.TOP,
    );
  }

  // ==========================================
  // GETTER DATA (Mempermudah pemanggilan di UI)
  // ==========================================
  String get title => eventData['title'] ?? 'Tanpa Judul';
  String get description => eventData['description'] ?? '-';
  String get location => eventData['location'] ?? 'Online';
  String get status => (eventData['status'] ?? 'Upcoming').toString().toUpperCase();
  String get imageUrl => eventData['image_url'] ?? '';
  String get eventDateTime => "${eventData['event_date'] ?? 'TBA'} | ${eventData['event_time']?.toString().substring(0, 5) ?? ''} WIB";

  String get eventPrice {
    final price = eventData['price'];
    
    if (price == null || price == 0 || price.toString() == '0') {
      return 'Gratis';
    }
    
    String priceStr = price.toString();
    String formatted = '';
    int counter = 0;
    
    for (int i = priceStr.length - 1; i >= 0; i--) {
      counter++;
      formatted = priceStr[i] + formatted;
      if (counter % 3 == 0 && i != 0) {
        formatted = '.$formatted';
      }
    }
    
    return 'Rp $formatted';
  }
}
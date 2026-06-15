import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

class PaymentController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Menampung data event dari halaman sebelumnya
  late Map<String, dynamic> eventData;
  var selectedMethod = ''.obs; // Untuk animasi pilih metode

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      eventData = Get.arguments as Map<String, dynamic>;
    } else {
      eventData = {'title': 'Unknown', 'price': 0};
    }
  }

  // Memformat harga dari database ke Rupiah (Menggantikan countPayment dummy)
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

  // Fungsi untuk memilih metode pembayaran di UI
  void selectMethod(String method) {
    selectedMethod.value = method;
  }

  // FUNGSI UTAMA: Simpan database & Munculkan Dialog
  void processSuccessPayment() async {
    // 1. Validasi: Jika event berbayar tapi metode belum dipilih
    if (eventPrice != 'Gratis' && selectedMethod.value == '') {
      Get.snackbar(
        'Perhatian', 
        'Silakan pilih metode pembayaran terlebih dahulu.', 
        backgroundColor: Colors.orange.withOpacity(0.1), 
        colorText: Colors.orange,
      );
      return;
    }

    // 2. Tampilkan Dialog Sukses (Kode custom milikmu)
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.green,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                "Pembayaran Berhasil!", // Di-Indonesiakan agar selaras
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Mengarahkan ke Registrasi Wajah...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false, // User tidak bisa menutup dialog secara manual
    );

    try {
      // 3. Simpan data tiket ke database Supabase secara *background*
      final userId = _supabase.auth.currentUser?.id;
      final eventId = eventData['id'];

      if (userId != null && eventId != null) {
        final newTicketCode = "SYNCRA-${Random().nextInt(9000) + 1000}";
        await _supabase.from('tickets').insert({
          'user_id': userId,
          'event_id': eventId,
          'ticket_code': newTicketCode,
        });
      }

      // 4. Tunggu minimal 2 detik (Sesuai kodemu agar UX loading-nya terlihat natural)
      await Future.delayed(const Duration(seconds: 2));

      // 5. Tutup dialog dan lempar ke halaman Face Registration
      if (Get.isDialogOpen == true) {
        Get.back(); 
      }
      
      // Pakai Get.offNamed agar tidak bisa di-back ke halaman pembayaran lagi
      // Kita juga bawa eventData (arguments) siapa tau di Face Registration butuh ID Event-nya
      Get.offNamed('/faceregistration', arguments: eventData); 

    } catch (e) {
      // Jika error database (misal mati lampu), tutup dialog dan beritahu user
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      Get.snackbar('Gagal Memproses', e.toString(), backgroundColor: Colors.red.withOpacity(0.1));
    }
  }
}
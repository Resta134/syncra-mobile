import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart'; // Tambahan untuk akses Galeri/Kamera
import 'dart:math';
import 'package:tranlator_v1/app/utils/audit_log.dart';

class PaymentController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();

  late Map<String, dynamic> eventData;
  var selectedMethod = ''.obs; 

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      eventData = Get.arguments as Map<String, dynamic>;
    } else {
      eventData = {'title': 'Unknown', 'price': 0};
    }
  }

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

  void selectMethod(String method) {
    selectedMethod.value = method;
  }

  // ========================================================
  // FUNGSI UTAMA: Pengecekan sebelum proses
  // ========================================================
  void processSuccessPayment() {
    if (eventPrice != 'Gratis' && selectedMethod.value == '') {
      Get.snackbar(
        'Perhatian',
        'Silakan pilih metode pembayaran terlebih dahulu.',
        backgroundColor: Colors.orange.withOpacity(0.1),
        colorText: Colors.orange,
      );
      return;
    }

    if (eventPrice == 'Gratis') {
      // Jika gratis, langsung proses tanpa upload foto
      _finalizeAndSaveTicket(isFree: true);
    } else {
      // Jika berbayar, minta user upload bukti transfer dulu
      _showImageSourceActionSheet();
    }
  }

  // ========================================================
  // TAMPILAN PILIH KAMERA / GALERI
  // ========================================================
  void _showImageSourceActionSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Upload Bukti Pembayaran",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blue),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Get.back();
                _pickAndUploadImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text('Ambil Foto Kamera'),
              onTap: () {
                Get.back();
                _pickAndUploadImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ========================================================
  // PROSES UPLOAD FOTO KE SUPABASE STORAGE
  // ========================================================
  Future<void> _pickAndUploadImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 70, // Kompres ukuran gambar agar cepat diupload
      );

      if (image == null) return; // User batal memilih foto

      // Tampilkan Loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final File file = File(image.path);
      final String fileExt = image.path.split('.').last;
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final userId = _supabase.auth.currentUser?.id ?? 'unknown';
      final String filePath = '$userId/$fileName'; // Folder per user

      // Upload ke bucket 'payment_receipts'
      await _supabase.storage.from('payment_receipts').upload(filePath, file);

      // Ambil link publik fotonya
      final String publicUrl = _supabase.storage.from('payment_receipts').getPublicUrl(filePath);

      // Tutup Loading
      if (Get.isDialogOpen == true) Get.back();

      // Lanjut simpan data tiket dengan URL bukti bayar
      _finalizeAndSaveTicket(isFree: false, receiptUrl: publicUrl);

    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      Get.snackbar('Upload Gagal', e.toString(), backgroundColor: Colors.red.withOpacity(0.1));
    }
  }

  // ========================================================
  // SIMPAN DATABASE & PINDAH HALAMAN
  // ========================================================
  void _finalizeAndSaveTicket({required bool isFree, String? receiptUrl}) async {
    // Tampilkan Dialog Sukses
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 64),
              const SizedBox(height: 16),
              Text(
                isFree ? "Tiket Gratis Diklaim!" : "Bukti Terkirim!",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                isFree 
                    ? "Mengarahkan ke Registrasi Wajah..." 
                    : "Menunggu verifikasi admin. Lanjut ke Registrasi Wajah...",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              const CircularProgressIndicator(strokeWidth: 2.5),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      final userId = _supabase.auth.currentUser?.id;
      final eventId = eventData['id'];
      final eventTitle = eventData['title'] ?? 'Unknown Event';

      if (userId != null && eventId != null) {
        final newTicketCode = "SYNCRO-${Random().nextInt(9000) + 1000}";
        
        // Simpan ke database beserta kolom baru
        await _supabase.from('tickets').insert({
          'user_id': userId,
          'event_id': eventId,
          'ticket_code': newTicketCode,
          'payment_receipt_url': receiptUrl, // Masuk jika ada foto
          'payment_status': isFree ? 'Lunas' : 'Menunggu Konfirmasi', // Status dinamis
        });

        // Catat di Audit Log
        final metodeDipakai = isFree ? "Gratis/Free Tier" : selectedMethod.value;
        await AuditLog.record(
          'TICKET_PURCHASE_SUCCESS',
          'Pengguna memperoleh tiket Event: "$eventTitle" (ID: $eventId). Kode: $newTicketCode. Metode: $metodeDipakai.'
        );
      }

      await Future.delayed(const Duration(seconds: 2));

      if (Get.isDialogOpen == true) Get.back();
      
      Get.offNamed('/faceregistration', arguments: eventData);

    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      await AuditLog.record(
        'TICKET_PURCHASE_FAILED',
        'Gagal memproses tiket untuk Event ID: ${eventData['id']}. Error: ${e.toString()}'
      );
      Get.snackbar('Gagal Memproses', e.toString(), backgroundColor: Colors.red.withOpacity(0.1));
    }
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tranlator_v1/app/utils/audit_log.dart';

class QaController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  // State reaktif untuk menampung data dari Supabase
  var questions = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    
    // Langsung buka keran aliran data saat halaman diinisialisasi
    // Tidak perlu lagi menunggu atau mencari ID Event
    _listenToQuestions();
  }

  // ==========================================
  // 1. STREAM DATA REAL-TIME SEMUA PERTANYAAN
  // ==========================================
  void _listenToQuestions() {
    print("====== MENGAMBIL SEMUA DATA PERTANYAAN DARI SUPABASE ======");

    _supabase
        .from('questions')
        .stream(primaryKey: ['id'])
        // Filter .eq('event_id', ...) sudah DIHAPUS agar semua data masuk
        .order('created_at', ascending: true) 
        .listen((List<Map<String, dynamic>> data) {
          
      print("====== TOTAL DATA MASUK: ${data.length} BARIS ======");
          
      // Filter di sisi Dart untuk membuang status 'dismissed' (dihapus oleh moderator)
      final filteredData = data.where((q) => q['status'] != 'dismissed').toList();

      // Konversi ke format UI
      questions.value = filteredData.map((q) => {
        'id': q['id'],
        'sender': q['sender_name'] ?? 'Peserta', 
        'text': q['text'],
        'status': q['status'],
      }).toList();
      
    }).onError((error) {
      print("========= ERROR STREAM Q&A =========");
      print(error);
      print("====================================");
    });
  }

  // ==========================================
  // 2. FUNGSI HAPUS PERTANYAAN (DISMISS)
  // ==========================================
  Future<void> dismissQuestion(String id) async {
    try {
      await _supabase
          .from('questions')
          .update({'status': 'dismissed'})
          .eq('id', id);

      _showSafeSnackbar('Dihapus', 'Pertanyaan disingkirkan dari antrean.', Colors.grey.shade800);
    } catch (e) {
      print("Error dismiss: $e");
      _showSafeSnackbar('Gagal', 'Gagal menghapus data.', Colors.red.shade700);
    }
  }

  // ==========================================
  // 3. FUNGSI SETUJUI PERTANYAAN (APPROVE)
  // ==========================================
  Future<void> approveQuestion(String id) async {
    try {
      await _supabase
          .from('questions')
          .update({'status': 'approved'})
          .eq('id', id);
          
      // ==========================================
      // 🔴 TANAM LOG DI SINI (Proses berhasil)
      // ==========================================
      await AuditLog.record(
        'MODERATOR_APPROVE_QNA', 
        'Moderator menyetujui pertanyaan ID: $id untuk tampil ke layar publik.'
      );
          
      _showSafeSnackbar('Disetujui', 'Pertanyaan dikirim ke layar publik.', Colors.green.shade700);
    } catch (e) {
      print("Error approve: $e");
      _showSafeSnackbar('Gagal', 'Gagal menyetujui pertanyaan.', Colors.red.shade700);
    }
  }

  // ==========================================
  // 4. FUNGSI PROYEKSI KE LAYAR (PROJECTING)
  // ==========================================
  Future<void> projectToScreen(String id) async {
    try {
      // Langkah A: Turunkan SEMUA pertanyaan yang sedang 'projecting' di database menjadi 'approved'
      await _supabase
          .from('questions')
          .update({'status': 'approved'})
          // Filter eventId di sini juga dihapus agar otomatis mereset secara global
          .eq('status', 'projecting');

      // Langkah B: Naikkan pertanyaan yang baru saja diklik menjadi 'projecting'
      await _supabase
          .from('questions')
          .update({'status': 'projecting'})
          .eq('id', id);

      _showSafeSnackbar('On Screen', 'Tampil di proyektor & layar utama pembicara!', Colors.blue.shade700);
    } catch (e) {
      print("Error project: $e");
      _showSafeSnackbar('Gagal', 'Gagal menampilkan ke layar.', Colors.red.shade700);
    }
  }

  // ==========================================
  // 5. FUNGSI AKHIRI SESI
  // ==========================================
  void stopQuestion() {
    _showSafeSnackbar('Sesi Ditutup', 'Sesi tanya jawab live telah diakhiri.', Colors.orange.shade800);
  }

  // ==========================================
  // NATIVE SNACKBAR: BEBAS BUG ANIMASI GETX
  // ==========================================
  void _showSafeSnackbar(String title, String message, Color bgColor) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.context != null) {
        ScaffoldMessenger.of(Get.context!).clearSnackBars();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                const SizedBox(height: 2),
                Text(message, style: const TextStyle(fontSize: 12, color: Colors.white70)),
              ],
            ),
            backgroundColor: bgColor,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }
}
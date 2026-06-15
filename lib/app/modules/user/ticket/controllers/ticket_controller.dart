import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TicketController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  // State Loading saat mengambil data
  var isLoading = true.obs;

  // Menyimpan daftar tiket berdasarkan status (Otomatis dipisah)
  var upcomingTickets = <Map<String, dynamic>>[].obs;
  var completedTickets = <Map<String, dynamic>>[].obs;

  // Data Profil User untuk ditampilkan di QR Code
  var userName = 'User Syncra'.obs;

  @override
  void onInit() {
    super.onInit();
    getUserProfile();
    fetchMyTickets();
  }

  // ==========================================
  // 1. Ambil Nama User dari Sesi Login
  // ==========================================
  void getUserProfile() {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      userName.value =
          user.userMetadata?['full_name'] ??
          user.userMetadata?['name'] ??
          'User Syncra';
    }
  }

  // ==========================================
  // 2. Ambil Data Tiket & Event dari Supabase
  // ==========================================
  Future<void> fetchMyTickets() async {
    try {
      isLoading.value = true;
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      // Query Join: Mengambil tiket milik user beserta detail event-nya
      final response = await _supabase
          .from('tickets')
          .select('''
        ticket_code,
        event_id,
        events (
          id,
          title,
          event_date,
          event_time,
          status,
          speaker_1
        )
      ''')
          .eq('user_id', userId);

      final List<Map<String, dynamic>> upcoming = [];
      final List<Map<String, dynamic>> completed = [];

      for (var item in response) {
        final eventData = item['events'];
        if (eventData == null)
          continue; // Lewati jika data event terhapus/hilang

        final ticketInfo = {
          'ticket_code': item['ticket_code'] ?? '-',
          'title': eventData['title'] ?? 'Tanpa Judul',
          'date': eventData['event_date'] ?? '',
          'time': eventData['event_time'] ?? '',
          'status': eventData['status'] ?? 'Upcoming',
          'speaker': eventData['speaker_1'] ?? 'Admin Syncra',
          'event_id': eventData['id'],
        };

        // Pisahkan ke dalam list berdasarkan status event
        final status = ticketInfo['status'].toString().toUpperCase();
        if (status == 'COMPLETED') {
          completed.add(ticketInfo);
        } else {
          upcoming.add(ticketInfo);
        }
      }

      // Masukkan ke variabel state GetX
      upcomingTickets.value = upcoming;
      completedTickets.value = completed;
    } catch (e) {
      print("Error Fetch Tickets: $e");
      Get.snackbar(
        'Error',
        'Gagal memuat tiket Anda.',
        backgroundColor: Colors.red.withOpacity(0.1),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ==========================================
  // 3. POP-UP QR CODE (Dibuat Dinamis & Bahasa Indonesia)
  // ==========================================
  void popUp(String ticketId, String eventTitle) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // --- CONTAINER TIKET ATAS ---
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                  ),
                  child: Column(
                    children: [
                      // Header Hijau
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const BoxDecoration(
                          color: Color(0xFF34A853),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_box_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "KONFIRMASI TIKET", // <-- Bahasa Indonesia
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Isi Detail Tiket & QR Code
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Event Title (Tetap dinamis dari database)
                            Center(
                              child: Text(
                                eventTitle,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                  color: Color(0xFF1E293B),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const Divider(height: 30),

                            // Profil Info
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.blue[100],
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Obx(
                                  () => Text(
                                    userName.value,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // ID Tiket
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "ID Tiket",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ), // <-- Bahasa Indonesia
                                Text(
                                  ticketId,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),

                            // Verifikasi
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Verifikasi Wajah",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ), // <-- Bahasa Indonesia
                                Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Color(0xFF34A853),
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "SELESAI", // <-- Bahasa Indonesia
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF34A853),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(height: 30),

                            // Bagian QR Code
                            Center(
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.qr_code_2,
                                    size: 200,
                                    color: Color(0xFF1E293B),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Pindai QR Code ini di pintu masuk acara", // <-- Bahasa Indonesia
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.85),
    );
  }

  // ==========================================
  // Navigasi
  // ==========================================
  void goToLive() => Get.toNamed('/live');
  void goToDashboard() => Get.toNamed('/dashboard');
  void goToProfil() => Get.toNamed('/profil');
  void goToTicket() => Get.toNamed('/ticket');
}

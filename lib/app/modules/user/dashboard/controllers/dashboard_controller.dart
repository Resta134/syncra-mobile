import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Menggunakan tipe dynamic karena data dari Supabase bervariasi (teks, tanggal, dll)
  var liveStreamData = <Map<String, dynamic>>[].obs;
  var upcomingEventsData = <Map<String, dynamic>>[].obs;

  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Tarik data event otomatis saat halaman beranda dibuka
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      isLoading.value = true;

      // Menarik semua data dari tabel 'events' di Supabase
      final List<dynamic> response = await _supabase.from('events').select();

      // Kosongkan list agar tidak numpuk saat halaman di-refresh
      liveStreamData.clear();
      upcomingEventsData.clear();

      // Memilah data berdasarkan kolom 'status' di tabel
      for (var event in response) {
        // Cek status dengan aman (dijadikan huruf kecil semua)
        final status = (event['status'] ?? '').toString().toLowerCase();
        
        // KITA UBAH DI SINI: Deteksi kata 'ongoing' ATAU 'live'
        if (status == 'ongoing' || status == 'live') {
          liveStreamData.add(event as Map<String, dynamic>);
        } else if (status == 'upcoming') {
          upcomingEventsData.add(event as Map<String, dynamic>);
        }
      }
    } catch (e) {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Gagal memuat data event dari server.",
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
        colorText: Get.theme.colorScheme.error,
      );
      print("Error fetchEvents: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // --- Fungsi Navigasi (Sesuaikan rutenya dengan nama rute aslimu) ---
  void goToNotifikasi() {
    Get.toNamed('/notifikasi');
  }

  void goToEvents() {
    Get.toNamed('/events');
  }

  void goToLive() {
    Get.toNamed('/live');
  }

  void goToEventDetail(Map<String, dynamic> data) {
    Get.toNamed('/event-detail', arguments: data);
  }
}

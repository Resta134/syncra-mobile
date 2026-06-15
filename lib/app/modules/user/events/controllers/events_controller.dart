import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventsController extends GetxController {
  // Inisialisasi Supabase
  final SupabaseClient _supabase = Supabase.instance.client;

  // Variabel penampung data (sekarang dinamis menyesuaikan database)
  var upcomingEventsData = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs; // Untuk animasi muter-muter (loading)

  @override
  void onInit() {
    super.onInit();
    // Tarik data otomatis begitu halaman "Semua Event" dibuka
    fetchUpcomingEvents();
  }

  // Fungsi untuk menarik data dari Supabase
  Future<void> fetchUpcomingEvents() async {
    try {
      isLoading.value = true;

      // PERUBAHAN DI SINI: Gunakan .ilike alih-alih .eq
      // .ilike akan mengabaikan huruf besar/kecil, jadi "Upcoming", "UPCOMING", dll akan terbaca
      final List<dynamic> response = await _supabase
          .from('events')
          .select()
          .ilike(
            'status',
            '%upcoming%',
          ); // Ditambah % % untuk berjaga-jaga kalau ada spasi yang tidak sengaja terketik di database

      upcomingEventsData.clear();

      for (var event in response) {
        upcomingEventsData.add(event as Map<String, dynamic>);
      }
    } catch (e) {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Gagal memuat daftar event.",
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
        colorText: Get.theme.colorScheme.error,
      );
      print("Error ambil data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi navigasi yang sudah di-update agar MEMBAWA DATA
  void goToEventDetail(Map<String, dynamic> eventData) {
    // Rute pindah halaman sambil melempar 'arguments' ke halaman detail
    Get.toNamed('/event-detail', arguments: eventData);
  }
}

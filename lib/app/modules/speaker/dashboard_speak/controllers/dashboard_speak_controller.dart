import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardSpeakController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Variabel Reaktif (State)
  var isLoading = true.obs;
  var speakerName = 'User'.obs;

  // Dua wadah berbeda untuk memisahkan status acara
  var liveEvents = <Map<String, dynamic>>[].obs;
  var upcomingEvents = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _getUserProfile();
    fetchSpeakerEvents();
  }

  // ==========================================
  // 1. Ambil Nama User yang Sedang Login
  // ==========================================
  void _getUserProfile() {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      speakerName.value =
          user.userMetadata?['full_name'] ??
          user.userMetadata?['name'] ??
          'Speaker Syncra';
    }
  }

  // ==========================================
  // 2. Ambil Data Event dari Supabase
  // ==========================================
  Future<void> fetchSpeakerEvents() async {
    try {
      isLoading.value = true;

      // Ambil data event (Opsional: tambahkan .eq('speaker_1', speakerName.value) jika ingin memfilter event khusus speaker ini saja)
      final response = await _supabase
          .from('events')
          .select()
          .order('event_date', ascending: true);

      final List<Map<String, dynamic>> live = [];
      final List<Map<String, dynamic>> upcoming = [];

      // Memilah data berdasarkan status
      for (var event in response) {
        final status = event['status'].toString().toUpperCase();

        if (status == 'ONGOING' || status == 'LIVE') {
          live.add(event);
        } else if (status == 'UPCOMING') {
          upcoming.add(event);
        }
      }

      // Masukkan ke dalam variabel reaktif
      liveEvents.value = live;
      upcomingEvents.value = upcoming;
    } catch (e) {
      print("Error fetching events: $e");
      Get.snackbar('Error', 'Gagal memuat jadwal acara.');
    } finally {
      isLoading.value = false;
    }
  }

  // ==========================================
  // 3. Navigasi
  // ==========================================
  void goToPresent(Map<String, dynamic> eventData) {
    // Membawa data event saat masuk ke ruang presentasi
    Get.toNamed('/speaker', arguments: eventData);
  }
}

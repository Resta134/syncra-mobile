import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserValidationController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Variabel untuk fitur Search di UI
  var searchQuery = ''.obs;

  // Penampung data gabungan (Kehadiran + Profil)
  var participants = <Map<String, dynamic>>[].obs;

  String eventName = '';

  @override
  void onInit() {
    super.onInit();
    
    // Menangkap argumen nama event dari halaman sebelumnya
    if (Get.arguments != null) {
      eventName = Get.arguments['title'] ?? Get.arguments['nama_event'] ?? Get.arguments['name'] ?? '';
    }

    _listenToAttendanceTable();
  }

  // ==========================================
  // 1. LOGIKA SEARCH BAR (OTOMATIS FILTER)
  // ==========================================
  List<Map<String, dynamic>> get filteredParticipants {
    if (searchQuery.value.isEmpty) {
      return participants; 
    }
    
    return participants.where((person) {
      final name = person['name'].toString().toLowerCase();
      final id = person['id'].toString().toLowerCase();
      final query = searchQuery.value.toLowerCase();
      
      return name.contains(query) || id.contains(query);
    }).toList();
  }

  // ==========================================
  // 2. STREAM DARI TABEL 'attendance'
  // ==========================================
  void _listenToAttendanceTable() {
    
    // A. Buat fungsi pemroses data agar bisa dipanggil dengan aman
    void processData(List<Map<String, dynamic>> data) async {
      if (data.isEmpty) {
        participants.value = [];
        return;
      }

      List<Map<String, dynamic>> tempParticipants = [];
      List<String> userIds = [];

      for (var item in data) {
        String userId = item['user_id']?.toString() ?? '';
        if (userId.isNotEmpty && !userIds.contains(userId)) {
          userIds.add(userId);
        }

        String displayId = item['ticket_code'] ?? item['id'].toString().substring(0, 8).toUpperCase();

        tempParticipants.add({
          'id': displayId, 
          'user_id': userId,
          'status': 'Present', 
          'created_at': item['created_at'] ?? '', 
        });
      }

      Map<String, String> userNames = {};
      if (userIds.isNotEmpty) {
        try {
          final profilesResponse = await _supabase
              .from('profiles')
              .select('id, full_name, name')
              .inFilter('id', userIds); // Gunakan .in_('id', userIds) jika pakai package versi terbaru

          for (var profile in profilesResponse) {
            userNames[profile['id'].toString()] = profile['full_name'] ?? profile['name'] ?? 'Peserta Anonim';
          }
        } catch (e) {
          print("Error fetch profil peserta: $e");
        }
      }

      List<Map<String, dynamic>> finalParticipants = [];
      for (var p in tempParticipants) {
        String uid = p['user_id'];
        
        finalParticipants.add({
          'id': p['id'],
          'name': userNames[uid] ?? 'Peserta Anonim',
          'status': p['status'],
          'created_at': p['created_at'],
        });
      }

      finalParticipants.sort((a, b) => b['created_at'].compareTo(a['created_at']));
      participants.value = finalParticipants;
    }

    // B. Jalankan Stream dengan if-else (Menghindari error tipe data)
    if (eventName.isNotEmpty) {
      _supabase
          .from('attendance')
          .stream(primaryKey: ['id'])
          .eq('event_name', eventName)
          .listen(processData); // <-- Panggil di sini jika ada nama event
    } else {
      _supabase
          .from('attendance')
          .stream(primaryKey: ['id'])
          .listen(processData); // <-- Panggil di sini jika tidak difilter
    }
  }
}
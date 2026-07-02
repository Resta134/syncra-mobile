import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';

class AuditLog {
  static final SupabaseClient _supabase = Supabase.instance.client;
  static final Logger _logger = Logger();

  // Fungsi pemanggil log
  static Future<void> record(String action, String description) async {
    try {
      final user = _supabase.auth.currentUser;
      
      // Log hanya dicatat jika ada user yang sedang login
      if (user != null) {
        await _supabase.from('system_logs').insert({
          'user_id': user.id,
          'action': action,
          'description': description,
        });
        _logger.i("📝 [AUDIT LOG]: $action berhasil dicatat ke database.");
      }
    } catch (e) {
      // Jika log gagal (misal sinyal putus), aplikasi tidak boleh crash
      _logger.e("🚨 [AUDIT LOG ERROR]: Gagal mencatat $action", error: e);
    }
  }
}
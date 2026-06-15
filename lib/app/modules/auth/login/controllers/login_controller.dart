import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Controller untuk form input
  final emailC = TextEditingController();
  final passC = TextEditingController();

  // State untuk animasi loading pada tombol
  var isLoading = false.obs;

  // Fungsi navigasi ke halaman pendaftaran (Register)
  void goToSignUp() {
    Get.toNamed('/register');
  }

  Future<void> loginUser() async {
    final email = emailC.text.trim();
    final password = passC.text.trim();

    // 1. Validasi form kosong
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Gagal Masuk", 
        "Email dan Password tidak boleh kosong!",
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return;
    }

    try {
      isLoading.value = true;

      // 2. Autentikasi ke sistem Supabase
      final AuthResponse response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // 3. AMBIL DATA ROLE USER DARI TABEL PROFILES
        // Kita cek user ini jabatannya apa di kolom package_tier
        final userData = await _supabase
            .from('profiles')
            .select('package_tier')
            .eq('id', response.user!.id)
            .maybeSingle(); // Ambil 1 baris data profil user tersebut

        // Jika package_tier kosong, anggap sebagai 'Peserta' atau 'Free'
        String userRole = userData?['package_tier'] ?? 'Peserta';

        Get.snackbar(
          "Berhasil Masuk", 
          "Selamat datang, akses sebagai $userRole diberikan.",
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          snackPosition: SnackPosition.TOP,
        );

        // Bersihkan form
        emailC.clear();
        passC.clear();

        // 4. LOGIKA PERCABANGAN HALAMAN (Sesuai kode lama kamu)
        // Kita ubah teksnya jadi huruf kecil semua biar pencocokan namanya kebal dari typo huruf kapital
        String roleLower = userRole.toLowerCase();

        if (roleLower == 'speaker') {
          // Arahkan pemateri ke Dashboard Speaker
          Get.offAllNamed('/dashboard-speak'); 
        } else if (roleLower == 'moderator') {
          // Arahkan moderator ke Dashboard Moderator
          Get.offAllNamed('/dashboard-mod');
        } else if (roleLower == 'gatekeeper') {
          // Arahkan penjaga gerbang ke Dashboard Gatekeeper
          Get.offAllNamed('/dashboard-gatekeeper');
        } else {
          // Arahkan peserta biasa atau role lain ke Dashboard umum
          Get.offAllNamed('/dashboard');
        }
      }
    } on AuthException catch (e) {
      Get.snackbar(
        "Otentikasi Gagal", 
        "Email atau password salah.",
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } catch (e) {
      Get.snackbar(
        "Terjadi Kesalahan", 
        e.toString(),
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailC.dispose();
    passC.dispose();
    super.onClose();
  }
}
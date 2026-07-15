import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart' as g_auth;
import 'package:tranlator_v1/app/utils/audit_log.dart';

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

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      // Web Client ID dari Google Cloud Console
      const webClientId =
          '303118747448-8cn075h1q85c0p7t6nkhmu7csttbhjr0.apps.googleusercontent.com';

      final g_auth.GoogleSignIn googleSignIn = g_auth.GoogleSignIn(
        serverClientId: webClientId,
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return; // Dibatalkan oleh user
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        Get.snackbar('Error', 'Gagal mendapatkan token dari Google');
        return;
      }

      final AuthResponse response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.user != null) {
        // Cek/buat profile
        await _checkAndCreateProfile(response.user!);

        // Ambil data role user dari tabel profiles
        final userData = await _supabase
            .from('profiles')
            .select('package_tier')
            .eq('id', response.user!.id)
            .maybeSingle();

        String userRole = userData?['package_tier'] ?? 'Peserta';

        await AuditLog.record(
          'USER_LOGIN_GOOGLE_SUCCESS',
          'Pengguna (${response.user!.email}) berhasil masuk menggunakan Google dengan akses sebagai: $userRole.',
        );

        Get.snackbar(
          "Berhasil Masuk",
          "Selamat datang, akses sebagai $userRole diberikan.",
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );

        String roleLower = userRole.toLowerCase();

        if (roleLower == 'speaker') {
          Get.offAllNamed('/dashboard-speak');
        } else if (roleLower == 'moderator') {
          Get.offAllNamed('/dashboard-mod');
        } else if (roleLower == 'gatekeeper') {
          Get.offAllNamed('/dashboard-gatekeeper');
        } else {
          Get.offAllNamed('/dashboard');
        }
      }
    } catch (e) {
      print("Error Google Auth: $e");
      String failMsg = e.toString();
      if (failMsg.contains("sign_in_failed") || failMsg.contains("12500") || failMsg.contains("10")) {
        failMsg = "Google Sign-In gagal. Pastikan SHA-1 fingerprint aplikasi Anda telah didaftarkan di Google Cloud Console.";
      }
      Get.snackbar(
        'Gagal',
        failMsg,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 6),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _checkAndCreateProfile(User user) async {
    final existingProfile = await _supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (existingProfile == null) {
      await _supabase.from('profiles').insert({
        'id': user.id,
        'email': user.email,
        'full_name':
            user.userMetadata?['full_name'] ??
            user.userMetadata?['name'] ??
            'User Syncra',
        'package_tier': 'Free',
      });
    }
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

        await AuditLog.record(
          'USER_LOGIN_SUCCESS',
          'Pengguna ($email) berhasil masuk ke sistem dengan akses sebagai: $userRole.',
        );

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

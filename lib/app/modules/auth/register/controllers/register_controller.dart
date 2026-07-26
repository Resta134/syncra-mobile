import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart'
    as g_auth; // Mencegah konflik class

class RegisterController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;
  final isPasswordHidden = true.obs;

  // Controller untuk mengambil teks dari form
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();

  // State untuk animasi loading pada tombol
  var isLoading = false.obs;
  
  // NEW YE ===================================
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  final isPasswordValid = false.obs;
  void checkPassword(String value) {
    if (value.length >= 6) {
      isPasswordValid.value = true;
    } else {
      isPasswordValid.value = false;
    }
  }
  //==========================================================

  // ========================================================
  // 1. REGISTRASI MANUAL DENGAN EMAIL & PASSWORD (OTP)
  // ========================================================
  Future<void> registerAccount() async {
    final name = nameC.text.trim();
    final email = emailC.text.trim();
    final password = passC.text.trim();

    // Validasi Input Kosong
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Data Tidak Lengkap",
        "Semua kolom wajib diisi!",
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return;
    }

    // Validasi panjang password
    if (password.length < 6) {
      Get.snackbar(
        "Password Terlalu Pendek",
        "Password minimal harus terdiri dari 6 karakter.",
        backgroundColor: Colors.orange.withOpacity(0.1),
        colorText: Colors.orange,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Buat akun di Supabase Auth (Otomatis butuh verifikasi OTP)
      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Notifikasi OTP terkirim
        Get.snackbar(
          "Cek Email Anda",
          "Kode OTP 6 digit telah dikirim ke $email",
          backgroundColor: Colors.blue.withOpacity(0.1),
          colorText: Colors.blue[900],
          snackPosition: SnackPosition.TOP,
        );

        // Arahkan ke halaman Verifikasi OTP
        Get.toNamed(
          '/verify-otp',
          arguments: {'email': email, 'name': name, 'id': response.user!.id},
        );

        // Bersihkan form
        nameC.clear();
        emailC.clear();
        passC.clear();
        // NEW CIK
        isPasswordValid.value = false;
      }
    } on AuthException catch (e) {
      Get.snackbar(
        "Pendaftaran Gagal",
        e.message,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ========================================================
  // 2. REGISTRASI / LOGIN INSTAN DENGAN GOOGLE (SSO)
  // ========================================================
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      // Masukkan Web Client ID dari Google Cloud Console
      const webClientId =
          '303118747448-8cn075h1q85c0p7t6nkhmu7csttbhjr0.apps.googleusercontent.com';

      // Inisialisasi Google Sign In menggunakan alias g_auth
      final g_auth.GoogleSignIn googleSignIn = g_auth.GoogleSignIn(
        serverClientId:
            webClientId, // Ubah ke 'clientId' jika parameter ini tidak dikenali di versi Anda
      );

      // Munculkan pop-up pilihan akun Google
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return; // Dibatalkan oleh user
      }

      // Minta token autentikasi dari Google
      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        Get.snackbar('Error', 'Gagal mendapatkan token dari Google');
        return;
      }

      // Serahkan token tersebut ke Supabase
      final AuthResponse response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.user != null) {
        // Pastikan user baru ini terdaftar di tabel 'profiles'
        await _checkAndCreateProfile(response.user!);

        Get.snackbar(
          'Berhasil',
          'Selamat datang, ${response.user!.userMetadata?['full_name'] ?? 'User'}!',
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );

        // Lewati OTP, langsung arahkan ke dashboard
        Get.offAllNamed('/dashboard');
      }
    } catch (e) {
      print("Error Google Auth: $e");
      Get.snackbar(
        'Gagal',
        'Terjadi kesalahan saat otentikasi Google: $e',
        backgroundColor: Colors.red.withOpacity(0.1),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ========================================================
  // HELPER: MENYIMPAN DATA GOOGLE KE TABEL PROFILES
  // ========================================================
  Future<void> _checkAndCreateProfile(User user) async {
    final existingProfile = await _supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    // Jika data belum ada, berarti ini register baru. Jika sudah ada, berarti cuma login ulang.
    if (existingProfile == null) {
      await _supabase.from('profiles').insert({
        'id': user.id,
        'email': user.email,
        'full_name':
            user.userMetadata?['full_name'] ??
            user.userMetadata?['name'] ??
            'User Syncra',
      });
    }
  }

  @override
  void onClose() {
    nameC.dispose();
    emailC.dispose();
    passC.dispose();
    super.onClose();
  }
}

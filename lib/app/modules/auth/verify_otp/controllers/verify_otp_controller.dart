import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VerifyOtpController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  final otpC = TextEditingController();
  var isLoading = false.obs;

  // Variabel untuk menampung data yang dikirim dari halaman Register
  late String email;
  late String name;
  late String userId;

  @override
  void onInit() {
    super.onInit();
    // Tangkap data dari halaman sebelumnya
    final args = Get.arguments as Map<String, dynamic>;
    email = args['email'];
    name = args['name'];
    userId = args['id'];
  }

  Future<void> verifyOTP() async {
    final otpCode = otpC.text.trim();

    if (otpCode.length != 8) {
      // Sesuaikan dengan 8 digit yang kamu pakai
      Get.snackbar(
        "Tidak Valid",
        "Kode OTP tidak sesuai.",
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return;
    }

    try {
      isLoading.value = true;

      // 1. Verifikasi OTP ke Supabase
      final AuthResponse response = await _supabase.auth.verifyOTP(
        type: OtpType.signup,
        token: otpCode,
        email: email,
      );

      if (response.session != null) {
        // 2. Jika sukses, simpan data profilnya ke tabel profiles
        await _supabase.from('profiles').insert({
          'id': userId,
          'full_name': name,
          'email': email,
          'package_tier': 'Free',
        });

        // 3. KELUARKAN SESI OTOMATIS (Sign Out)
        // Agar pengguna benar-benar berstatus "belum login" saat dilempar ke halaman Login
        await _supabase.auth.signOut();

        Get.snackbar(
          "Verifikasi Sukses!",
          "Akun Anda telah aktif. Silakan masuk menggunakan email dan password Anda.",
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          snackPosition:
              SnackPosition.TOP, // Muncul di atas agar lebih terlihat
          duration: const Duration(seconds: 4),
        );

        // 4. ARAHKAN KE HALAMAN LOGIN
        Get.offAllNamed('/login');
      }
    } on AuthException catch (e) {
      Get.snackbar(
        "Verifikasi Gagal",
        "Kode OTP salah atau kedaluwarsa.",
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    otpC.dispose();
    super.onClose();
  }
}

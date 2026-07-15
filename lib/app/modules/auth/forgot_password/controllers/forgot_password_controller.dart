import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPasswordController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  final emailC = TextEditingController();
  final tokenC = TextEditingController();
  final newPasswordC = TextEditingController();
  final confirmNewPasswordC = TextEditingController();

  var isLoading = false.obs;
  var isCodeSent = false.obs; // Tracks if password reset email has been sent successfully

  Future<void> sendResetEmail() async {
    final email = emailC.text.trim();
    if (email.isEmpty) {
      Get.snackbar(
        "Form Kosong",
        "Email tidak boleh kosong!",
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return;
    }

    try {
      isLoading.value = true;
      await _supabase.auth.resetPasswordForEmail(email);
      isCodeSent.value = true;
      Get.snackbar(
        "Email Dikirim",
        "Tautan/Kode reset password telah dikirim ke email Anda.",
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      print("========== ERROR RESET PASSWORD EMAIL ==========");
      print(e);
      print("================================================");
      
      String errorMsg = e.toString();
      if (errorMsg.contains("rate limit")) {
        errorMsg = "Batas pengiriman email terlampaui (rate limit). Silakan coba lagi beberapa saat lagi.";
      } else if (errorMsg.contains("SMTP")) {
        errorMsg = "Gagal mengirim email karena server email (SMTP) Supabase belum dikonfigurasi di dashboard Supabase.";
      } else if (errorMsg.contains("Email not found") || errorMsg.contains("User not found")) {
        errorMsg = "Alamat email ini tidak terdaftar di sistem.";
      } else if (errorMsg.contains("Signup requires email verification")) {
        errorMsg = "Email ini belum diverifikasi. Silakan periksa kotak masuk email Anda.";
      }

      Get.snackbar(
        "Gagal Mengirim",
        errorMsg,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 6),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword() async {
    final email = emailC.text.trim();
    final token = tokenC.text.trim();
    final newPassword = newPasswordC.text.trim();
    final confirmPassword = confirmNewPasswordC.text.trim();

    if (token.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        "Form Kosong",
        "Semua kolom harus diisi!",
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return;
    }

    if (newPassword.length < 6) {
      Get.snackbar(
        "Password Terlalu Pendek",
        "Password minimal 6 karakter.",
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar(
        "Ketidakcocokan Password",
        "Konfirmasi password tidak cocok.",
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return;
    }

    try {
      isLoading.value = true;
      
      // 1. Verifikasi token/OTP recovery
      final response = await _supabase.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.recovery,
      );

      if (response.session != null) {
        // 2. Update password baru
        await _supabase.auth.updateUser(
          UserAttributes(password: newPassword),
        );

        // 3. Sign out agar pengguna kembali ke status belum masuk
        await _supabase.auth.signOut();

        Get.snackbar(
          "Reset Berhasil",
          "Password Anda berhasil diperbarui. Silakan login kembali.",
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          duration: const Duration(seconds: 4),
        );

        Get.offAllNamed('/login');
      } else {
        throw Exception("Verifikasi OTP gagal, session tidak dibuat.");
      }
    } catch (e) {
      Get.snackbar(
        "Gagal Reset Password",
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
    tokenC.dispose();
    newPasswordC.dispose();
    confirmNewPasswordC.dispose();
    super.onClose();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart' as g_auth;
import 'package:tranlator_v1/app/utils/audit_log.dart';

class LoginController extends GetxController {
  // =========================================================================
  // SOLUSI SUPER AMPUH: Shared Static Memory
  // Membuat form ketiakanmu KEBAL dari reset atau Zombie Controller GetX!
  // =========================================================================
  static final _sharedEmailC = TextEditingController();
  static final _sharedPassC = TextEditingController();

  // Getter agar LoginView kamu tetap bisa pakai 'controller.emailC' tanpa ubah kode UI
  TextEditingController get emailC => _sharedEmailC;
  TextEditingController get passC => _sharedPassC;

  final SupabaseClient _supabase = Supabase.instance.client;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // PENTING: Jangan PERNAH menaruh emailC.clear() di sini!
    print("✨ LOG: LoginController siap - Memori Form Aman!");
  }

  void goToSignUp() {
    Get.toNamed('/register');
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      const webClientId =
          '303118747448-8cn075h1q85c0p7t6nkhmu7csttbhjr0.apps.googleusercontent.com';

      final g_auth.GoogleSignIn googleSignIn = g_auth.GoogleSignIn(
        serverClientId: webClientId,
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

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
        await _checkAndCreateProfile(response.user!);

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

        _navigateBasedOnRole(userRole);
      }
    } catch (e) {
      print("Error Google Auth: $e");
      String failMsg = e.toString();
      if (failMsg.contains("sign_in_failed") ||
          failMsg.contains("12500") ||
          failMsg.contains("10")) {
        failMsg =
            "Google Sign-In gagal. Pastikan SHA-1 fingerprint aplikasi Anda telah didaftarkan di Google Cloud Console.";
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
    // Membaca langsung dari memori statis yang tidak bisa di-reset sembarangan
    final email = _sharedEmailC.text.trim();
    final password = _sharedPassC.text.trim();

    print("🟢 MENCOBA LOGIN - Email terbaca: '$email' | Pass terbaca length: ${password.length}");

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Gagal Masuk",
        "Email dan Password tidak boleh kosong!\n(Info Debug Terbaca: '$email')",
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoading.value = true;

      final AuthResponse response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final userData = await _supabase
            .from('profiles')
            .select('package_tier')
            .eq('id', response.user!.id)
            .maybeSingle();

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

        // HANYA BERSIHKAN TEKS JIKA LOGIN SUDAH BENAR-BENAR BERHASIL
        _sharedEmailC.clear();
        _sharedPassC.clear();

        _navigateBasedOnRole(userRole);
      }
    } on AuthException catch (e) {
      Get.snackbar(
        "Otentikasi Gagal",
        "Email atau password salah. Pastikan sudah terverifikasi.",
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

  void _navigateBasedOnRole(String userRole) {
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

  @override
  void onClose() {
    // Biarkan kosong tanpa dispose agar memori statis tetap aman
    super.onClose();
  }
}
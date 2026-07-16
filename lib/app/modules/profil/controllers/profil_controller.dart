import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tranlator_v1/app/utils/audit_log.dart';

class ProfilController extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;
  final Logger _logger = Logger(printer: PrettyPrinter(colors: true));

  RxBool isLoading = false.obs;
  RxBool isFaceVerified = false.obs;
  RxString currentLanguage = 'id'.obs;

  // Tambahkan 'avatar_url' ke dalam state
  final userprofil = <Map<String, dynamic>>[
    {
      'name': 'Loading...',
      'email': 'Loading...',
      'phone': '-',
      'package_tier': 'Free',
      'avatar_url': null,
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfileFromSupabase();
  }

  // ================= 1. FETCH DATA =================
  Future<void> fetchProfileFromSupabase() async {
    try {
      isLoading.value = true;
      final user = _client.auth.currentUser;
      if (user != null) {
        final response = await _client
            .from('profiles')
            .select()
            .eq('id', user.id)
            .single();

        userprofil[0] = {
          'name': response['full_name'] ?? user.email?.split('@')[0] ?? '',
          'email': response['email'] ?? user.email ?? '',
          'phone': response['phone'] ?? '-',
          'package_tier': response['package_tier'] ?? 'Free',
          'avatar_url': response['avatar_url'],
        };

        if (response['face_vector'] != null &&
            response['face_vector'].toString().isNotEmpty) {
          isFaceVerified.value = true;
        } else {
          isFaceVerified.value = false;
        }
        userprofil.refresh();
      }
    } catch (e) {
      _logger.e("Error fetch", error: e);
    } finally {
      isLoading.value = false;
    }
  }

  // ================= --- FUNGSI TOMBOL VERIFIKASI WAJAH --- =================
  void handleFaceVerification() {
  if (isFaceVerified.value) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_rounded,
                  color: Colors.green,
                  size: 40,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Face Verification",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "Wajah Anda sudah berhasil terverifikasi dan siap digunakan untuk proses Check-in Event.\n\nApakah Anda ingin melakukan scan ulang untuk memperbarui data wajah?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 28),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text("Tutup"),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00DBE7),
                        foregroundColor: Colors.black,
                        minimumSize: const Size(0, 50),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text("Scan Ulang"),
                      onPressed: () {
                        Get.back();

                        Get.toNamed(
                          '/scan-page',
                          arguments: {'from_profile': true},
                        )?.then((_) {
                          fetchProfileFromSupabase();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  } else {
    Get.toNamed(
      '/scan-page',
      arguments: {'from_profile': true},
    )?.then((_) {
      fetchProfileFromSupabase();
    });
  }
}
  // ================= 2. UPLOAD FOTO PROFIL =================
  Future<void> pickAndUploadImage() async {
    Get.back();

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (image == null) return;

    try {
      isLoading.value = true;
      Get.snackbar(
        "Loading",
        "Sedang mengunggah foto...",
        showProgressIndicator: true,
      );

      final user = _client.auth.currentUser;
      if (user == null) return;

      final file = File(image.path);
      final fileExt = image.path.split('.').last;
      final fileName =
          '${user.id}_${DateTime.now().millisecondsSinceEpoch}.$fileExt';

      // 1. Upload ke Storage Bucket 'avatars'
      await _client.storage.from('avatars').upload(fileName, file);

      // 2. Dapatkan URL Publik
      final imageUrl = _client.storage.from('avatars').getPublicUrl(fileName);

      // 3. Simpan URL ke tabel profiles
      await _client
          .from('profiles')
          .update({'avatar_url': imageUrl})
          .eq('id', user.id);

      // 4. Refresh Data UI
      await fetchProfileFromSupabase();
      Get.snackbar(
        "Berhasil",
        "Foto profil telah diperbarui!",
        backgroundColor: Colors.green.withOpacity(0.2),
      );
    } catch (e) {
      _logger.e("Error upload foto", error: e);
      Get.snackbar(
        "Error",
        "Gagal mengunggah foto. Pastikan bucket 'avatars' sudah public.",
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ================= 3. FUNGSI GANTI BAHASA (DENGAN POP-UP) =================

  // Fungsi A: Memunculkan Pop-Up Pilihan Bahasa di Bawah Layar
  void showLanguagePopup() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 12, bottom: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Wrap(
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'language'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
            // Pilihan Indonesia
            Obx(
              () => ListTile(
                leading: const Text("🇮🇩", style: TextStyle(fontSize: 24)),
                title: const Text(
                  "Indonesia",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: currentLanguage.value == 'id'
                    ? const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.blueAccent,
                      )
                    : null,
                onTap: () => changeLanguage('id', 'ID'),
              ),
            ),
            // Pilihan English
            Obx(
              () => ListTile(
                leading: const Text("🇬🇧", style: TextStyle(fontSize: 24)),
                title: const Text(
                  "English",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: currentLanguage.value == 'en'
                    ? const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.blueAccent,
                      )
                    : null,
                onTap: () => changeLanguage('en', 'US'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi B: Mengeksekusi perubahan bahasa
  void changeLanguage(String langCode, String countryCode) {
    Get.back(); // Tutup pop-up nya dulu
    Get.updateLocale(Locale(langCode, countryCode)); // Ganti bahasa sistem GetX
    currentLanguage.value = langCode; // Update variabel reaktif

    // Munculkan notifikasi sukses
    Get.snackbar(
      langCode == 'en' ? "Language Changed" : "Bahasa Diubah",
      langCode == 'en' ? "Switched to English" : "Beralih ke Bahasa Indonesia",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.1),
      colorText: Colors.blue[900],
    );
  }

  // (Fungsi updateProfileInSupabase, handleFaceVerification, ubahPassword, deleteProfile, goToLogin biarkan sama seperti kodemu sebelumnya)

  Future<void> updateProfileInSupabase(String newName, String newPhone) async {
    try {
      isLoading.value = true;
      final user = _client.auth.currentUser;
      if (user == null) return;

      await _client
          .from('profiles')
          .update({'full_name': newName, 'phone': newPhone})
          .eq('id', user.id);
      await fetchProfileFromSupabase();
      Get.snackbar(
        "Successful",
        "Profile successfully updated",
        backgroundColor: Colors.green.withOpacity(0.2),
      );
    } catch (e) {
      Get.snackbar("Error", "Gagal memperbarui data.");
    } finally {
      isLoading.value = false;
    }
  }

  void ubahProfil() {
    final nameTxtController = TextEditingController(
      text: userprofil[0]['name'],
    );
    final phoneTxtController = TextEditingController(
      text: userprofil[0]['phone'],
    );

    Get.defaultDialog(
      title: 'edit_profile'.tr,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            TextField(
              controller: nameTxtController,
              decoration: InputDecoration(labelText: 'full_name'.tr),
            ),
            TextField(
              controller: phoneTxtController,
              decoration: InputDecoration(labelText: 'phone'.tr),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
      textConfirm: 'save'.tr,
      textCancel: 'cancel'.tr,
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        updateProfileInSupabase(
          nameTxtController.text,
          phoneTxtController.text,
        );
      },
    );
  }

  void ubahfoto() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 12, bottom: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Wrap(
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Kamera (MediaPipe)'),
              onTap: () => Get.back(),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () =>
                  pickAndUploadImage(), // Panggil fungsi upload di sini
            ),
          ],
        ),
      ),
    );
  }

  void ubahPassword() {
    final passwordBaruController = TextEditingController();

    Get.defaultDialog(
      title: "Ubah Password Akun",
      buttonColor: Colors.blue[900],
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white, width: 2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextField(
              controller: passwordBaruController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Masukkan Password Baru",
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      textConfirm: "Save",
      textCancel: "Cancel",
      onConfirm: () async {
        if (passwordBaruController.text.trim().length < 6) {
          Get.snackbar("Gagal", "Password minimal harus 6 karakter!");
          return;
        }

        Get.back();
        try {
          _logger.i(
            "💡 [INFO]: Mengirim request update password ke Supabase Auth...",
          );
          // Mengubah password akun yang sedang login di sistem auth Supabase secara aman (terenkripsi)
          await _client.auth.updateUser(
            UserAttributes(password: passwordBaruController.text.trim()),
          );

          _logger.i(
            "✅ [SUCCESS]: Password akun berhasil diperbarui di cloud database auth.users.",
          );
          Get.snackbar("Berhasil", "Password berhasil diubah di server.");
        } catch (e) {
          _logger.e(
            "🚨 [ERROR]: Handshake pembaruan password ditolak server",
            error: e,
          );
        }
      },
    );
  }

  void handleSignOutMobile() async {
    try {
      // 🔴 TANAM LOG DI SINI (Sebelum signOut dieksekusi!)
      await AuditLog.record(
        'USER_LOGOUT',
        'Pengguna keluar dari sesi aplikasi.',
      );

      await _client.auth.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      // ...
    }
  }

  void deleteProfile() {
    Get.defaultDialog(
      title: "Konfirmasi",
      middleText: "Yakin ingin keluar?",
      textConfirm: "Ya",
      textCancel: "Tidak",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () => handleSignOutMobile(),
    );
  }
}

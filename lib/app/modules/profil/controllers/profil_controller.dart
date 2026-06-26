import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';

class ProfilController extends GetxController {
  // Inisialisasi Supabase Client & Logger Sistem
  final SupabaseClient _client = Supabase.instance.client;
  final Logger _logger = Logger(printer: PrettyPrinter(colors: true));

  // Variabel Reactive untuk State Loading & Data User Realtime
  var isLoading = false.obs;
  
  // State manajemen profil pengguna (Mengubah tipe data dynamic agar bisa nampung null)
  final userprofil = <Map<String, dynamic>>[
    {
      'name': 'Loading...',
      'email': 'Loading...',
      'phone': '-',
      'package_tier': 'Free'
    }
  ].obs;

  // --- TAMBAHAN BARU: State Verifikasi Wajah ---
  var isFaceVerified = false.obs;

  // Data transkrip seminar (Dibuat reactive)
  final transkrip = [
    {
      'title': 'AI Ethics & The Future of Work: A Global Perspective',
      'author': 'Dr. Rhiki',
      'Date': 'Oct 19 2025',
      'Time': '14.00 - 16.00'
    },
    {
      'title': 'Machine Learning Implementation in Healthcare',
      'author': 'Prof. Alan',
      'Date': 'Oct 01 2025',
      'Time': '11.00 - 13.00'
    },
    {
      'title': 'Building Accessible User Interfaces in 2026',
      'author': 'Sarah Jane',
      'Date': 'Oct 06 2025',
      'Time': '14.00 - 16.00'
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfileFromSupabase(); // Otomatis ambil data dari server pas halaman dibuka
  }

  // ================= 1. READ: AMBIL DATA DARI SUPABASE (SINKRON WEB) =================
  Future<void> fetchProfileFromSupabase() async {
    try {
      isLoading.value = true;
      _logger.i("💡 [INFO]: Memulai request sinkronisasi token JWT ke database profiles...");

      final user = _client.auth.currentUser;
      if (user != null) {
        // Melakukan fetch data real dari tabel public.profiles lewat SSL/TLS Gateway
        // --- TAMBAHAN BARU: Memanggil juga face_vector ---
        final response = await _client
            .from('profiles')
            .select() // Mengambil semua kolom termasuk face_vector
            .eq('id', user.id)
            .single();

        // Timpa nilai reactive dengan data server terbaru
        userprofil[0] = {
          'name': response['full_name'] ?? user.email?.split('@')[0] ?? '',
          'email': response['email'] ?? user.email ?? '',
          'phone': response['phone'] ?? '-',
          'package_tier': response['package_tier'] ?? 'Free',
        };

        // --- TAMBAHAN BARU: Cek apakah user sudah punya face_vector ---
        if (response['face_vector'] != null && response['face_vector'].toString().isNotEmpty) {
          isFaceVerified.value = true;
          _logger.i("✅ [INFO]: Wajah user sudah terverifikasi.");
        } else {
          isFaceVerified.value = false;
        }

        _logger.i("✅ [SUCCESS]: Profil ${userprofil[0]['name']} sinkron! Paket Aktif: [${userprofil[0]['package_tier']}]");
      }
    } catch (e) {
      _logger.e("🚨 [ERROR]: Autentikasi RLS gagal atau sesi JWT kedaluwarsa!", error: e);
    } finally {
      isLoading.value = false;
    }
  }

  // ================= --- TAMBAHAN BARU: FUNGSI TOMBOL VERIFIKASI WAJAH --- =================
 // ================= --- FUNGSI TOMBOL VERIFIKASI WAJAH --- =================
  void handleFaceVerification() {
    if (isFaceVerified.value) {
      // Jika sudah diverifikasi, munculkan pop-up opsi
      Get.defaultDialog(
        title: "Sudah Terverifikasi",
        middleText: "Wajah Anda sudah terdaftar di sistem dan siap digunakan untuk Check-in Event.\n\nApakah Anda ingin memperbarui (scan ulang) data wajah Anda?",
        titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
        buttonColor: const Color(0xFF00dbe7),
        textConfirm: "Scan Ulang",
        confirmTextColor: Colors.black,
        textCancel: "Tutup",
        onConfirm: () {
          Get.back(); // Tutup dialog dulu
          // Arahkan ke kamera, dan saat KEMBALI dari kamera, jalankan fetchProfile()
          Get.toNamed('/scan-page', arguments: {'from_profile': true})?.then((_) {
            fetchProfileFromSupabase(); // REFRESH DATA!
          });
        },
      );
    } else {
      // Jika belum verifikasi, langsung lempar ke halaman Face Scanner
      // .then() memastikan saat user klik "Lanjutkan" di halaman scan dan kembali ke profil,
      // profil akan otomatis me-refresh database untuk ngecek vektor barunya.
      Get.toNamed('/scan-page', arguments: {'from_profile': true})?.then((_) {
        fetchProfileFromSupabase(); // REFRESH DATA!
      });
    }
  }
  // ================= 2. UPDATE: SIMPAN DATA PROFIL KE SERVER =================
  Future<void> updateProfileInSupabase(String newName, String newPhone) async {
    try {
      isLoading.value = true;
      final user = _client.auth.currentUser;
      
      if (user == null) return;

      _logger.i("💡 [INFO]: Mengirim instruksi HTTP PATCH untuk memperbarui profile user id: ${user.id}");

      // Update data di tabel database Supabase
      await _client.from('profiles').update({
        'full_name': newName,
        'phone': newPhone,
      }).eq('id', user.id);

      _logger.w("⚠️ [WARN]: Data profil berhasil diubah di server database.");

      // Segarkan state lokal aplikasi
      await fetchProfileFromSupabase();

      Get.snackbar(
        "Successful",
        "Profile successfully updated in database",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.2),
        colorText: Colors.white,
      );
    } catch (e) {
      _logger.e("🚨 [ERROR]: Gagal memperbarui tabel profiles via API Gateway", error: e);
      Get.snackbar("Error", "Gagal memperbarui data ke server.");
    } finally {
      isLoading.value = false;
    }
  }

  // ================= 3. DELETE: KELUAR / REVOKE SESI JWT =================
  Future<void> handleSignOutMobile() async {
    try {
      _logger.w("⚠️ [WARN]: Memulai proses penghancuran token sesi JWT (Sign Out)...");
      
      // Hapus token sesi di cloud server Supabase
      await _client.auth.signOut();
      
      _logger.i("✅ [SUCCESS]: Sesi dihancurkan, mengembalikan hak akses ke mode Anonymous.");
      
      Get.snackbar(
        "Berhasil",
        "Anda berhasil keluar dari sistem",
        snackPosition: SnackPosition.BOTTOM,
      );

      Future.delayed(const Duration(milliseconds: 800), () {
        goToLogin();
      });
    } catch (e) {
      _logger.e("🚨 [ERROR]: Gagal mematikan sesi auth token", error: e);
    }
  }

  // ================= MODAL INTERFACE CUSTOMISASI =================
  void ubahProfil() {
    // Buat controller teks temporer agar data input tidak langsung merusak state sebelum di-save
    final nameTxtController = TextEditingController(text: userprofil[0]['name']);
    final phoneTxtController = TextEditingController(text: userprofil[0]['phone']);

    Get.defaultDialog(
      title: "Personal Information",
      buttonColor: Colors.blue[900],
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white, width: 2)
        ), 
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextField(
              controller: nameTxtController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: phoneTxtController,
              decoration: const InputDecoration(labelText: "Phone"),
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
      textConfirm: "Save",
      textCancel: "Cancel",
      onConfirm: () {
        Get.back(); // Tutup dialog modal
        // Jalankan fungsi pengiriman data ke server Supabase
        updateProfileInSupabase(nameTxtController.text, phoneTxtController.text);
      },
    );
  }

  void deleteProfile() {
    Get.defaultDialog(
      title: "Konfirmasi",
      middleText: "Yakin ingin keluar dan menghapus token sesi masuk Anda?",
      textConfirm: "Ya, Keluar",
      textCancel: "Tidak",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back(); 
        handleSignOutMobile(); // Eksekusi fungsi logout aman Supabase
      },
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
          border: Border.all(color: Colors.white, width: 2)
        ), 
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextField(
              controller: passwordBaruController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Masukkan Password Baru"),
            ),
            const SizedBox(height: 20)
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
          _logger.i("💡 [INFO]: Mengirim request update password ke Supabase Auth...");
          // Mengubah password akun yang sedang login di sistem auth Supabase secara aman (terenkripsi)
          await _client.auth.updateUser(UserAttributes(password: passwordBaruController.text.trim()));
          
          _logger.i("✅ [SUCCESS]: Password akun berhasil diperbarui di cloud database auth.users.");
          Get.snackbar("Berhasil", "Password berhasil diubah di server.");
        } catch (e) {
          _logger.e("🚨 [ERROR]: Handshake pembaruan password ditolak server", error: e);
        }
      },
    );
  }

  void ubahfoto() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 12, bottom: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
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
              title: const Text('Ambil Foto'),
              onTap: () {
                Get.back();
                Get.snackbar("Pemberitahuan", "Fitur kamera akan diintegrasikan dengan MediaPipe Core.", snackPosition: SnackPosition.BOTTOM);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () {
                Get.back();
                Get.snackbar("Pemberitahuan", "Akses penyimpanan lokal galeri belum dikonfigurasi.", snackPosition: SnackPosition.BOTTOM);
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // Navigasi Router Bawaan GetX
  void goToLogin() => Get.toNamed('/login');
  void goToDashboard() => Get.toNamed('/dashboard');
  void goToTicket() => Get.toNamed('/ticket');
}
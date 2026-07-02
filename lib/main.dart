import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tranlator_v1/app/utils/app_translations.dart';
// 🚨 PENTING: Pastikan jalur import di bawah ini sesuai dengan letak file app_pages.dart kamu!
import 'app/routes/app_pages.dart';

void main() async {
  // 1. Perbaikan Typo: Memastikan engine Flutter siap
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inisialisasi Supabase Cloud
  await Supabase.initialize(
    url:
        'https://zzcevejojtsnsdrmxnik.supabase.co', // Ganti dengan URL Supabase kamu
    anonKey:
        'sb_publishable_kO7F3kKLAELpuB-jBkBciQ_JSgrbLmk', // Ganti dengan Anon Key kamu
  );

  

  // 3. Jalankan aplikasi
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Syncro AI Mobile",
      debugShowCheckedModeBanner: false,

      // 🚨 KUNCI UTAMA GETX CLI: Menggunakan routing otomatis bawaan project kamu
      initialRoute: AppPages
          .INITIAL, // Ini otomatis mengarah ke rute awal (biasanya /login atau /welcome)
      getPages: AppPages
          .routes, // Ini mendaftarkan seluruh rute halaman di project kamu
      // ==========================================
      // TAMBAHKAN 3 BARIS INI UNTUK MULTI-BAHASA
      // ==========================================
      translations: AppTranslations(), // Memanggil file kamus
      locale: const Locale('id', 'ID'), // Bahasa default (Indonesia)
      fallbackLocale: const Locale('en', 'US'), // Bahasa cadangan kalau error
    );
  }
}

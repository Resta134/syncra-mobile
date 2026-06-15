import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/faceregistration_controller.dart';

class FaceregistrationView extends GetView<FaceregistrationController> {
  const FaceregistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Background terang Neumorphism
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        title: const Text(
          'Daftar Wajah',
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false, // Hilangkan tombol back (karena dari sukses payment)
      ),
      
      // =================================================================
      // BAGIAN BODY (Konten Utama)
      // =================================================================
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. AREA BULATAN SCAN MUKA
              Container(
                height: 220,
                width: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.shade50,
                  border: Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 2),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/FACE.png'), 
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.15),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 2. TEKS JUDUL & DESKRIPSI
              const Text(
                'Daftarkan Wajah Anda',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 10),
              Text(
                'Pindai wajah Anda untuk akses masuk event\nyang lebih cepat tanpa antre.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
              ),
              const SizedBox(height: 40),

              // 3. CONTAINER PAPAN 1 (Lebih Cepat)
              _buildFeatureCard(
                icon: Icons.bolt_rounded,
                title: 'Lebih Cepat, Tanpa Antre',
                desc: 'Masuk ke area event hanya dengan memindai wajah Anda dalam hitungan detik.',
              ),
              const SizedBox(height: 16),

              // 4. CONTAINER PAPAN 2 (Aman)
              _buildFeatureCard(
                icon: Icons.shield_rounded,
                title: 'Aman & Terenkripsi',
                desc: 'Data biometrik Anda dilindungi menggunakan standar enkripsi tingkat tinggi.',
              ),
            ],
          ),
        ),
      ),

      // =================================================================
      // BAGIAN BAWAH (Tombol Aksi Kiri Kanan)
      // =================================================================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 15, bottom: 35),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.blueGrey.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, -5)),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Tombol Skip (Pakai Expanded agar membagi rata sisa layar)
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () => controller.goToTicket(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blueAccent, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text(
                      'Lewati', 
                      style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              // Tombol Lanjut Registrasi
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => controller.goToRegrestration(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Daftar Sekarang', 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi helper agar kode desain Card tidak berulang-ulang
  Widget _buildFeatureCard({required IconData icon, required String title, required String desc}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade100, width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.blueGrey.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1), 
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: Colors.blueAccent, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                const SizedBox(height: 4),
                Text(desc, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/faceregistration_controller.dart';

class FaceregistrationView extends GetView<FaceregistrationController> {
const FaceregistrationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FaceregistrationView'),
        centerTitle: true,
      ),
      // =================================================================
      // BAGIAN BODY (Konten Utama)
      // =================================================================
      body: SafeArea(
        // Bungkus SafeArea biar aman dari notch HP
        child: SingleChildScrollView(
          // Biar aman kalau layar HP user kecil
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. AREA BULATAN SCAN MUKA (GAMBAR DALAM LINGKARAN + LASER)
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    clipBehavior:
                        Clip.hardEdge, // <-- TAMBAHIN BARIS INI KUNCINYA
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.asset(
                      'images/FACE.png',
                      fit: BoxFit
                          .cover, // Opsional: Biar gambarnya ngisi penuh area
                    ),
                  ),
                  Container(
                    // width: 280, // Sedikit disesuaikan biar proporsional di layar
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue.shade700,
                        width: 2.0, // Ketebalan border biru luar
                      ),
                    ),
                  ),
                  // Garis laser scan biru di tengah
                ],
              ),

              SizedBox(height: 24),

              // 2. TEKS JUDUL & DESKRIPSI
              Column(
                children: [
                  Text(
                    'Face Recognition Registration', // Typo dibenerin dikit
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Register your face for a smoother\nevent access experience.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32),

              // 3. CONTAINER PAPAN 1 (Faster, no queuing)
              Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(
                    0.1,
                  ), // Opacity diturunin dikit biar teks terbaca jelas
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.blue.shade200,
                    width: 1.5,
                  ), // Border disoftkan
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.bolt,
                        color: Colors.white,
                        size: 28,
                      ), // Icons.petir diganti Icons.bolt
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Faster, no queuing',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Enter the event area simply by scanning your face in a matter of seconds.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 4. CONTAINER PAPAN 2 (Secure & encrypted)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue.shade200, width: 1.5),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.shield,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Secure & encrypted',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Your biometric data is secured using high-level encryption standards.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // =================================================================
      // BAGIAN BAWAH (Tombol Aksi)
      // =================================================================
      // Menggunakan bottomNavigationBar agar posisinya paten di bawah
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
         
          
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    controller.goToTicket();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ), // Bikin oval/kapsul
                  ),
                  child: Text(
                    'Skip for Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
          
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    controller.goToRegrestration();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ), // Bikin oval/kapsul
                  ),
                  child: Text(
                    'Registration Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
              // Tombol Lewati (Sekunder)
               ],
          ),
        ),
      ),
    );
  }
}

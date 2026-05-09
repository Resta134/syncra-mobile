import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/dashboard_speak_controller.dart';

class DashboardSpeakView extends GetView<DashboardSpeakController> {
  const DashboardSpeakView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Column(
          children: [
            Text(
              'Dashboard Speaker',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              'Dr. Cahaya',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: InkWell(
                  onTap: () {
                    controller.goToProfil();
                  },
                  child: CircleAvatar(
                    backgroundImage: AssetImage("images/profil.png"),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
     
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'JADWAL ANDA HARI INI',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Pill Indikator Waktu
                  const SizedBox(width: 8),

                  // terbuka
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue[900]!,
                          blurRadius: 2,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Seminar: Global\nPerspective',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Main Stage',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        const SizedBox(height: 12),

                        // Badge Status " Datang"
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '30m Ago',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.circle, size: 10, color: Colors.grey),
                            SizedBox(width: 8),
                            Text(
                              'Time: 10:00 AM',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Tombol Masuk Ruang Live (Terkunci)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              controller.goToPresent();
                            },
                            icon: Icon(
                              Icons.play_circle_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                            label: const Text(
                              'Join Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFDCAE53),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  //
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue[900]!,
                          blurRadius: 2,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'AI Seminar: Global\nPerspective',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Main Stage',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        const SizedBox(height: 12),

                        // Badge Status "Akan Datang"
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Akan Datang',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.circle, size: 10, color: Colors.grey),
                            SizedBox(width: 8),
                            Text(
                              'Time: 20:00 AM',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Tombol Masuk Ruang Live (Terkunci)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            // TODO: Ganti 'null' menjadi fungsi Get.toNamed('/presentation') jika waktu sudah masuk
                            onPressed: null,
                            icon: const Icon(
                              Icons.lock,
                              color: Colors.white,
                              size: 20,
                            ),
                            label: const Text(
                              'Akan Datang / Terkunci',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              disabledBackgroundColor: Colors.grey,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Catatan: Bagian Avatar Profil sengaja dihilangkan di sini.
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

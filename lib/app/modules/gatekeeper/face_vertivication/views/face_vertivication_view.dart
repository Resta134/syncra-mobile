import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/face_vertivication_controller.dart';

class FaceVertivicationView extends GetView<FaceVertivicationController> {
 const FaceVertivicationView({super.key});
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      // Background disamakan dengan warna gelap pada mockup aslinya
      backgroundColor: Color(0xFF383B46),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Identity Verification',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline_rounded, color: Colors.blue),
            onPressed: () {
              Get.snackbar('Bantuan', 'Posisikan wajah tepat di dalam lingkaran.');
            },
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: 
          Column(
            children: [
              SizedBox(height: 10),
              // TEKS INSTRUKSI ATAS
              Text(
                'Please position your face clearly within\nthe frame below to complete\nverification.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),
              
              Spacer(),

              // AREA BULATAN SCAN MUKA (POLOS + GARIS SCAN)
              Stack(
                alignment: Alignment.center,
                children: [
                  // Aksen siku-siku frame (Opsional, dibikin simpel dengan container bulat)
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade600, // Warna bg muka polos sementara
                      border: Border.all(
                        color: Colors.blue.shade700, 
                        width: 4.0, // Ketebalan border biru luar
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '[ Camera Feed ]',
                        style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  // Garis laser scan biru di tengah
                  Container(
                    width: 280,
                    height: 3,
                    color: Colors.blue.shade400,
                  ),
                ],
              ),

              Spacer(),

              // AREA TOMBOL BAWAH
              // 1. Tombol Align Face (Biru)
              SizedBox(
                width: double.infinity, // Ambil lebar penuh
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Panggil fungsi scan wajah di controller
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.face_retouching_natural, color: Colors.white, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Align face within the circle',
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 16),

              // 2. Tombol Manual QR Scan (Putih)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                   controller.qr();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code_scanner_rounded, color: Colors.blue.shade700, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Manual QR Scan',
                        style: TextStyle(color: Colors.blue.shade700, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),

              // TEKS LAPORAN ISSUE BAWAH
              InkWell(
                onTap: () {
                  controller.report();
                },
                child: Text(
                  'Report Verification Issue',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
}}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranlator_v1/app/modules/user/event_detail/controllers/event_detail_controller.dart';

class TicketController extends GetxController {
  //TODO: Implement TicketController

  
  void goToLive(){
    Get.toNamed('/live');
  }
  final user = [
    {
      'name': 'Rhiki Sulistiyo',
      'avatar': 'images/profil.png',
      'ticket1': 'TICKET CONFIRMATION',
      'ticket2': 'TICKET REQUIRED',
      'ticket_id': 'SYNCRA-102062023',
    },
  ].obs;
  
  String get userName => user[0]['name'] ?? 'User';
  String get ticketID => user[0]['ticket_id'] ?? '-';

void popUp() {
    Get.dialog(
      // Gunakan widget Dialog agar otomatis terpusat di tengah dengan rapi
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        // Pembungkus scroll jika layar HP terlalu kecil
        child: SingleChildScrollView( 
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20), // Semua sudut melengkung karena di tengah
            ),
            padding: EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Kunci agar tinggi dialog pas dengan isi konten
              children: [
                
                // --- CONTAINER TIKET ATAS ---
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[400]!, width: 1),
                  ),
                  child: Column(
                    children: [
                      // Header Hijau
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_box_outlined, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              user[0]['ticket1']!,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Isi Detail Tiket & QR Code
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    user[0]['avatar']!,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  user[0]['name']!,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Ticket ID", style: TextStyle(fontSize: 14)),
                                Text(
                                  user[0]['ticket_id']!,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Face Verification", style: TextStyle(fontSize: 14)),
                                Row(
                                  children: [
                                    Icon(Icons.check_circle, color: Color(0xFF34A853), size: 18),
                                    SizedBox(width: 4),
                                    Text(
                                      "COMPLETE",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF34A853),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Divider(height: 20),
                            SizedBox(height: 10),
                            
                            // Bagian QR Code Besar
                            Center(
                              child: Column(
                                children: [
                                  Icon(Icons.qr_code_2, size: 250, color: Colors.black87),
                                  SizedBox(height: 8),
                                  Text(
                                    "Scan this QR code at the event entrance",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12, height: 1.4),
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
              ],
            ),
          ),
        ),
      ),
      
      // --- PENGATURAN BACKGROUND & PERILAKU DIALOG ---
      barrierDismissible: true, // TRUE = Klik sembarang area di luar pop-up akan menutupnya
      barrierColor: Colors.black.withOpacity(0.9), // Background belakang warna putih transparan (opacity 0.5)
    );
  }
  void goToDashboard(){
    Get.toNamed('/dashboard');
  }
  void goToProfil(){
    Get.toNamed('/profil');
  }
  void goToTicket(){
    Get.toNamed('/ticket');
  }
}


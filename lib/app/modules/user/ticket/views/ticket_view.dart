import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tranlator_v1/app/components/custom_bottom_nav.dart';

import '../controllers/ticket_controller.dart';

class TicketView extends GetView<TicketController> {
  const TicketView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('MyTicket', style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),),
        backgroundColor:  Colors.blue[900],
        centerTitle: true
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 400,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white, width: 5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue,
                            blurRadius: 1,
                            offset: Offset(0, 7),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'images/background-card.jpg',
                              //  fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Title trtyuioiuyt',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.blue[900],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  controller.popUp();
                                },
                                child: Icon(
                                  Icons.qr_code_2,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.person),
                              SizedBox(width: 5),
                              Text('Dr. Rhiki', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 20,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 5),
                              Text('Today, Oct 2026'),
                              SizedBox(width: 5),
                              Text('|', style: TextStyle(fontSize: 20)),
                              SizedBox(width: 5),
                              Text('00.00 AM - 02.00 PM'),
                            ],
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              controller.goToLive();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 40,
                              ),
                              elevation: 5,
                              backgroundColor: Colors.blue[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.live_tv,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Join Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Gambar & Badge
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 400,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white, width: 5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue,
                            blurRadius: 1,
                            offset: Offset(0, 7),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'images/background-card.jpg',
                              //  fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Title trtyuioiuyt',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.blue[900],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  controller.popUp();
                                },
                                child: Icon(
                                  Icons.qr_code_2,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.person),
                              SizedBox(width: 5),
                              Text('Dr. Resta', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 20,
                                color: Colors.grey[40],
                              ),
                              SizedBox(width: 5),
                              Text('Today, Oct 2026'),
                              SizedBox(width: 5),
                              Text('|', style: TextStyle(fontSize: 20)),
                              SizedBox(width: 5),
                              Text('90.00 AM - 02.00 PM'),
                            ],
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: null,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 40,
                              ),
                              elevation: 5,
                              backgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.live_tv,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Join Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Gambar & Badge
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 400,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white, width: 5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue,
                            blurRadius: 1,
                            offset: Offset(0, 7),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'images/background-card.jpg',
                              //  fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Title trtyuioiuyt',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.blue[900],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  controller.popUp();
                                },
                                child: Icon(
                                  Icons.qr_code_2,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.person),
                              SizedBox(width: 5),
                              Text('Dr. Resta', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 20,
                                color: Colors.grey[40],
                              ),
                              SizedBox(width: 5),
                              Text('Today, Oct 2026'),
                              SizedBox(width: 5),
                              Text('|', style: TextStyle(fontSize: 20)),
                              SizedBox(width: 5),
                              Text('90.00 AM - 02.00 PM'),
                            ],
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: null,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 40,
                              ),
                              elevation: 5,
                              backgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.live_tv,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'End Live',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          // Letakkan kode ini di bawah area yang kamu inginkan
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 10.0,
                            ),
                            child: Row(
                              children: [
                                // --- BUTTON 1: MATERIALS ---
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // Aksi buka materi
                                      print("Open Materials");
                                    },
                                    icon: Icon(
                                      Icons.menu_book,
                                      size: 18,
                                    ), // Icon buku
                                    label: Text(
                                      "Materials",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue[700],
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),

                                // Memberi jarak horizontal antar tombol
                                SizedBox(width: 12),

                                // --- BUTTON 2: SUMMARY ---
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // Aksi unduh/buka rangkuman
                                      print("Download Summary");
                                    },
                                    icon: Icon(
                                      Icons.picture_as_pdf,
                                      size: 18,
                                    ), // Icon file/PDF
                                    label: Text(
                                      "Summary",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors
                                          .orange[700], // Dibedakan warna agar kontras
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Gambar & Badge
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1,
        role: 'user', // <-- Otomatis nampilin menu Q&A menyala
      ),
    );
  }

  // Helper untuk membuat struktur tombol Bottom Navigation yang konsisten
 }

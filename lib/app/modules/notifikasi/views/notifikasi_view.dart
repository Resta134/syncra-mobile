import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/notifikasi_controller.dart';

class NotifikasiView extends GetView<NotifikasiController> {
  const NotifikasiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.blue.withOpacity(0.3),
                      ),
                      child: Icon(
                        Icons.calendar_month_outlined,
                        size: 20,
                        color: Colors.blue[900],
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      // <--- 1. Bungkus Column pakai Expanded
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment .center, // <--- 2. Biar rata kiri semua
                        children: [
                          Text(
                            'The Future of Neural Translation starts in 15 minutes.',
                            softWrap:
                                true, // <--- 3. Memastikan teks membungkus ke bawah
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ), // Tambahan jarak biar nggak terlalu nempel
                          Row(
                            children: [
                              Text('Seminar Alert'),
                              SizedBox(width: 5),
                              Icon(Icons.circle, size: 8, color: Colors.blue),
                              SizedBox(width: 5),
                              Text(
                                'Just Now',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          // button
                          InkWell(
                            onTap: () {},
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(top: 15),
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[800],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Align(
                                alignment: AlignmentGeometry.center,
                                child: Text(
                                  'Join Now',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
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
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.blue.withOpacity(0.3),
                      ),
                      child: Icon(
                        Icons.file_copy_rounded,
                        size: 20,
                        color: Colors.blue[900],
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .center, // <--- 2. Biar rata kiri semua
                        children: [
                          Text(
                            'Transcript fr "Clud Computing 2023" is now available',
                            softWrap:
                                true, // <--- 3. Memastikan teks membungkus ke bawah
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text('Transcript Ready'),
                              SizedBox(width: 5),
                              Icon(Icons.circle, size: 8, color: Colors.blue),
                              SizedBox(width: 5),
                              Text(
                                '2h ago',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),

                          // button
                          InkWell(
                            onTap: () {},
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(top: 15),
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[800],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Align(
                                alignment: AlignmentGeometry.center,
                                child: Text(
                                  'Download',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
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
            ),
          ],
        ),
      ),
    );
  }
}

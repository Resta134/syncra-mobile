import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HistoryView'),
        // centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 8.0,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search for history",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                    suffixIcon: Icon(Icons.translate),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    physics:
                        NeverScrollableScrollPhysics(), // Biar ga bentrok sama scroll utama
                    itemCount: controller.transcriptList.length,
                    itemBuilder: (context, index) {
                      final data = controller.transcriptList[index];
                      // Panggil widget card-nya dan lempar data beserta controller
                      return _buildTranscriptCard(data, controller);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTranscriptCard(
    Map<String, String> data,
    HistoryController controller,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  data['title']!,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50, // Latar ungu sangat muda
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  data['tag']!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple.shade300, // Teks ungu
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: Colors.blueGrey,
              ),
              SizedBox(width: 6),
              Text(
                data['date']!,
                style: TextStyle(fontSize: 13, color: Colors.blueGrey),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Sisi Kiri: Avatar & Nama Author
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.deepPurple.shade100,
                    child: Text(
                      data['authorInitials'] ?? '',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade700,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    data['author']!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              // Sisi Kanan: Tombol Download Transcript
              InkWell(
                onTap: () {
                  controller.downloadTranscript(data['title'] ?? 'Unknown');
                },
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.file_download_outlined,
                        size: 18,
                        color: Colors.blueAccent,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "Transcript",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

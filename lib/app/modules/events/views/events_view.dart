import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/events_controller.dart';

class EventsView extends GetView<EventsController> {
  const EventsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // background color
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: Text("Event All"), backgroundColor: Colors.white,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 8.0,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search for events",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      suffixIcon: Icon(Icons.translate),
                    ),
                  ),
                ),
                Container(
                  child: Obx(
                    () => ListView.builder(
                      shrinkWrap:
                          true, // Biar ListView mengikuti panjang isinya
                      physics:
                          NeverScrollableScrollPhysics(), // Biar ga konflik sama scroll body utama
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 10,
                      ),
                      // tampilkan itemcount semua data
                      itemCount: controller.upcomingEventsData.length,
                      itemBuilder: (context, index) {
                        // Ambil data berdasarkan urutan (index)
                        final data = controller.upcomingEventsData[index];
                        return _buildUpcomingCard(data);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingCard(Map<String, String> data) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              data['thumbnail'] ?? 'images/profil.png', // Ambil key 'thumbnail'
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data['time'] ?? 'No Time', // Ambil key 'time'
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        data['tag'] ?? '',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  data['titleupcoming'] ??
                      'No Title', // HARUS SAMA dengan key di Controller
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 2,
                ),
                SizedBox(height: 5),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data['language'] ?? 'No Language',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      SizedBox(width: 20),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.notifications_none, size: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

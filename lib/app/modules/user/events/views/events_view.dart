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
      appBar: AppBar(
        title: Text(
          "Event All",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 8.0,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search for events",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.translate),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),

          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.upcomingEventsData.length,
                itemBuilder: (context, index) {
                  final data = controller.upcomingEventsData[index];

                  return _buildUpcomingCard(data);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingCard(Map<String, String> data) {
    return InkWell(
      onTap: () {
        controller.goToEventDetail();
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                data['thumbnail'] ?? 'images/profil.png',
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 14),

            // CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TIME + TAG
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          data['time'] ?? 'No Time',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(width: 8),

                    ],
                  ),

                  const SizedBox(height: 8),

                  // TITLE
                  Text(
                    data['titleupcoming'] ?? 'No Title',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      // Avatar Author Pertama
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.blue[100],
                        child: const Icon(
                          Icons.person,
                          size: 15,
                          color: Colors.blue,
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Nama Author (Diganti pakai ?? biar ga crash)
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              data['authorUp']!,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(width: 10),
                            Text(
                              '|',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.blue[100],
                                  child: const Icon(
                                    Icons.location_on_outlined,
                                    size: 15,
                                    color: Colors.blue,
                                  ),
                                ),
                                SizedBox(width: 5),

                                Text(
                                  data['location']!,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

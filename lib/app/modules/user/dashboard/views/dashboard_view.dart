import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranlator_v1/app/components/custom_bottom_nav.dart';
import 'package:tranlator_v1/app/modules/user/dashboard/controllers/dashboard_controller.dart';
// import 'dashboard_controller.dart'; // Sesuaikan import-nya

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // === APPBAR SESUAI KODE LU ===
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white.withOpacity(0.9),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage("images/image.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text("AsynCra App"),
          ],
        ),
        elevation: 2, // Biar ada bayangan tipis
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: IconButton(
              onPressed: () => controller.goToNotifikasi(),
              icon: Icon(
                Icons.notifications_active,
                color: Colors.blue[700],
                size: 25,
              ),
            ),
          ),
        ],
      ),

      // === BODY DENGAN SCROLL ===
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            // Header: Live Now
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Color(0xFFC5221F),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Live Now',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // HORIZONTAL SCROLL CARD DENGAN GETX
            SizedBox(
              height: 340,
              // Kita bungkus Obx karena mau baca data reaktif dari Controller
              child: Obx(
                () => ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  scrollDirection: Axis.horizontal,
                  // Jumlah card menyesuaikan jumlah data di Controller
                  itemCount: controller.liveStreamData.length,
                  separatorBuilder: (context, index) => SizedBox(width: 18),
                  itemBuilder: (context, index) {
                    // MENGAMBIL DATA DARI CONTROLLER SESUAI INDEX/URUTAN
                    final data = controller.liveStreamData[index];
                    // Melempar data ke widget Card
                    return _buildLiveCard(data);
                  },
                ),
              ),
            ),
            SizedBox(height: 10),

            // Main: Upcoming Events
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upcoming Events',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // Vertikal scroll card upcoming event (bisa pakai ListView.builder biasa karena vertikal)
            Container(
              child: Column(
                children: [
                  Obx(
                    () => ListView.builder(
                      shrinkWrap:
                          true, // Biar ListView mengikuti panjang isinya
                      physics:
                          NeverScrollableScrollPhysics(), // Biar ga konflik sama scroll body utama
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 10,
                      ),
                      itemCount: controller.upcomingEventsData.length > 3
                          ? 3
                          : controller.upcomingEventsData.length,
                      itemBuilder: (context, index) {
                        final data = controller.upcomingEventsData[index];
                        return _buildUpcomingCard(data);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            controller.goToEvents();
                          },
                          child: Text(
                            'View All Now >',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            // ---- History Section ----
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 0,
        role: 'user', // <-- Kasih tahu ini punya moderator
      ),
    );
  }

  // === DESAIN CARD  ==============
  Widget _buildLiveCard(Map<String, String> data) {
    return InkWell(
      onTap: () {
        controller.goToTicket();
      },
      child: Container(
        width: 280,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade200, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar & Badge
            Stack(
              children: [
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFFC5221F),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.translate, size: 15, color: Colors.white),
                        SizedBox(width: 5),
                        Text(
                          data['lang']!,
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            // Kategori & Viewers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Text(
                    data['category']!,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.groups, color: Colors.blueAccent, size: 14),
                    SizedBox(width: 4),
                    Text(
                      ' ${data['viewers']!}',
                      style: TextStyle(color: Colors.blueAccent, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            // Judul
            Text(
              data['title']!,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            // Author
            Row(
              children: [
                CircleAvatar(radius: 12, backgroundColor: Colors.grey.shade400),
                SizedBox(width: 8),
                Text(
                  data['author']!,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingCard(Map<String, String> data) {
    return InkWell(
      onTap: () {
        controller.goToEventDetail(data);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Biar foto dan teks sejajar di atas
          children: [
            // Thumbnail Gambar
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                data['thumbnail'] ?? 'images/profil.png', // Fallback aman
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            // Konten Informasi
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Baris Waktu & Tag Kategori
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data['time'] ?? 'No Time',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Judul Acara
                  Text(
                    data['titleupcoming'] ??
                        'No Title', // Pastikan key ini persis sama di Controller
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Baris Author (Aman dari Null)
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

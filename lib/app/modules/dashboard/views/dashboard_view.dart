import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranlator_v1/app/modules/dashboard/controllers/dashboard_controller.dart';
// import 'dashboard_controller.dart'; // Sesuaikan import-nya

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // === APPBAR SESUAI KODE LU ===
      appBar: AppBar(
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
          Row(
            children: [
              IconButton(
                onPressed: () => controller.goToHistory(),
                icon: Icon(
                  Icons.notifications_active,
                  color: Colors.blue[700],
                  size: 25,
                ),
              ),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'View all >',
                      style: TextStyle(color: Colors.blueAccent),
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
                  Row(
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
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.filter_list, color: Colors.blueAccent),
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
                        // Ambil data berdasarkan urutan (index)
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  Text(
                    'History',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Color(0xFFF4F6FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 10,
                    bottom: 20,
                    child: Icon(
                      Icons.menu_book_rounded,
                      size: 100,
                      color: Colors.blue,
                    ),
                  ),
            
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Judul
                        Text(
                          "Review Your History",
                          style: TextStyle(
                            color: Color(0xFF1D4ED8),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 12),
            
                        Text(
                          "Access summaries and transcripts of all events\nyou've attended.",
                          style: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
            
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            controller.goToHistory();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF0044FF),
                            foregroundColor: Colors.white,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            "Go to History",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
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
    );
  }

  // === DESAIN CARD  ==============
  Widget _buildLiveCard(Map<String, String> data) {
    return InkWell(
      onTap: () {
        controller.goToEventDetail();
      },
      child:  Container(
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranlator_v1/app/components/custom_bottom_nav.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],

      // === APPBAR ===
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[50],
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                image: const DecorationImage(
                  image: AssetImage("assets/images/logo_syncro.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "syncro",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Color(0xFF05114D),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => controller.goToNotifikasi(),
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Color(0xFF1E293B),
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),

      // === BODY ===
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // --- HEADER: SEDANG BERLANGSUNG ---
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'dash_ongoing'.tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),

            // --- HORIZONTAL SCROLL LIVE ---
            SizedBox(
              height: 320,
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.liveStreamData.isEmpty) {
                  return Center(
                    child: Text(
                      'dash_no_live'.tr,
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  );
                }
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 15.0,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.liveStreamData.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 20),
                  itemBuilder: (context, index) {
                    final data = controller.liveStreamData[index];
                    return GestureDetector(
                      // Tambahkan baris ini agar seluruh area card sensitif terhadap klik!
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        // Tambahkan print ini untuk memastikan kliknya masuk
                        print("Card Event di-klik! Data: $data");

                        controller.goToEventDetail(data);
                      },
                      child: _buildLiveCard(data),
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 15),

            // --- HEADER: EVENT MENDATANG ---
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'dash_upcoming'.tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  InkWell(
                    onTap: () => controller.goToEvents(),
                    child: Text(
                      'dash_see_all'.tr,
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- VERTIKAL SCROLL UPCOMING EVENTS ---
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (controller.upcomingEventsData.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'dash_no_upcoming'.tr,
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                itemCount: controller.upcomingEventsData.length > 3
                    ? 3
                    : controller.upcomingEventsData.length,
                itemBuilder: (context, index) {
                  final data = controller.upcomingEventsData[index];
                  return _buildUpcomingCard(data);
                },
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 0,
        role: 'user',
      ),
    );
  }

  // ==========================================
  // DESAIN KARTU LIVE
  // ==========================================
  Widget _buildLiveCard(Map<String, dynamic> data) {
    final imageUrl = data['image_url'];

    return InkWell(
      onTap: () => controller.goToEventDetail(data),
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.08),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(18),
                    image: DecorationImage(
                      image: imageUrl != null && imageUrl.toString().isNotEmpty
                          ? NetworkImage(imageUrl) as ImageProvider
                          : const AssetImage('assets/images/placeholder.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  (data['location'] ?? 'Online').toString().toUpperCase(),
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const Row(
                  children: [
                    Icon(
                      Icons.people_alt_rounded,
                      color: Colors.grey,
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '1.2K',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              data['title'] ??
                  'Event Tanpa Judul', // Default diubah ke Indonesia
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.blue[100],
                  child: const Icon(
                    Icons.person,
                    size: 14,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Admin Syncra",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // DESAIN KARTU EVENT MENDATANG (Dengan Harga)
  // ==========================================
  Widget _buildUpcomingCard(Map<String, dynamic> data) {
    // 1. Persiapan Data Dasar
    final imageUrl = data['image_url'];
    final eventDate = data['event_date'] ?? '-';
    final rawTime = data['event_time']?.toString() ?? '00:00';
    final eventTime = rawTime.length > 5 ? rawTime.substring(0, 5) : rawTime;

    // 2. Logika Format Harga Rupiah Langsung di View
    final price = data['price'];
    String priceText = 'Gratis';
    if (price != null && price != 0 && price.toString() != '0') {
      String priceStr = price.toString();
      String formatted = '';
      int counter = 0;
      for (int i = priceStr.length - 1; i >= 0; i--) {
        counter++;
        formatted = priceStr[i] + formatted;
        if (counter % 3 == 0 && i != 0) {
          formatted = '.$formatted';
        }
      }
      priceText = 'Rp $formatted';
    }

    return InkWell(
      onTap: () {
        controller.goToEventDetail(data); // Bawa data ke halaman detail
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE THUMBNAIL
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blue[50],
                image: DecorationImage(
                  image: imageUrl != null && imageUrl.toString().isNotEmpty
                      ? NetworkImage(imageUrl) as ImageProvider
                      : const AssetImage('assets//placeholder.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TANGGAL & WAKTU
                  Text(
                    '$eventDate | $eventTime WIB',
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // JUDUL EVENT
                  Text(
                    data['title'] ?? 'Tanpa Judul',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF1E293B),
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),

                  // BARIS BAWAH: LOKASI & HARGA
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Lokasi (Kiri)
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 14,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                data['location'] ?? 'Online',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Harga (Kanan)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: priceText == 'Gratis'
                              ? Colors.green.withOpacity(0.1)
                              : Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          priceText,
                          style: TextStyle(
                            color: priceText == 'Gratis'
                                ? Colors.green[700]
                                : Colors.blue[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
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

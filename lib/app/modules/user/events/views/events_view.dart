import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/events_controller.dart';

class EventsView extends GetView<EventsController> {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey[50], // Latar belakang abu-abu sangat muda (Neumorphism)
      // === APPBAR ===
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0, // Hilangkan garis bawah
        centerTitle: true,
        title: const Text(
          "Semua Event", // Bahasa Indonesia
          style: TextStyle(
            color: Color(0xFF1E293B), // Warna teks elegan
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1E293B),
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
      ),

      // === BODY ===
      body: Column(
        children: [
          // Kolom Pencarian (Desain Melayang)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 15.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.withOpacity(0.06),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Cari event...", // Bahasa Indonesia
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Colors.blueAccent,
                  ),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      color: Colors.blueAccent,
                      size: 20,
                    ), // Ganti icon filter biar lebih pas
                  ),
                  border: InputBorder.none, // Hilangkan garis border kasar
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),

          // Daftar Event
          Expanded(
            child: Obx(() {
              // Jika data sedang dimuat
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              // Jika data kosong
              if (controller.upcomingEventsData.isEmpty) {
                return Center(
                  child: Text(
                    "Belum ada event mendatang.",
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                );
              }
              // Jika data tersedia
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                itemCount: controller.upcomingEventsData.length,
                itemBuilder: (context, index) {
                  final data = controller.upcomingEventsData[index];
                  return _buildUpcomingCard(data);
                },
              );
            }),
          ),
        ],
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
                      : const AssetImage('images/placeholder.png'),
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notifikasi_controller.dart';

class NotifikasiView extends GetView<NotifikasiController> {
  const NotifikasiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Background terang Neumorphism
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B), size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF0038FF),
            ),
          );
        }

        // Jika tidak ada notifikasi
        if (controller.notifications.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => controller.fetchNotifications(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 15),
                      Text(
                        "Belum ada notifikasi",
                        style: TextStyle(color: Colors.grey[500], fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Pembaruan event dan tiket akan muncul di sini.",
                        style: TextStyle(color: Colors.grey[400], fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // Jika ada notifikasi (Looping data)
        return RefreshIndicator(
          onRefresh: () => controller.fetchNotifications(),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: controller.notifications.length,
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              final notif = controller.notifications[index];
              return _buildNotificationCard(
                type: notif['type']!,
                title: notif['title']!,
                message: notif['message']!,
                time: notif['time']!,
                buttonText: notif['button_text']!,
                onTap: () => controller.onNotificationTap(notif),
              );
            },
          ),
        );
      }),
    );
  }

  // ==========================================
  // WIDGET BANTUAN UNTUK KARTU NOTIFIKASI
  // ==========================================
  Widget _buildNotificationCard({
    required String type,
    required String title,
    required String message,
    required String time,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    // Menentukan Tema (Warna & Ikon) berdasarkan Tipe Notifikasi
    Color primaryColor;
    IconData iconData;

    if (type == 'purchase') {
      primaryColor = const Color(0xFF34A853); // Hijau untuk Sukses Beli
      iconData = Icons.local_activity_rounded;
    } else if (type == 'reminder') {
      primaryColor = Colors.orangeAccent; // Oranye untuk Peringatan Waktu
      iconData = Icons.alarm_rounded;
    } else {
      primaryColor = Colors.blueAccent; // Biru untuk Info Baru
      iconData = Icons.campaign_rounded;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Ikon Kiri
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor.withOpacity(0.1),
            ),
            child: Icon(iconData, size: 24, color: primaryColor),
          ),
          const SizedBox(width: 16),
          
          // 2. Konten Kanan (Teks & Tombol)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Judul & Waktu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: TextStyle(color: Colors.grey[400], fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                
                // Pesan Deskripsi
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                
                // Tombol Aksi
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        buttonText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
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
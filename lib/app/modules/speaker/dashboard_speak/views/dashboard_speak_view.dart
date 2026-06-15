import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranlator_v1/app/components/custom_bottom_nav.dart';

import '../controllers/dashboard_speak_controller.dart';

class DashboardSpeakView extends GetView<DashboardSpeakController> {
  const DashboardSpeakView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Background terang Neumorphism
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false, // Menghilangkan tombol back
        title: Column(
          children: [
            const Text(
              'Dashboard Speaker',
              style: TextStyle(
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 0.5,
              ),
            ),
            // Nama Speaker Dinamis dari Controller
            Obx(() => Text(
              'Selamat Datang, ${controller.speakerName.value}',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            )),
          ],
        ),
      ),
      
      // ==========================================
      // BODY DINAMIS (OBX)
      // ==========================================
      body: Obx(() {
        // Tampilkan loading jika data masih diambil
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.event_note_rounded, color: Colors.blue[800], size: 22),
                  const SizedBox(width: 8),
                  const Text(
                    "Agenda Hari Ini",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ==========================================
              // RENDER KARTU: EVENT SEDANG LIVE
              // ==========================================
              if (controller.liveEvents.isEmpty)
                _buildEmptyState("Tidak ada jadwal Live saat ini.")
              else
                ...controller.liveEvents.map((event) => Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: _buildEventCard(
                    title: event['title'] ?? 'Tanpa Judul',
                    location: event['location'] ?? 'Online',
                    time: '${event['event_time']?.toString().substring(0, 5) ?? 'TBA'} WIB',
                    status: 'LIVE',
                    isActive: true,
                    onTap: () => controller.goToPresent(event),
                  ),
                )).toList(),

              const SizedBox(height: 10),
              const Divider(color: Colors.black12, thickness: 1),
              const SizedBox(height: 20),

              const Text(
                "Acara Mendatang",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 15),

              // ==========================================
              // RENDER KARTU: EVENT UPCOMING
              // ==========================================
              if (controller.upcomingEvents.isEmpty)
                _buildEmptyState("Belum ada jadwal acara mendatang.")
              else
                ...controller.upcomingEvents.map((event) => Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: _buildEventCard(
                    title: event['title'] ?? 'Tanpa Judul',
                    location: event['location'] ?? 'Online',
                    time: '${event['event_date']} | ${event['event_time']?.toString().substring(0, 5) ?? ''} WIB',
                    status: 'UPCOMING',
                    isActive: false,
                  ),
                )).toList(),

              const SizedBox(height: 40),
            ],
          ),
        );
      }),
      
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 0,
        role: 'speaker',
      ),
    );
  }

  // ==========================================
  // WIDGET BANTUAN UNTUK KONDISI KOSONG
  // ==========================================
  Widget _buildEmptyState(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100], 
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(text, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
      ),
    );
  }

  // ==========================================
  // WIDGET BANTUAN UNTUK KARTU EVENT
  // ==========================================
  Widget _buildEventCard({
    required String title,
    required String location,
    required String time,
    required String status,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris Atas: Judul dan Badge Status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E293B),
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isActive ? Colors.red.shade50 : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isActive) const Icon(Icons.circle, size: 8, color: Colors.red),
                    if (isActive) const SizedBox(width: 4),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isActive ? Colors.red : Colors.orange[800],
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Info Lokasi dan Waktu
          Row(
            children: [
              Icon(Icons.location_on_rounded, size: 16, color: Colors.grey[400]),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  location,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('|', style: TextStyle(color: Colors.grey[300])),
              ),
              Icon(Icons.access_time_rounded, size: 16, color: Colors.grey[400]),
              const SizedBox(width: 6),
              Text(
                time,
                style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.bold),
              ),
            ],
          ),
          
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(height: 1, thickness: 1),
          ),
          
          // Tombol Aksi
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: isActive ? onTap : null, // Jika tidak aktif, tombol mati
              icon: Icon(
                isActive ? Icons.play_circle_fill_rounded : Icons.lock_rounded,
                color: isActive ? Colors.white : Colors.grey[400],
                size: 20,
              ),
              label: Text(
                isActive ? 'Masuk Ruang Presentasi' : 'Belum Tersedia',
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey[500],
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isActive ? Colors.blueAccent : Colors.grey[100],
                disabledBackgroundColor: Colors.grey[100],
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
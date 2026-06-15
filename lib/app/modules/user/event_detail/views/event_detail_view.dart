import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../controllers/event_detail_controller.dart';

class EventDetailView extends GetView<EventDetailController> {
  const EventDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Background terang Neumorphism
      // AppBar Transparan agar menyatu dengan gambar header
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1E293B),
              size: 20,
            ),
            onPressed: () => Get.back(),
          ),
        ),
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ==========================================
            // 1. GAMBAR HEADER & STATUS EVENT
            // ==========================================
            Stack(
              children: [
                // Gambar Event dari Supabase
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    image: DecorationImage(
                      image: controller.imageUrl.isNotEmpty
                          ? NetworkImage(controller.imageUrl) as ImageProvider
                          : const AssetImage(
                              "assets/images/placeholder.png",
                            ), // Gambar cadangan
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Gradien Hitam di Bawah Gambar agar Teks Terbaca
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                // Badge Status & Judul
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: controller.status == 'LIVE'
                              ? Colors.redAccent
                              : Colors.blueAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (controller.status == 'LIVE')
                              const Icon(
                                Icons.circle,
                                size: 8,
                                color: Colors.white,
                              ),
                            if (controller.status == 'LIVE')
                              const SizedBox(width: 6),
                            Text(
                              controller.status == 'UPCOMING'
                                  ? 'MENDATANG'
                                  : controller.status,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        controller.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ==========================================
            // 2. KARTU JADWAL, LOKASI & HARGA
            // ==========================================
            Transform.translate(
              offset: const Offset(0, -10),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(15), 
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Kolom Jadwal
                    Expanded(
                      child: Column(
                        children: [
                          Icon(Icons.calendar_month_rounded, color: Colors.blue[700], size: 20),
                          const SizedBox(height: 4),
                          Text("Jadwal", style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                          const SizedBox(height: 2),
                          Text(
                            controller.eventDateTime,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(height: 35, width: 1, color: Colors.grey[200]),
                    
                    // Kolom Lokasi
                    Expanded(
                      child: Column(
                        children: [
                          Icon(Icons.location_on_rounded, color: Colors.orange[700], size: 20),
                          const SizedBox(height: 4),
                          Text("Lokasi", style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                          const SizedBox(height: 2),
                          Text(
                            controller.location,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(height: 35, width: 1, color: Colors.grey[200]),
                    
                    // Kolom Harga Tiket
                    Expanded(
                      child: Column(
                        children: [
                          Icon(Icons.confirmation_number_rounded, color: Colors.green[700], size: 20),
                          const SizedBox(height: 4),
                          Text("Harga", style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                          const SizedBox(height: 2),
                          Text(
                            controller.eventPrice, 
                            style: TextStyle(
                              fontSize: 12, 
                              fontWeight: FontWeight.bold, 
                              color: controller.eventPrice == 'Gratis' ? Colors.green[700] : const Color(0xFF1E293B)
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ==========================================
            // 3. DESKRIPSI EVENT
            // ==========================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tentang Event",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    controller.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // ==========================================
            // 3.5. DAFTAR PEMATERI / SPEAKER
            // ==========================================
            Obx(() {
              if (controller.speaker1.value.isEmpty) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Pemateri",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Speaker 1 (Wajib)
                    _buildSpeakerTile(controller.speaker1.value),
                    
                    // Speaker 2 (Opsional)
                    if (controller.speaker2.value.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _buildSpeakerTile(controller.speaker2.value),
                    ],

                    // Speaker 3 (Opsional)
                    if (controller.speaker3.value.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _buildSpeakerTile(controller.speaker3.value),
                    ],
                  ],
                ),
              );
            }),
            const SizedBox(height: 30),

            // ==========================================
            // 4. PEMBICARA / PENYELENGGARA
            // ==========================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Penyelenggara",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.blue[100],
                          child: const Icon(
                            Icons.person,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Admin Syncra", 
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Penyelenggara Acara",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
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
            const SizedBox(height: 40),

            // ==========================================
            // 5. STATUS TIKET (LOGIKA GETX)
            // ==========================================
            Obx(() {
              if (controller.hasTicket.value) {
                return _buildTicketPurchased();
              } else {
                return _buildTicketRequired();
              }
            }),

            const SizedBox(height: 100), 
          ],
        ),
      ),

      // ==========================================
      // TOMBOL BAYAR BAWAH MELAYANG + HARGA TOTAL
      // ==========================================
      bottomNavigationBar: Obx(() {
        if (!controller.hasTicket.value) {
          return Container(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              top: 15,
              bottom: 35, 
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Harga', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                        const SizedBox(height: 2),
                        Text(
                          controller.eventPrice,
                          style: const TextStyle(
                            color: Color(0xFF1E293B),
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 0,
                        ),
                        onPressed: () => controller.goToPembayaran(), 
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.payment_rounded, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Beli Tiket', 
                              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      }),
    );
  }

  // ==========================================
  // WIDGET UI: SUDAH BELI TIKET
  // ==========================================
  Widget _buildTicketPurchased() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: const BoxDecoration(
                    color: Color(0xFF34A853),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 22),
                      SizedBox(width: 8),
                      Text(
                        "TIKET TERKONFIRMASI",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("ID Tiket", style: TextStyle(fontSize: 14, color: Colors.grey)),
                          Obx(
                            () => Text(
                              controller.ticketCode.value,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B)),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Verifikasi Wajah", style: TextStyle(fontSize: 14, color: Colors.grey)),
                          Row(
                            children: [
                              const Icon(Icons.check_circle, color: Color(0xFF34A853), size: 18),
                              const SizedBox(width: 4),
                              const Text(
                                "SELESAI",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF34A853), fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Icon(Icons.qr_code_2_rounded, size: 150, color: Color(0xFF1E293B)),
                      const SizedBox(height: 12),
                      const Text(
                        "Scan QR code ini di pintu masuk event",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              onPressed: () => controller.goToLive(),
              icon: const Icon(Icons.live_tv_rounded, color: Colors.white),
              label: const Text(
                'Gabung Ruang Live',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // WIDGET UI: BELUM PUNYA TIKET
  // ==========================================
  Widget _buildTicketRequired() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1), 
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFD6A033).withOpacity(0.5), width: 1.5),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFD6A033),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                  ),
                  child: const Center(
                    child: Text(
                      "MEMBUTUHKAN TIKET",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Icon(Icons.confirmation_num_outlined, size: 100, color: Color(0xFFD6A033)),
                      const SizedBox(height: 20),
                      const Text(
                        'Selesaikan pembelian untuk mendapatkan QR Code akses event Anda.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => controller.lockticket(),
              icon: const Icon(Icons.lock_rounded, color: Colors.white, size: 20),
              label: const Text('Ruang Live Terkunci', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade400,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // WIDGET BANTUAN UNTUK ITEM PEMATERI
  // ==========================================
  Widget _buildSpeakerTile(String name) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mic_rounded,
              color: Colors.orangeAccent,
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranlator_v1/app/components/custom_bottom_nav.dart';

import '../controllers/ticket_controller.dart';

class TicketView extends GetView<TicketController> {
  const TicketView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Tiket Saya', 
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
      ),
      // MENGGUNAKAN OBX AGAR UI REAKTIF DENGAN DATABASE
      body: Obx(() {
        // 1. Tampilan Loading
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.blueAccent),
          );
        }

        // 2. Tampilan Jika Belum Punya Tiket Sama Sekali
        if (controller.upcomingTickets.isEmpty && controller.completedTickets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.confirmation_number_outlined, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 15),
                Text(
                  "Belum ada tiket",
                  style: TextStyle(color: Colors.grey[500], fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  "Tiket yang kamu beli akan muncul di sini.",
                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                ),
              ],
            ),
          );
        }

        // 3. Tampilan Jika Ada Tiket
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==========================================
                // LOOPING TIKET UPCOMING (AKTIF)
                // ==========================================
                if (controller.upcomingTickets.isNotEmpty) ...[
                  const Text(
                    "Tiket Aktif",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 15),
                  ...controller.upcomingTickets.map((ticket) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: _buildTicketCard(
                        context,
                        ticketCode: ticket['ticket_code'], // Data dari DB
                        title: ticket['title'],
                        speaker: ticket['speaker'],
                        date: ticket['date'],
                        time: ticket['time'],
                        isActive: true,
                      ),
                    );
                  }).toList(),
                ],

                // ==========================================
                // LOOPING TIKET COMPLETED (SELESAI)
                // ==========================================
                if (controller.completedTickets.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  const Text(
                    "Riwayat Acara",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 15),
                  ...controller.completedTickets.map((ticket) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: _buildTicketCard(
                        context,
                        ticketCode: ticket['ticket_code'], // Data dari DB
                        title: ticket['title'],
                        speaker: ticket['speaker'],
                        date: ticket['date'],
                        time: ticket['time'],
                        isActive: false,
                        hasMaterials: true,
                      ),
                    );
                  }).toList(),
                ],
                
                const SizedBox(height: 40), 
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1,
        role: 'user', 
      ),
    );
  }

  // ==========================================
  // WIDGET BANTUAN UNTUK MEMBUAT KARTU TIKET
  // ==========================================
  // Menambahkan parameter ticketCode agar popUp QR tidak error
  Widget _buildTicketCard(
    BuildContext context, {
    required String ticketCode,
    required String title,
    required String speaker,
    required String date,
    required String time,
    required bool isActive,
    bool hasMaterials = false,
  }) {
    return Container(
      width: double.infinity,
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. BAGIAN GAMBAR HEADER
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/background-card.jpg',
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    // Error builder jika gambar belum ditambahkan di assets
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 140, width: double.infinity, color: Colors.blue[100],
                    ),
                  ),
                  Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.blueAccent : Colors.grey[600],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isActive ? 'UPCOMING' : 'COMPLETED',
                        style: const TextStyle(
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
            ),
          ),

          // 2. BAGIAN DETAIL TIKET
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          color: Color(0xFF1E293B),
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // TINGGAL MENGIRIM PARAMETER KE CONTROLLER AGAR TIDAK ERROR
                    InkWell(
                      onTap: () => controller.popUp(ticketCode, title),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.qr_code_2_rounded,
                          color: Colors.blue[700],
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // Info Speaker
                Row(
                  children: [
                    Icon(Icons.person_outline_rounded, size: 18, color: Colors.grey[500]),
                    const SizedBox(width: 8),
                    Text(
                      speaker, 
                      style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w600)
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Info Jadwal
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey[400]),
                    const SizedBox(width: 8),
                    Text(
                      date,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('|', style: TextStyle(color: Colors.grey[300])),
                    ),
                    Text(
                      time.isNotEmpty ? time.substring(0, 5) : '00:00',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
                
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Divider(height: 1, thickness: 1),
                ),

                // 3. BAGIAN TOMBOL AKSI
                if (isActive)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => controller.goToLive(),
                      icon: const Icon(Icons.live_tv_rounded, color: Colors.white, size: 20),
                      label: const Text(
                        'Gabung Ruang Live',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  )
                else if (hasMaterials)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => print("Open Materials"),
                          icon: Icon(Icons.menu_book_rounded, size: 18, color: Colors.blue[700]),
                          label: Text(
                            "Materi",
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue[700]),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(color: Colors.blue.shade200),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => print("Download Summary"),
                          icon: const Icon(Icons.picture_as_pdf_rounded, size: 18, color: Colors.white),
                          label: const Text(
                            "Ringkasan",
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[600],
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: null,
                      icon: Icon(Icons.check_circle_rounded, color: Colors.grey[400], size: 20),
                      label: Text(
                        'Acara Telah Berakhir',
                        style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
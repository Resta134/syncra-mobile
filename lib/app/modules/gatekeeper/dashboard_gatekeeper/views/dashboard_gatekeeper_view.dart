import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranlator_v1/app/components/custom_bottom_nav.dart';
import '../controllers/dashboard_gatekeeper_controller.dart';

class DashboardGatekeeperView extends GetView<DashboardGatekeeperController> {
  const DashboardGatekeeperView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        title: Column(
          children: [
            const Text('Dashboard Gatekeeper', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Nama User', style: TextStyle(color: Colors.blue.shade200, fontSize: 11)),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildCapacityCard(),
            const SizedBox(height: 20),
            
            // Dua Tombol Utama
            Row(
              children: [
                Expanded(child: _buildActionButton("Face Scan", Icons.fingerprint, () => controller.vermuk())),
                const SizedBox(width: 15),
                Expanded(child: _buildActionButton("QR Code", Icons.qr_code_scanner, () => controller.qr())),
              ],
            ),
            
            const SizedBox(height: 25),
            
            // Header List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Kehadiran Terkini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                TextButton(onPressed: () => controller.goToValidation(), child: const Text("Lihat Semua")),
              ],
            ),
            
            _buildListItem('Sarah Jenkins', 'Group A', 'Baru saja', 'Scanned'),
            _buildListItem('Michael Chen', 'Group C', '2 menit lalu', 'QR Code'),
            _buildListItem('Elena Rodriguez', 'Speaker', '5 menit lalu', 'Scanned'),
            
            const SizedBox(height: 25),
            _buildReportCard(),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0, role: 'gatekeeper'),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
      ),
      child: Column(
        children: [Icon(icon, size: 28, color: const Color(0xFF0038FF)), const SizedBox(height: 8), Text(label, style: const TextStyle(fontWeight: FontWeight.bold))],
      ),
    );
  }

  Widget _buildCapacityCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('KAPASITAS HALL', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 11)),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(6)), child: const Text('LIVE', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 20),
          Stack(alignment: Alignment.center, children: [
            SizedBox(width: 120, height: 120, child: CircularProgressIndicator(value: 178 / 200, strokeWidth: 10, color: const Color(0xFF0038FF), backgroundColor: Colors.grey.shade100)),
            Column(children: [const Text('178', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)), const Text('/ 200', style: TextStyle(color: Colors.grey))]),
          ]),
        ],
      ),
    );
  }

  Widget _buildListItem(String name, String details, String time, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade100)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: Colors.blue.shade50, child: const Icon(Icons.person, color: Color(0xFF0038FF))),
          const SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontWeight: FontWeight.bold)), Text(details, style: const TextStyle(fontSize: 12, color: Colors.grey))])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)), Text(status, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0038FF)))]),
        ],
      ),
    );
  }

  Widget _buildReportCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Laporkan Masalah', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 15),
          const Text('Alasan Kegagalan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(height: 50, decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)), child: const Center(child: Text("Pilih Alasan..."))),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 30, 89, 183), minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Kirim Laporan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
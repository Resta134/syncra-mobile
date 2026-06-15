import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranlator_v1/app/components/custom_bottom_nav.dart';
import '../controllers/dashboard_mod_controller.dart';

class DashboardModView extends GetView<DashboardModController> {
  const DashboardModView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Container(
              width: 35, height: 35,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: AssetImage("assets/images/image.png"), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 10),
            const Text("synCra App", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              onPressed: () => controller.goToNotifikasi(),
              icon: const Icon(Icons.notifications_active, color: Color(0xFF0038FF)),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Nav Cards
          Row(
            children: [
              Expanded(child: _buildNavCard(Icons.monitor, "Transcript", () => controller.goToTranscript())),
              const SizedBox(width: 15),
              Expanded(child: _buildNavCard(Icons.forum, "Q&A Queue", () => controller.goToQA())),
            ],
          ),
          const SizedBox(height: 30),
          const Text("Broadcast Center", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          _buildEnhancedBroadcastCard(),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0, role: 'moderator'),
    );
  }

  Widget _buildNavCard(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: const Color(0xFF0038FF)),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedBroadcastCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller.broadcastController,
            maxLines: 3,
            decoration: const InputDecoration(hintText: "Tulis pesan broadcast...", border: InputBorder.none),
          ),
          const Divider(),
          const Text("Pilih Template:", style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTemplateChip("Sesi dimulai 5 menit lagi"),
              _buildTemplateChip("Waktu Q&A sisa 10 menit"),
              _buildTemplateChip("Mohon tenang saat sesi berlangsung"),
              _buildTemplateChip("Terima kasih atas partisipasinya"),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.sendBroadcast(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0038FF),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("Kirim Sekarang", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateChip(String label) {
    return InkWell(
      onTap: () => controller.fillBroadcast(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
        child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF0038FF), fontWeight: FontWeight.w500)),
      ),
    );
  }
}
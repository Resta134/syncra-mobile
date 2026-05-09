import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/dashboard_mod_controller.dart';

class DashboardModView extends GetView<DashboardModController> {
  const DashboardModView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF0F4F8,
      ), // Warna background abu-abu kebiruan terang
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
                onPressed: () => controller.goToNotifikasi(),
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Navigation Cards
            _buildNavCard(
              icon: Icons.monitor_heart_outlined,
              title: 'Live Transcript Monitor',
              onTap: () {
                controller.goToTranscript();
              },
            ),
            SizedBox(height: 12),
            _buildNavCard(
              icon: Icons.forum_outlined,
              title: 'Q&A Curation Queue',
              onTap: () {
                controller.goToQA();
              },
            ),

            const SizedBox(height: 24),

            // 2. Broadcast Center Section
            const Text(
              'Broadcast Center',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            _buildBroadcastCard(),

            const SizedBox(height: 24),

            // Server Status (Opsional, dibiarkan sebagai footer)
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.circle, color: Colors.green, size: 10),
                  SizedBox(width: 6),
                  Text(
                    'Server Optimal',
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Builder untuk Navigation Card
  Widget _buildNavCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell( // <-- TAMBAHKAN INKWELL AGAR BISA DI-KLIK
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF0038FF)), // Biru aksen
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
 
  // Widget Builder untuk Broadcast Center Card
  Widget _buildBroadcastCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.campaign_outlined, color: Color(0xFF1E293B)),
              SizedBox(width: 8),
              Text(
                'Custom Broadcast',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            maxLines: 4,
            maxLength: 150,
            decoration: InputDecoration(
              hintText: 'Type your message here...',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF0038FF)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () {
                
              },
              icon: const Icon(Icons.send, size: 18),
              label: const Text('Send Broadcast'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0038FF), // Biru tombol
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Quick Broadcast Templates',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTemplateChip('Session start in 5m'),
                const SizedBox(width: 8),
                _buildTemplateChip('10m left for Q&A'),
                const SizedBox(width: 8),
                _buildTemplateChip('Thanks for Q&A'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget Builder untuk Template Chip
  Widget _buildTemplateChip(String label) {
    return ActionChip(
      label: Text(label),
      labelStyle: const TextStyle(fontSize: 12, color: Color(0xFF1E293B)),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      onPressed: () {
        // TODO: Logika untuk mengisi textfield dengan template ini
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/live_controller.dart';

class LiveView extends GetView<LiveController> {
  const LiveView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B), size: 20),
          onPressed: () => Get.back(),
        ),
        title: Column(
          children: [
            const Text(
              'AI Ethics & Future of Work',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 2),
            Text(
              'Dr. Mulyono',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.circle, color: Colors.redAccent, size: 8),
                const SizedBox(width: 6),
                const Text('LIVE', style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Icon(Icons.remove_red_eye_rounded, color: Colors.grey[600], size: 12),
                const SizedBox(width: 4),
                Text('2.3K', style: TextStyle(color: Colors.grey[700], fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
      
      // ==========================================
      // TOMBOL Q&A MENGAMBANG (FLOATING)
      // ==========================================
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showQnABottomSheet(context),
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.forum_rounded, color: Colors.white),
        label: const Text(
          "Diskusi & Tanya",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: Column(
        children: [
          // ==========================================
          // 1. KONTROL AUDIO (DENGARKAN TERJEMAHAN)
          // ==========================================
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blueAccent.withOpacity(0.1),
                  child: IconButton(
                    icon: const Icon(Icons.volume_up_rounded, color: Colors.blueAccent),
                    onPressed: () {}, // Logika Play/Pause Audio
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Terjemahan Suara AI (ID)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B)),
                      ),
                      Text(
                        'Sedang memutar...',
                        style: TextStyle(color: Colors.blue[400], fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '1.0x',
                    style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // ==========================================
          // 2. LIVE TRANSCRIPT (FULL SCREEN)
          // ==========================================
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(color: Colors.blueGrey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
                ],
              ),
              child: Column(
                children: [
                  // Header Transkrip
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.g_translate_rounded, color: Colors.blue[800], size: 18),
                        const SizedBox(width: 8),
                        Text(
                          "TRANSKRIP TERJEMAHAN LANGSUNG",
                          style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1.5),
                        ),
                      ],
                    ),
                  ),
                  
                  // Area Scroll Teks Utama
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(20),
                      physics: const BouncingScrollPhysics(),
                      itemCount: 20, // Contoh data looping
                      separatorBuilder: (context, index) => const Divider(height: 35, color: Colors.black12),
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Teks Terjemahan (Indonesia) - FOKUS UTAMA
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                  decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                                  child: Text("ID", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue[700])),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    'Ini adalah hasil terjemahan langsung ke Bahasa Indonesia. Ukuran font dibuat besar dan jelas agar peserta dapat membacanya dengan nyaman tanpa harus menyipitkan mata.',
                                    style: TextStyle(
                                      fontSize: 18, // Font besar
                                      color: Color(0xFF1E293B), // Warna gelap tegas
                                      fontWeight: FontWeight.w600, // Agak tebal
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Teks Asli (Inggris) - REDUP SEBAGAI REFERENSI
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 38), // Sejajar dengan teks atas
                                const Expanded(
                                  child: Text(
                                    'This is the original English transcript. It is made smaller, italicized, and less contrasting to act as a secondary reference.',
                                    style: TextStyle(
                                      fontSize: 13, 
                                      color: Colors.grey, 
                                      fontStyle: FontStyle.italic, 
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // WIDGET POP-UP BOTTOM SHEET (UNTUK Q&A)
  // ==========================================
  void _showQnABottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.75, // Mengambil 75% tinggi layar
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            // Garis tarik kecil di atas
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              height: 5,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            
            // Tab Switcher (Community vs My Question)
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(15)),
                child: Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.selectedTab.value = 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: controller.selectedTab.value == 0 ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: controller.selectedTab.value == 0
                                  ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)] : [],
                            ),
                            child: Center(
                              child: Text(
                                'Diskusi Komunitas',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: controller.selectedTab.value == 0 ? Colors.blueAccent : Colors.grey[500],
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.selectedTab.value = 1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: controller.selectedTab.value == 1 ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: controller.selectedTab.value == 1
                                  ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)] : [],
                            ),
                            child: Center(
                              child: Text(
                                'Pertanyaan Saya',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: controller.selectedTab.value == 1 ? Colors.blueAccent : Colors.grey[500],
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // List Pertanyaan
            Expanded(
              child: Obx(() {
                final currentList = controller.selectedTab.value == 0
                    ? controller.communityQuestions
                    : controller.myQuestions;

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  physics: const BouncingScrollPhysics(),
                  itemCount: currentList.length,
                  separatorBuilder: (context, index) => const Divider(height: 24, color: Colors.black12),
                  itemBuilder: (context, index) {
                    final data = currentList[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.blue[50],
                          child: Text(
                            data['initial'] ?? 'U',
                            style: const TextStyle(fontSize: 12, color: Colors.blueAccent, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(data['name'] ?? 'User', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
                                  Text(data['time'] ?? 'Now', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                data['text'] ?? '',
                                style: TextStyle(fontSize: 13, height: 1.4, color: Colors.grey[800]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
            ),

            // Area Input Pertanyaan
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.blueGrey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Tanyakan sesuatu pada pemateri...',
                        hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blueAccent,
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                      onPressed: () {}, // Logika kirim pertanyaan
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true, // Memungkinkan Bottom Sheet membesar hingga 75% layar
      backgroundColor: Colors.transparent,
    );
  }
}
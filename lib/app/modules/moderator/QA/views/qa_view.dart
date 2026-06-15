import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranlator_v1/app/components/custom_bottom_nav.dart';
import '../controllers/qa_controller.dart';

class QaView extends GetView<QaController> {
  const QaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Abu-abu sangat muda
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(
          255,
          255,
          255,
          255,
        ), // Navy gelap yang tenang
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Kurasi Tanya Jawab',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header Section
          // Ganti bagian Header Section (di bawah AppBar) dengan ini:
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: const BoxDecoration(
              color: Colors.white,
              // Memberikan shadow halus agar header 'menopang' list di bawahnya
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
              // Membuat sudut bawah sedikit melengkung agar lebih modern
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Row(
              children: [
                // Tambahkan ikon kecil agar tidak terlalu polos
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.forum,
                    color: Color(0xFF1E293B),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Seminar AI: Dr. Cahaya',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      'Kelola pertanyaan audiens',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // List Pertanyaan
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.questions.length,
                itemBuilder: (context, index) =>
                    _buildQuestionCard(controller.questions[index]),
              ),
            ),
          ),

          // Footer Action Bar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Mulai Sesi'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => controller.stopQuestion(),
                      icon: const Icon(Icons.stop_rounded),
                      label: const Text('Akhiri Sesi'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1,
        role: 'moderator',
      ),
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> q) {
    bool isProjecting = q['status'] == 'projecting';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isProjecting ? const Color(0xFF1E293B) : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                q['sender'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              if (isProjecting)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Sedang Ditampilkan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            q['text'],
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Hapus',
                  Colors.grey.shade100,
                  Colors.black87,
                  () => controller.dismissQuestion(q['id']),
                ),
              ),
              if (q['status'] == 'pending') ...[
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    'Setujui',
                    Colors.indigo.shade50,
                    const Color(0xFF1E293B),
                    () => controller.approveQuestion(q['id']),
                  ),
                ),
              ],
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  isProjecting ? 'Ditampilkan' : 'Proyeksikan',
                  isProjecting
                      ? Colors.indigo.shade100
                      : const Color(0xFF1E293B),
                  isProjecting ? const Color(0xFF1E293B) : Colors.white,
                  () => controller.projectToScreen(q['id']),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    Color bg,
    Color fg,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: fg,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

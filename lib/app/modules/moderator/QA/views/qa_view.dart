import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranlator_v1/app/components/custom_bottom_nav.dart';
import '../controllers/qa_controller.dart';

class QaView extends GetView<QaController> {
  const QaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Abu-abu sangat muda bersih
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B), size: 20),
          // UBAH BARIS INI KEMBALI KE GET.BACK():
          onPressed: () => Get.back(), 
        ),
        title: const Text(
          'Kurasi Tanya Jawab',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ==========================================
          // HEADER PANEL INFO
          // ==========================================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.forum_rounded,
                    color: Color(0xFF1E293B),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 15),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Antrean Pertanyaan (Live)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Tentukan mana yang tampil ke publik',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ==========================================
          // AREA DAFTAR KARTU PERTANYAAN (OBX)
          // ==========================================
          Expanded(
            child: Obx(() {
              if (controller.questions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_rounded, size: 60, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text(
                        "Belum ada pertanyaan masuk",
                        style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Pertanyaan dari peserta akan muncul otomatis di sini.",
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                itemCount: controller.questions.length,
                itemBuilder: (context, index) => _buildQuestionCard(controller.questions[index]),
              );
            }),
          ),

          // ==========================================
          // FOOTER CONTROL BAR
          // ==========================================
          // Container(
          //   padding: const EdgeInsets.all(20),
          //   decoration: const BoxDecoration(
          //     color: Colors.white,
          //     boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
          //   ),

          //   // BUTTON
          //   child: SafeArea(
          //     child: Row(
          //       children: [
          //         Expanded(
          //           child: ElevatedButton.icon(
          //             onPressed: () {},
          //             icon: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
          //             label: const Text('Mulai Sesi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          //             style: ElevatedButton.styleFrom(
          //               backgroundColor: const Color(0xFF0F172A),
          //               foregroundColor: Colors.white,
          //               padding: const EdgeInsets.symmetric(vertical: 14),
          //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          //             ),
          //           ),
          //         ),
          //         const SizedBox(width: 12),
          //         Expanded(
          //           child: OutlinedButton.icon(
          //             onPressed: () => controller.stopQuestion(),
          //             icon: Icon(Icons.stop_rounded, color: Colors.red.shade700, size: 20),
          //             label: const Text('Akhiri Sesi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          //             style: OutlinedButton.styleFrom(
          //               foregroundColor: Colors.red.shade700,
          //               padding: const EdgeInsets.symmetric(vertical: 14),
          //               side: BorderSide(color: Colors.red.shade200),
          //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1,
        role: 'moderator',
      ),
    );
  }

  // ==========================================
  // DESAIN WIDGET KARTU KURASI PERTANYAAN
  // ==========================================
  Widget _buildQuestionCard(Map<String, dynamic> q) {
    bool isProjecting = q['status'] == 'projecting';
    bool isPending = q['status'] == 'pending';
    bool isApproved = q['status'] == 'approved';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isProjecting ? const Color(0xFF1E293B) : Colors.grey.shade200,
          width: isProjecting ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.person_rounded, size: 16, color: Colors.grey.shade400),
                  const SizedBox(width: 6),
                  Text(
                    q['sender'] ?? 'Peserta',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              if (isProjecting)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(6)),
                  child: const Text(
                    'SEDANG TAMPIL DI PROYEKTOR',
                    style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                )
              else if (isApproved)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    'TAMPIL DI HP PESERTA',
                    style: TextStyle(color: Colors.green.shade700, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    'MENUNGGU MODERASI',
                    style: TextStyle(color: Colors.orange.shade700, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            q['text'] ?? '',
            style: const TextStyle(fontSize: 14, height: 1.5, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildActionButton(
                  'Hapus',
                  Colors.grey.shade100,
                  Colors.red.shade700,
                  () => controller.dismissQuestion(q['id'].toString()),
                ),
              ),
              if (isPending) ...[
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: _buildActionButton(
                    'Setujui (Publik)',
                    Colors.indigo.shade50,
                    const Color(0xFF1E293B),
                    () => controller.approveQuestion(q['id'].toString()),
                  ),
                ),
              ],
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: _buildActionButton(
                  isProjecting ? 'Turunkan' : 'Proyeksikan',
                  isProjecting ? Colors.grey.shade200 : const Color(0xFF1E293B),
                  isProjecting ? Colors.black87 : Colors.white,
                  () => controller.projectToScreen(q['id'].toString()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, Color bg, Color fg, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
        child: Text(
          text,
          style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
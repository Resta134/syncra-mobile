import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranlator_v1/app/components/custom_bottom_nav.dart';
import '../controllers/q_a_speak_controller.dart';

class QASpeakView extends GetView<QASpeakController> {
  const QASpeakView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Sesi Tanya Jawab', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildControlPanel(),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Daftar Pertanyaan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Obx(() => Text('${controller.questions.where((q) => q['status'] == 'pending').length} Menunggu',
                    style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold, fontSize: 12))),
              ],
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.questions.isEmpty) {
                return const Center(child: Text("Belum ada pertanyaan masuk."));
              }
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.questions.length,
                itemBuilder: (context, index) {
                  var item = controller.questions[index];
                  return _buildQuestionCard(
                    id: item['id'],
                    name: item['name'],
                    // avatarUrl: item['avatar'],
                    question: item['question'],
                    isLive: item['isLive'],
                    status: item['status'] ?? 'pending',
                  );
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1, role: 'speaker'),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Obx(() => _buildActionChip(
            label: controller.isMicMuted.value ? "Mic Mati" : "Mic Nyala",
            icon: controller.isMicMuted.value ? Icons.mic_off : Icons.mic,
            color: controller.isMicMuted.value ? Colors.red : Colors.blue,
            onTap: () => controller.toggleMic(),
          )),
          Obx(() => _buildStatusChip(controller.aiStatus.value, Icons.psychology)),
          _buildActionChip(label: "Dashboard", icon: Icons.dashboard, color: Colors.grey.shade700, onTap: () => controller.goToDashboard()),
        ],
      ),
    );
  }

  Widget _buildQuestionCard({
    required String id, 
    required String name, 
    // required String avatarUrl, 
    required String question, 
    required bool isLive, 
    required String status,
  }) {
    bool isAnswered = status == 'answered';
    bool isSkipped = status == 'skipped';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: (isAnswered || isSkipped) ? Colors.grey.shade100 : (isLive ? Colors.orange.shade50 : Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: (isAnswered || isSkipped) ? Colors.grey.shade300 : (isLive ? Colors.orange.shade200 : Colors.grey.shade200)),
      ),
      child: Opacity(
        opacity: (isAnswered || isSkipped) ? 0.6 : 1.0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   children: [
              //     CircleAvatar(radius: 16, backgroundImage: NetworkImage(avatarUrl)),
              //     const SizedBox(width: 10),
              //     Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              //     const Spacer(),
              //     if (isAnswered) const Icon(Icons.check_circle, color: Colors.green, size: 20),
              //   ],
              // ),
              const SizedBox(height: 12),
              Text(question, style: TextStyle(
                fontSize: 15, height: 1.4,
                decoration: isAnswered ? TextDecoration.lineThrough : null,
              )),
              if (status == 'pending') ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: ElevatedButton(
                      onPressed: () => controller.markAsAnswered(id),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[900], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Text("Tandai Terjawab", style: TextStyle(color: Colors.white)),
                    )),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () => controller.skipQuestion(id),
                      style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Text("Lewati"),
                    ),
                  ],
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionChip({required String label, required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Row(children: [Icon(icon, size: 16, color: color), const SizedBox(width: 4), Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold))]),
      ),
    );
  }

  Widget _buildStatusChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Row(children: [Icon(icon, size: 16, color: Colors.green), const SizedBox(width: 4), Text(label, style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold))]),
    );
  }
}
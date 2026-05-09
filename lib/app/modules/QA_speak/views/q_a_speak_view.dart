import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/q_a_speak_controller.dart';

class QASpeakView extends GetView<QASpeakController> {
  const QASpeakView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'AI Seminar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildControlPanel(),

            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LIVE PRESENTATION: AI ETHICS & FUTURE OF WORK - Q&A',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Speaker: DR. Cahaya',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pertanyaan Curated (Hanya Ter ACC Moderator)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Obx(
                        () => Text(
                          '${controller.questions.length} Pertanyaan Ter ACC',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // AREA LIST PERTANYAAN BISA DI-SCROLL
            Expanded(
              child: Obx(() {
                if (controller.questions.isEmpty) {
                  return Center(child: Text("Belum ada pertanyaan masuk."));
                }
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.questions.length,
                  itemBuilder: (context, index) {
                    var item = controller.questions[index];
                    return _buildQuestionCard(
                      id: item['id'],
                      name: item['name'],
                      avatarUrl: item['avatar'],
                      question: item['question'],
                      isLive: item['isLive'],
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget Komponen ---

  Widget _buildControlPanel() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Speaker control panel',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Mic Button (Reaktif)
                Obx(
                  () => InkWell(
                    onTap: () => controller.toggleMic(),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: controller.isMicMuted.value
                            ? Colors.red.shade50
                            : Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: controller.isMicMuted.value
                              ? Colors.red
                              : Colors.blue.shade100,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            controller.isMicMuted.value
                                ? Icons.mic_off
                                : Icons.mic,
                            color: controller.isMicMuted.value
                                ? Colors.red
                                : Colors.blue,
                          ),
                          SizedBox(width: 8),
                          Text(controller.isMicMuted.value ? 'MUTE' : 'UNMUTE'),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),

                // AI Status
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.circle, color: Colors.green, size: 12),
                      SizedBox(width: 6),
                      Obx(
                        () => Text(
                          controller.aiStatus.value,
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),

                // Timer
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.blue, size: 16),
                      SizedBox(width: 6),
                      Obx(
                        () => Text(
                          controller.remainingTime.value,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10,),

                // back to dashboard
                InkWell(
                  onTap: () {
                 controller.goToDashboard();
                  },
                  child:        Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.home_sharp, color: Colors.blue, size: 16),
                      SizedBox(width: 6),
                      Text('Dashboard', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
        
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard({
    required int id,
    required String name,
    required String avatarUrl,
    required String question,
    required bool isLive,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      // Efek visual khusus jika pertanyaan sedang "Live" di proyektor
      decoration: BoxDecoration(
        color: isLive ? Colors.orange.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLive ? Colors.orange.shade300 : Colors.grey.shade200,
          width: isLive ? 2 : 1,
        ),
        boxShadow: [
          if (isLive)
            BoxShadow(
              color: Colors.orange.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label "LIVE ON STAGE" khusus pertanyaan yang sedang dibahas
          if (isLive)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.shade400,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Center(
                child: Text(
                  'LIVE ON STAGE (Proyeksi Moderator)',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),

          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(
                        avatarUrl,
                      ), // Menampilkan foto profil dari backend
                    ),
                    SizedBox(width: 10),
                    Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  'Q: $question',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () => controller.markAsAnswered(id),
                        icon: Icon(Icons.check, color: Colors.white),
                        label: Text(
                          'Tandai Sudah Dijawab',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: OutlinedButton.icon(
                        onPressed: () => controller.skipQuestion(id),
                        icon: Icon(
                          Icons.close,
                          color: Colors.grey[700],
                          size: 18,
                        ),
                        label: Text(
                          'Lewati',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

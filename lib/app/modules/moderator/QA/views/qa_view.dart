import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tranlator_v1/app/components/custom_bottom_nav.dart';

import '../controllers/qa_controller.dart';

class QaView extends GetView<QaController> {
  const QaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,//hapus arrow
        backgroundColor: Colors.blue[900],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Column(
          children: [
            Text(
              'AI Seminar',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              'Dr. Cahaya',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER TEXT
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Q&A Curation',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'serif',
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Manage incoming questions and send approved content to the main projector.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),

          // LIST PERTANYAAN
          Expanded(
            child: Obx(() {
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.questions.length,
                itemBuilder: (context, index) {
                  final q = controller.questions[index];
                  return _buildQuestionCard(q);
                },
              );
            }),
          ),

          // BOTTOM BAR (Start/End Session)
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.play_circle_outline_outlined,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Start Q&A Session',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        controller.stopQuestion();
                      },
                      icon: Icon(Icons.stop_circle, color: Colors.white),
                      label: Text(
                        'End Q&A Session',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
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
        role: 'moderator', // <-- Otomatis nampilin menu Q&A menyala
      ),
    );
  }

  // WIDGET CARD PERTANYAAN
  Widget _buildQuestionCard(Map<String, dynamic> q) {
    bool isProjecting = q['status'] == 'projecting';
    bool isApproved = q['status'] == 'approved';

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isProjecting ? Colors.blue.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isProjecting ? Colors.blue.shade700 : Colors.grey.shade300,
          width: isProjecting ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                q['sender'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isProjecting)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.arrow_upward, size: 12, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'On Screen',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              else if (isApproved)
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Approved',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: 12),
          // Isi Pertanyaan
          Text(
            q['text'],
            style: TextStyle(fontSize: 16, height: 1.4, fontFamily: 'serif'),
          ),
          SizedBox(height: 16),
          // Row Tombol Action
          Row(
            children: [
              // Tombol Dismiss
              ElevatedButton(
                onPressed: () => controller.dismissQuestion(q['id']),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Dismiss'),
              ),
              SizedBox(width: 8),

              // Jika Status Pending: Munculin Tombol Approve Outline
              if (q['status'] == 'pending') ...[
                OutlinedButton(
                  onPressed: () => controller.approveQuestion(q['id']),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue.shade700,
                    side: BorderSide(color: Colors.blue.shade700),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Approve'),
                ),
                SizedBox(width: 8),
              ],

              // Tombol Projecting (Beda style kalau lagi aktif)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: isProjecting
                      ? null
                      : () => controller.projectToScreen(q['id']),
                  icon: Icon(
                    isProjecting ? Icons.present_to_all : Icons.arrow_upward,
                    size: 16,
                  ),
                  label: Text(
                    isProjecting ? 'Projecting...' : 'Send to Projector',
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: isProjecting
                        ? Colors.blue.shade300
                        : Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

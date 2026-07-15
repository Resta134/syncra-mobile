import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/present_speaker_controller.dart'; 

class PresentSpeakerView extends GetView<SpeakerController> {
  const PresentSpeakerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Abu Slate khas Syncra
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B), // Navy Premium
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Sesi Pemateri',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.forum_outlined, color: Colors.white),
              onPressed: () => controller.goToQA(),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. CARD STATUS & TIMER
            _buildStatusCard(),
            const SizedBox(height: 20),

            // 2. LIVE TRANSCRIPT BOX
            const Text(
              "Preview Transkrip Berjalan (Dikirim ke Supabase)",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            _buildTranscriptBox(),
            const SizedBox(height: 20),

            // 3. CATATAN PEMATERI
            const Text(
              "Catatan Tambahan (Opsional)",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            _buildNotesBox(),
            const SizedBox(height: 25),

            // 4. TOMBOL MIC UTAMA
            _buildMicButton(),
          ],
        ),
      ),
    );
  }

  // Widget Card untuk Status Mic & Durasi Waktu
  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Obx(
                () => Icon(
                  Icons.circle,
                  size: 12,
                  color: controller.isMicOn.value ? Colors.red : Colors.grey,
                ),
              ),
              const SizedBox(width: 8),
              Obx(
                () => Text(
                  controller.isMicOn.value ? "LIVE STREAMING" : "MIC OFF",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: controller.isMicOn.value ? Colors.red : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          Obx(
            () => Text(
              controller.elapsedTime.value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Box Hitam Elegan untuk menampilkan teks STT secara real-time
  Widget _buildTranscriptBox() {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Obx(() {
          if (controller.transcriptList.isEmpty &&
              controller.liveText.value.isEmpty &&
              !controller.isMicOn.value) {
            return const Center(
              child: Text(
                "Aktifkan mikrofon untuk mulai berbicara",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            );
          }

          return Column(
            children: [
              // LIVE SPEECH PREVIEW
              if (controller.liveText.value.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "LIVE SPEECH",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        controller.liveText.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

              Expanded(
                child: controller.transcriptList.isEmpty
                    ? const Center(
                        child: Text(
                          "Mendengarkan suara Anda...",
                          style: TextStyle(
                            color: Colors.blue,
                            fontStyle: FontStyle.italic,
                            fontSize: 13,
                          ),
                        ),
                      )
                    : ListView.builder(
                        reverse: true,
                        itemCount: controller.transcriptList.length,
                        itemBuilder: (context, index) {
                          final item = controller.transcriptList[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.04),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ORIGINAL TEXT
                                Text(
                                  item['original_text'] ?? '',
                                  style: TextStyle(
                                    color: index == 0
                                        ? Colors.white
                                        : Colors.white70,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // TRANSLATED TEXT
                                Text(
                                  item['translated_text'] ?? '',
                                  style: const TextStyle(
                                    color: Colors.lightBlueAccent,
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // Widget TextField untuk catatan pembicara
  Widget _buildNotesBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller.notesController,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: "Tulis poin penting presentasi di sini...",
          hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }

  // Widget Tombol Mic Besar di bagian paling bawah
  Widget _buildMicButton() {
    return Obx(() {
      bool isOn = controller.isMicOn.value;
      return SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton.icon(
          onPressed: () => controller.toggleMic(),
          icon: Icon(isOn ? Icons.mic : Icons.mic_off, color: Colors.white),
          label: Text(
            isOn ? "Matikan Mikrofon" : "Mulai Berbicara",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: isOn
                ? Colors.red.shade600
                : const Color(0xFF0038FF), // Merah saat live, Biru saat off
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
        ),
      );
    });
  }
}

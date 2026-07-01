import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/live_controller.dart';

class LiveView extends GetView<LiveController> {
  const LiveView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],

      // ==========================================
      // APP BAR DINAMIS
      // ==========================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1E293B),
            size: 20,
          ),
          onPressed: () {
            Get.back(closeOverlays: true);
          },
        ),
        title: Column(
          children: [
            Obx(
              () => Text(
                controller.eventTitle.value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 2),
            Obx(
              () => Text(
                controller.speakerName.value,
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
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
                const Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.remove_red_eye_rounded,
                  color: Colors.grey[600],
                  size: 12,
                ),
                const SizedBox(width: 4),
                Obx(
                  () => Text(
                    controller.viewerCount.value,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // ==========================================
      // TOMBOL DISKUSI MENGAMBANG (Q&A)
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
          // KONTROL AUDIO TRANSLATION
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
                  child: Obx(
                    () => IconButton(
                      icon: Icon(
                        controller.isPlaying.value
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () => controller.togglePlay(),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Terjemahan Suara AI (ID)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Obx(
                        () => Text(
                          controller.isPlaying.value
                              ? 'Sedang memutar...'
                              : 'Audio dijeda',
                          style: TextStyle(
                            color: Colors.blue[400],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => controller.changeSpeed(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Obx(
                      () => Text(
                        '${controller.playbackSpeed.value}x',
                        style: const TextStyle(
                          color: Color(0xFF1E293B),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ==========================================
          // AREA LIVE TRANSCRIPT
          // ==========================================
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.g_translate_rounded,
                          color: Colors.blue[800],
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "TRANSKRIP TERJEMAHAN LANGSUNG",
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Menarik data teks dari tabel transcripts
                  Expanded(
                    child: Obx(() {
                      if (controller.transcripts.isEmpty) {
                        return Center(
                          child: Text(
                            "Menunggu pembicara...",
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.all(20),
                        physics: const BouncingScrollPhysics(),
                        reverse:
                            true, // Teks baru muncul dari bawah/atas sesuai aliran chat
                        itemCount: controller.transcripts.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 35, color: Colors.black12),
                        itemBuilder: (context, index) {
                          final data =
                              controller.transcripts[controller
                                      .transcripts
                                      .length -
                                  1 -
                                  index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Teks Indonesia (translated_text)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      "ID",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[700],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      data['translated_text'] ??
                                          'Menerjemahkan...',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Color(0xFF1E293B),
                                        fontWeight: FontWeight.w600,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Teks Inggris (original_text)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 38),
                                  Expanded(
                                    child: Text(
                                      data['original_text'] ?? '',
                                      style: const TextStyle(
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
                      );
                    }),
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
  // BOTTOM SHEET Q&A
  // ==========================================
  // ==========================================
  // BOTTOM SHEET Q&A (NATIVE FLUTTER - BEBAS BUG)
  // ==========================================
  void _showQnABottomSheet(BuildContext context) {
    // KITA GANTI Get.bottomSheet MENJADI showModalBottomSheet BAWAAN FLUTTER
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Memungkinkan Bottom Sheet membesar
      backgroundColor: Colors.transparent, // Background luar pop-up transparan
      builder: (BuildContext context) {
        return Container(
          height: Get.height * 0.75, // Mengambil 75% tinggi layar
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              // Handle Tarik Atas
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                height: 5,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // Tab Komunitas vs Pertanyaan Saya
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                  bottom: 10,
                ),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Obx(
                    () => Row(
                      children: [
                        _buildTabItem('Diskusi Komunitas', 0),
                        _buildTabItem('Pertanyaan Saya', 1),
                      ],
                    ),
                  ),
                ),
              ),

              // List Teks Q&A
              Expanded(
                child: Obx(() {
                  final currentList = controller.selectedTab.value == 0
                      ? controller.communityQuestions
                      : controller.myQuestions;

                  if (currentList.isEmpty) {
                    return Center(
                      child: Text(
                        controller.selectedTab.value == 0
                            ? "Belum ada diskusi."
                            : "Anda belum bertanya.",
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: currentList.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 24, color: Colors.black12),
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
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      data['name'] ?? 'User',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                    Text(
                                      data['time'] ?? 'Now',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  data['text'] ?? '',
                                  style: TextStyle(
                                    fontSize: 13,
                                    height: 1.4,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                if (controller.selectedTab.value == 1)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      data['status'] == 'approved'
                                          ? 'Telah Disetujui'
                                          : 'Menunggu Moderasi',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: data['status'] == 'approved'
                                            ? Colors.green
                                            : Colors.orange,
                                      ),
                                    ),
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

              // Area Input Pertanyaan Bawah
              Container(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 12,
                  bottom: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.questionController,
                        decoration: InputDecoration(
                          hintText: 'Tanyakan sesuatu...',
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[400],
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        onSubmitted: (_) => controller.sendQuestion(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.blueAccent,
                      child: IconButton(
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => controller.sendQuestion(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabItem(String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectedTab.value = index,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: controller.selectedTab.value == index
                ? Colors.white
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: controller.selectedTab.value == index
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: controller.selectedTab.value == index
                    ? Colors.blueAccent
                    : Colors.grey[500],
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

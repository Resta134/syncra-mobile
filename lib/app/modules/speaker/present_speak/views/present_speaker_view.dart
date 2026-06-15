import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/present_speaker_controller.dart';

class PresentSpeakerView extends GetView<SpeakerController> {
  const PresentSpeakerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Pusat Kendali", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(() => FloatingActionButton.extended(
        onPressed: () => controller.toggleMic(),
        backgroundColor: controller.isMicOn.value ? Colors.redAccent : Colors.blueAccent,
        icon: Icon(controller.isMicOn.value ? Icons.mic_off : Icons.mic),
        label: Text(controller.isMicOn.value ? "Matikan Mic" : "Mulai Bicara"),
      )),

      body: Column(
        children: [
          // 1. Status Waktu
          _buildStatusCard(),
          
          // 2. Tombol Q&A
          _buildQAButton(),

          // 3. Panel Scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Live Transkrip AI", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 10),
                  _buildLiveTranscriptPanel(),
                  const SizedBox(height: 20),
                  const Text("Catatan Pembicara", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 10),
                  _buildEditableNotes(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTimerItem("WAKTU", controller.elapsedTime, Colors.blueAccent),
          Container(width: 1, height: 40, color: Colors.grey[200]),
          _buildTimerItem("SISA", controller.remainingTime, Colors.redAccent),
        ],
      ),
    );
  }

  Widget _buildTimerItem(String label, RxString value, Color color) {
    return Column(children: [
      Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
      Obx(() => Text(value.value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color))),
    ]);
  }

  Widget _buildQAButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: ElevatedButton.icon(
        onPressed: () => controller.goToQA(),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size(double.infinity, 50)),
        icon: const Icon(Icons.question_answer),
        label: const Text("LIHAT PERTANYAAN AUDIENS"),
      ),
    );
  }

  Widget _buildEditableNotes() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.blue[900], borderRadius: BorderRadius.circular(15)),
      child: TextField(
        controller: controller.notesController,
        maxLines: 4,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(hintText: "Tulis poin penting di sini...", hintStyle: TextStyle(color: Colors.white54), border: InputBorder.none),
      ),
    );
  }

  Widget _buildLiveTranscriptPanel() {
    return Container(
      height: 150,
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade200)),
      child: const Center(child: Text("Transkrip akan muncul di sini...", style: TextStyle(color: Colors.grey))),
    );
  }
}
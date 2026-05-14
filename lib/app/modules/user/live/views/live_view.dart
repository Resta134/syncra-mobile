import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/live_controller.dart';

class LiveView extends GetView<LiveController> {
  const LiveView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Column(
          children: [
            Text(
              'AI Ethics & Future of Work',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            Text(
              'Dr.Mulyono',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // BAGIAN ATAS (Bisa di-scroll biar aman)
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, color: Colors.white, size: 13),
                      SizedBox(width: 6),
                      Text(
                        'LIVE',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.remove_red_eye_sharp,
                        color: Colors.white,
                        size: 13,
                      ),
                      SizedBox(width: 6),
                      Text(
                        '2390 Views',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade50,
                  child: IconButton(
                    icon: Icon(Icons.pause, color: Colors.blue),
                    onPressed: () {},
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Live Audio Translation',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Sedang memutar...',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue.shade900),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '1.0x',
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(left: 16, right: 16),
            padding: EdgeInsets.only(left: 16, right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              border: Border.all(color: Colors.grey, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                  ),
                  child: Text(
                    "Translation ",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
                    padding: EdgeInsets.only(bottom: 16, left: 16, right: 16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 2),
                        left: BorderSide(color: Colors.grey, width: 2),
                        right: BorderSide(color: Colors.grey, width: 2),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child:
                          ListView.builder(
                            shrinkWrap:true, // Wajib ada agar list menyesuaikan tinggi sisa layar
                            physics: const NeverScrollableScrollPhysics(), // Matikan scroll internal jika halaman utama sudah bisa discroll
                            itemCount: 50, // Mengulang desain di bawah sebanyak 5 baris
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  // --- 1. TEKS SUMBER (ENGLISH) - Sekunder ---
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Badge EN
                                        const SizedBox(width: 12),
                                        // Teks Inggris (Lebih kecil & warna lebih redup)
                                        const Expanded(
                                          child: Text(
                                            'This is a simulation of subtitles being translated in real time. The text will continue to scroll down as the speaker speaks.',
                                            style: TextStyle(
                                              fontSize: 15,
                                              height: 1.5,
                                              color: Colors
                                                  .black54, // Warna abu-abu biar ga nabrak fokus
                                              fontStyle: FontStyle
                                                  .italic, // Efek miring untuk teks asli
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // --- 2. TEKS HASIL TERJEMAHAN (INDONESIA) - Fokus Utama ---
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Badge ID
                                        const SizedBox(width: 12),
                                        // Teks Indonesia (Lebih besar, tebal, & kontras tinggi)
                                        const Expanded(
                                          child: Text(
                                            'Ini adalah simulasi teks subtitle terjemahan yang masuk secara real-time. Teks ini akan terus berjalan ke bawah mengikuti pembicara.',
                                            style: TextStyle(
                                              fontSize:
                                                  18, // Ukuran ideal untuk dibaca cepat
                                              height: 1.5,
                                              fontWeight: FontWeight
                                                  .w500, // Agak ditebalkan dikit
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(),
                                  // Spacing pemisah untuk baris berikutnya
                                  SizedBox(height: 20),
                                ],
                              );
                            },
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),

          // button
          Container(
            padding: EdgeInsets.only(top: 15),
            color: Colors.white,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Button Community
                  InkWell(
                    // logic
                    onTap: () => controller.selectedTab.value = 0,
                    child: Container(
                      width: 160,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border(
                          bottom: BorderSide(
                            color: controller.selectedTab.value == 0
                                ? Colors.blue
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Community Question',
                          style: TextStyle(
                            fontWeight: controller.selectedTab.value == 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: controller.selectedTab.value == 0
                                ? Colors.blue.shade900
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Button My Question
                  InkWell(
                    // logic
                    onTap: () => controller.selectedTab.value = 1,
                    child: Container(
                      width: 160,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border(
                          bottom: BorderSide(
                            color: controller.selectedTab.value == 1
                                ? Colors.blue
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'My Question',
                          style: TextStyle(
                            fontWeight: controller.selectedTab.value == 1
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: controller.selectedTab.value == 1
                                ? Colors.blue.shade900
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Obx(() {
                // Trik nentuin data mana yang dipake
                final currentList = controller.selectedTab.value == 0
                    ? controller.communityQuestions
                    : controller.myQuestions;

                return ListView.separated(
                  // NGGAK PERLU shrinkWrap & NeverScrollable lagi, karena udah di dalam Expanded
                  padding: EdgeInsets.all(16),
                  itemCount: currentList.length,
                  separatorBuilder: (context, index) =>
                      Divider(height: 24, color: Colors.black12),
                  itemBuilder: (context, index) {
                    final data = currentList[index];

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            data['initial'] ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    data['name'] ?? '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    data['time'] ?? '',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Text(
                                data['text'] ?? '',
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 1.5,
                                  color: Colors.black87,
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
          ),

          // BAGIAN BAWAH: KOLOM Q&A
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // PENTING: Biar gak makan tempat
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 8),
                    child: Text(
                      'Tanya Pembicara (Via Moderator)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Ketik pertanyaan...',
                            hintStyle: TextStyle(fontSize: 14),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.blue.shade900,
                        child: IconButton(
                          icon: Icon(Icons.send, color: Colors.white, size: 18),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

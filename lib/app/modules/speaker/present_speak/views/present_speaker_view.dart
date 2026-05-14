import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/present_speaker_controller.dart';

class PresentSpeakerView extends GetView<SpeakerController> {
  const PresentSpeakerView({super.key});

  @override
  Widget build(BuildContext context) {
    // Langsung di-return agar sesuai standar template Flutter
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        elevation: 0,
         automaticallyImplyLeading: false,//hapus arrow
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
        children: [
          // 1. AREA KONTEN (BISA DI-SCROLL)
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusCard(),
                  SizedBox(height: 24),

                  // --- Bagian Current Slide ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Current Slide',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Slide 4 of 24',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.indigo.shade400,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  _buildSlidePlaceholder(
                    height: 300,
                    showProgressBar: true,
                    progressValue: 0.3,
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: const [
                      Icon(Icons.notes, size: 16, color: Color(0xFF0038FF)),
                      SizedBox(width: 8),
                      Text(
                        'Speaker Notes',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0038FF),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),

                  SizedBox(
                    height:300, 
                    child: SingleChildScrollView(child: _buildSpeakerNotes()),
                  ),
                  SizedBox(height: 24),

                  Text(
                    'Up Next',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  _buildSlidePlaceholder(
                    height: 150,
                    showProgressBar: true,
                    progressValue: 0.3,
                  ),
                  SizedBox(
                    height: 24,
                  ), // Jarak ekstra di paling bawah sebelum area tombol
                ],
              ),
            ),
          ),

          // 2. AREA TOMBOL (TETAP DI BAWAH, TIDAK IKUT SCROLL)
          Container(
            padding: EdgeInsets.only(top: 16, bottom: 20, left: 16, right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              border: Border.all(color: Colors.grey.shade300, width: 3),
          
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 150,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_circle_left_outlined,
                        color: Colors.white,
                      ),
                      SizedBox(width: 5),
                      Text('Previous', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    controller.goToQA();
                  }, child:  Container(
                  width: 150,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Next', style: TextStyle(color: Colors.white)),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Colors.white,
                      ),
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
}

// Widget untuk Card Timer di paling atas
Widget _buildStatusCard() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Row(
      children: [
        // Kiri: Elapsed Time
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ELAPSED TIME',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '14:32',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0038FF),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.visibility,
                      size: 14,
                      color: Colors.indigo.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '1,248 Active',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.indigo.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Kanan: Remaining Time
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'REMAINING',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 4),
              Text(
                '45:28',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xFF0038FF)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.mic_none, size: 14, color: Color(0xFF0038FF)),
                    SizedBox(width: 4),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'Live',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF0038FF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Widget Placeholder untuk Gambar Slide (karena gambar nyusul)
Widget _buildSlidePlaceholder({
  required double height,
  required bool showProgressBar,
  double progressValue = 0,
}) {
  return Container(
    height: height,
    padding: EdgeInsets.all(10),
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      image: DecorationImage(
        image: AssetImage('images/background-card.jpg'),
        fit: BoxFit.cover,
      ),
    ),
    child: Text(''),
  );
}

// Widget untuk kotak Speaker Notes
Widget _buildSpeakerNotes() {
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
      border: Border(left: BorderSide(color: Colors.blue, width: 3), )
    ),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text(
          'Welcome everyone to the deep dive on implementation metrics.\n\n'
          'Make sure to pause here and emphasize the 34% efficiency gain in Q3. This is our strongest selling point today.\n\n'
          'If there are questions about the methodology, refer them to the appendix in the handouts. Keep the pace moving, we only have 45 minutes remaining.',
          style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.5),
        ),
        Text(
          'Welcome everyone to the deep dive on implementation metrics.\n\n'
          'Make sure to pause here and emphasize the 34% efficiency gain in Q3. This is our strongest selling point today.\n\n'
          'If there are questions about the methodology, refer them to the appendix in the handouts. Keep the pace moving, we only have 45 minutes remaining.',
          style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.5),
        ),
      ],
    ),
  );
}

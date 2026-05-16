import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/transcript_controller.dart';

class TranscriptView extends GetView<TranscriptController> {
  const TranscriptView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text(
          'Transcript',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20,),
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
                      "Original (English)",
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
              flex: 2,
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
                        child: Column(
                          children: [
                            Obx(
                              () => ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: controller.subtitleEng.length,

                                itemBuilder: (context, index) {
                                  final data = controller.subtitleEng[index];
                                  final role = data['role'] ?? 'speaker';

                                  Color bgColor;
                                  Color iconColor;
                                  Color titleColor;

                                  switch (role) {
                                    case 'speaker':
                                      bgColor = Colors.white;
                                      iconColor = Colors.blue.shade400;
                                      titleColor = Colors.blue.shade900;
                                      break;

                                    case 'moderator':
                                      bgColor = Colors.orange.shade50;
                                      iconColor = Colors.orange.shade400;
                                      titleColor = Colors.orange.shade900;
                                      break;

                                    default:
                                      bgColor = Colors.grey.shade200;
                                      iconColor = Colors.grey;
                                      titleColor = Colors.black87;
                                  }

                                  return Container(
                                    margin: EdgeInsets.only(bottom: 12),
                                    padding: EdgeInsets.all(14),

                                    decoration: BoxDecoration(
                                      color: bgColor,
                                      borderRadius: BorderRadius.circular(16),
                                    ),

                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.record_voice_over,
                                          size: 24,
                                          color: iconColor,
                                        ),

                                        SizedBox(width: 12),

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        data['speaker']!,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: titleColor,
                                                        ),
                                                      ),

                                                      SizedBox(width: 6),

                                                      Icon(
                                                        Icons.circle,
                                                        size: 5,
                                                        color: Colors
                                                            .grey
                                                            .shade500,
                                                      ),

                                                      SizedBox(width: 6),

                                                      Text(
                                                        data['time']!,
                                                        style: TextStyle(
                                                          color: Colors
                                                              .grey
                                                              .shade600,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      controller.EditTranskrip();
                                                    },
                                                    child: Icon(
                                                      Icons.edit,
                                                      size: 20,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Divider(),
                                              Text(
                                                data['text']!,
                                                style: TextStyle(
                                                  height: 1.5,
                                                  fontSize: 15,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            Container(
              margin: EdgeInsets.only(left: 16, right: 16),
              padding: EdgeInsets.only(left: 16, right: 16),
              decoration: BoxDecoration(
                color: Colors.grey[50]!,
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
                      "Indonesia",
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
              flex: 2,
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
                        child: Column(
                          children: [
                            Obx(
                              () => ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: controller.subtitleIndo.length,

                                itemBuilder: (context, index) {
                                  final data = controller.subtitleIndo[index];

                                  final role = data['role'] ?? 'speaker';

                                  Color bgColor;
                                  Color iconColor;
                                  Color titleColor;

                                  switch (role) {
                                    case 'speaker':
                                      bgColor = Colors.white;
                                      iconColor = Colors.blue.shade400;
                                      titleColor = Colors.blue.shade900;
                                      break;

                                    case 'moderator':
                                      bgColor = Colors.orange.shade50;
                                      iconColor = Colors.orange.shade400;
                                      titleColor = Colors.orange.shade900;
                                      break;

                                    default:
                                      bgColor = Colors.grey.shade200;
                                      iconColor = Colors.grey;
                                      titleColor = Colors.black87;
                                  }

                                  return Container(
                                    margin: EdgeInsets.only(bottom: 12),
                                    padding: EdgeInsets.all(14),

                                    decoration: BoxDecoration(
                                      color: bgColor,
                                      borderRadius: BorderRadius.circular(16),
                                    ),

                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.closed_caption_outlined,
                                          size: 24,
                                          color: iconColor,
                                        ),

                                        SizedBox(width: 12),

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    data['speaker']!,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: titleColor,
                                                    ),
                                                  ),

                                                  SizedBox(width: 6),

                                                  Icon(
                                                    Icons.circle,
                                                    size: 5,
                                                    color: Colors.grey.shade500,
                                                  ),

                                                  SizedBox(width: 6),

                                                  Text(
                                                    data['time']!,
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              SizedBox(height: 8),

                                              Text(
                                                data['text']!,
                                                style: TextStyle(
                                                  height: 1.5,
                                                  fontSize: 15,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(25),
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
                          Icons.picture_as_pdf_outlined,
                          color: Colors.red,
                        ),
                        label: Text(
                          'Convert to file(pdf)',
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Map<String, dynamic>> subtitleList = [
  {
    'icon': Icons.record_voice_over,
    'text': 'This is a simulation of subtitles being translated in real time.',
  },
  {
    'icon': Icons.record_voice_over,
    'text': 'This is a simulation of subtitles being translated in real time.',
  },
  {
    'icon': Icons.record_voice_over,
    'text': 'This is a simulation of subtitles being translated in real time.',
  },
  {
    'icon': Icons.record_voice_over,
    'text': 'This is a simulation of subtitles being translated in real time.',
  },
  {
    'icon': Icons.record_voice_over,
    'text': 'This is a simulation of subtitles being translated in real time.',
  },
  {
    'icon': Icons.record_voice_over,
    'text': 'This is a simulation of subtitles being translated in real time.',
  },
];

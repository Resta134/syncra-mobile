import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../controllers/event_detail_controller.dart';
class EventDetailView extends GetView<EventDetailController> {
  const EventDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Event Detail '),
            Icon(Icons.share, color: Colors.blue[700], size: 25),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage("images/background-card.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.eventDetails[0]['title']!,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: Colors.grey[600],
                        size: 16,
                      ),
                      SizedBox(width: 6),
                      Text(
                        controller.eventDetails[0]['author']!,
                        style: TextStyle(fontSize: 14, color: Colors.blue[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),

            // date dan location
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 200,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[400]!, width: 2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.blue[700],
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              controller.date_location[0]['date']!,
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 200,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue[50],
                      border: Border.all(color: Colors.grey[400]!, width: 2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.blue[700],
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Location",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              "San Francisco, CA",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
            // deskripsi
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About the Event",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    controller.eventDetails[0]['description']!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            // Spacer untuk mendorong QR code ke bawah

            Container(  
              margin:  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0,),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[400]!, width: 2),
              ),

              child: Column(
                children: [
                  Container(
                    padding:  EdgeInsets.symmetric(vertical: 12),
                    decoration:  BoxDecoration(
                      color: Colors.green, 
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),

                    // Status Ticket --- IGNORE ---
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        Icon(Icons.check_box_outlined, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          controller.user[0]['ticket']!,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // User info
                  Padding(
                    padding:  EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ---------- Profile and Name ----------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                controller.user[0]['avatar']!,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              ),
                            ),
                             SizedBox(width: 12),
                            Text(
                              controller.user[0]['name']!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),

                         SizedBox(height: 15),

                        // ---------- Baris Ticket ID ----------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:  [
                            Text(
                              "Ticket ID",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              controller.user[0]['ticket_id']!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),

                         SizedBox(height: 15),

                        // ---------- Baris Face Verification  ---------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Text(
                              "Face Verification",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            Row(
                              children:  [
                                Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF34A853),
                                  size: 18,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "COMPLETE",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF34A853),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                         SizedBox(height: 30),

                        // ------- QR Code --------
                        Center(
                          child: Column(
                            children: [
                               Icon(
                                Icons.qr_code_2,
                                size: 160,
                                color: Colors.black87,
                              ),
                               SizedBox(height: 12),
                               Text(
                                "Scan this QR code at the event entrance",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                  height: 1.4,
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
            ),

            Padding(
              padding:  EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 200,
                    height: 40,
                    child: ElevatedButton(onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.confirmation_num_outlined, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text('View my Tickets', style: TextStyle(color: Colors.white),),
                      ],
                    )),
                  ),
                  Container(
                    width: 200,
                    height: 40,
                    child: ElevatedButton(onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.live_tv, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text('Join Live Room', style: TextStyle(color: Colors.white),),
                      ],
                    )),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            // Spacer untuk memberikan jarak di bagian bawah
          ],
        ),
      ),
    );
  }
}

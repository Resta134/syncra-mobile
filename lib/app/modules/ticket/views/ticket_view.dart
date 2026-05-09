import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/ticket_controller.dart';

class TicketView extends GetView<TicketController> {
  const TicketView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TicketView'),
        // centerTitle: true
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // heading
          
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 400,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white, width: 5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue,
                          blurRadius: 1,
                          offset: Offset(0, 7),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'images/background-card.jpg',
                            //  fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Title trtyuioiuyt',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.blue[900],
                              ),
                            ),
                            Icon(Icons.qr_code_2, color: Colors.black),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Building Accessible',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 5),
                            Text('Today, Oct 2026'),
                            SizedBox(width: 5),
                            Icon(Icons.circle, size: 10),
                            SizedBox(width: 5),
                            Text('00.00 AM - 02.00 PM'),
                          ],
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            controller.goToEventDetail();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 40,
                            ),
                            elevation: 5,
                            backgroundColor: Colors.blue[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.confirmation_num_outlined,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'View Ticket',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Gambar & Badge
                ],
              ),
            ),
           
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 400,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white, width: 5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue,
                          blurRadius: 1,
                          offset: Offset(0, 7),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'images/background-card.jpg',
                            //  fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Title trtyuioiuyt',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.blue[900],
                              ),
                            ),
                            Icon(Icons.qr_code_2, color: Colors.black),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Global Tect Summit',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 5),
                            Text('Today, Oct 2026'),
                            SizedBox(width: 5),
                            Icon(Icons.circle, size: 10),
                            SizedBox(width: 5),
                            Text('00.00 AM - 02.00 PM'),
                          ],
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            controller.goToEventDetail();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 40,
                            ),
                            elevation: 5,
                            backgroundColor: Colors.blue[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.confirmation_num_outlined,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'View Ticket',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Gambar & Badge
                ],
              ),
            ),
           
            ],
        ),
      ),
    );
  }
}

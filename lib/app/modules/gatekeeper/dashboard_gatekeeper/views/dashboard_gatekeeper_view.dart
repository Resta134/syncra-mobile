import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tranlator_v1/app/components/custom_bottom_nav.dart';

import '../controllers/dashboard_gatekeeper_controller.dart';

class DashboardGatekeeperView extends GetView<DashboardGatekeeperController> {
  const DashboardGatekeeperView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],

        title: Column(
          children: [
            Text(
              'Dashboard Gatekeeper',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              'Name user',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildCapacityCard(),
              SizedBox(height: 16),

              // DUA TOMBOL UTAMA (FACE SCAN & QR CODE)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        controller.vermuk();
                      },
                      icon: Icon(
                        Icons.fingerprint_outlined,
                        color: Colors.white,
                        size: 30,
                      ),

                      label: Text(
                        'Face Scan\n(Utama)',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        controller.qr();
                      },
                      icon: Icon(
                        Icons.qr_code_scanner,
                        color: Colors.white,
                        size: 30,
                      ),
                      label: Text(
                        'QR Code\n(Manual)',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // HEADER LIST
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Latest Attendance',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  InkWell(
                    onTap: () {},
                    child: InkWell(
                      onTap: () {
                        controller.goToValidation();
                      },
                      child: Text(
                        'View All',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // LIST 3 PESERTA TERBARU (Dibikin manual biar simpel)
              _buildListItem('Sarah Jenkins', 'Group A', 'Just now', 'Scanned'),
              SizedBox(height: 8),
              _buildListItem(
                'Michael Chen',
                'General Admission • Group C',
                '2 mins ago',
                'Qr Code',
              ),
              SizedBox(height: 8),
              _buildListItem(
                'Elena Rodriguez',
                'Speaker • Access All Areas',
                '5 mins ago',
                'Scanned',
              ),

              SizedBox(height: 24),

              // REPORT ISSUE CARD
              _buildReportCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 0,
        role: 'gatekeeper', // <-- Kasih tahu ini punya moderator
      ),
    );
  }

  // WIDGET CAPACITY
  Widget _buildCapacityCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('MAIN HALL CAPACITY', style: TextStyle(color: Colors.grey)),
              Row(
                children: [
                  Icon(Icons.circle, color: Colors.red, size: 12),
                  SizedBox(width: 4),
                  Text(
                    'Live',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(
                  value: 178 / 200,
                  strokeWidth: 12,
                  backgroundColor: Colors.grey.shade200,
                  color: Colors.blue[700],
                ),
              ),
              Column(
                children: [
                  Text(
                    '178',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Text('/ 200', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            'Capacity is nearing limits. Prepare for\nsecondary overflow area.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // WIDGET LIST ITEM
  Widget _buildListItem(
    String name,
    String details,
    String time,
    String status,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade50,
            child: Icon(Icons.person, color: Colors.blue[700]),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  details,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(time, style: TextStyle(fontSize: 12, color: Colors.grey)),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // WIDGET REPORT
  Widget _buildReportCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Report Issue to Admin',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            'Reason for Failure',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50.withOpacity(0.5),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: Text('Select a reason...'),
                items: [], // Kosongkan dulu biar simpel
                onChanged: (value) {},
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Additional Notes (Optional)',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter any relevant details from the attendee...',
              filled: true,
              fillColor: Colors.blue.shade50.withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.send, color: Colors.white),
              label: Text(
                'Submit Report',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

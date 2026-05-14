import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../controllers/payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
const PaymentView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: SingleChildScrollView(
        // Menggunakan padding global agar tidak perlu repot set padding di tiap widget
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- 1. CARD TOTAL PEMBAYARAN ---
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                // Menggunakan gradient agar terkesan premium (opsional, bisa diganti warna solid)
                gradient: LinearGradient(
                  colors: [Colors.blue.shade800, Colors.blue.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Payment', // Diubah dari 'Count Payment' agar gramatikalnya pas
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    // Misal: "Rp 150.000"
                    controller.countPayment['count'] ?? 'Rp 0',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // --- 2. HEADER METODE PEMBAYARAN ---
            Row(
              children: [
                Icon(
                  MdiIcons.walletOutline, // Ikon dompet jauh lebih pas
                  color: Colors.blue.shade700,
                  size: 24,
                ),
                SizedBox(width: 10),
                Text(
                  'Select Payment Method',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 12),
            Divider(),
            SizedBox(height: 12),

            // --- 3. LIST METODE PEMBAYARAN ---

            // Opsi A: QRIS
            _buildPaymentOption(
              icon: Icons.qr_code_2_rounded,
              title: 'QRIS',
              subtitle: 'Scan instantly with any banking app',
              iconColor: Colors.orange.shade700,
              bgColor: Colors.orange.shade50,
            ),
            SizedBox(height: 12),

            // Opsi B: Transfer Bank (Virtual Account)
            _buildPaymentOption(
              icon: MdiIcons.bankOutline,
              title: 'Bank Transfer (VA)',
              subtitle: 'BCA, Mandiri, BRI, BNI',
              iconColor: Colors.blue.shade700,
              bgColor: Colors.blue.shade50,
            ),
            SizedBox(height: 12),

            // Opsi C: E-Wallet
            _buildPaymentOption(
              icon: MdiIcons.cellphoneNfc,
              title: 'E-Wallet',
              subtitle: 'GoPay, OVO, DANA, ShopeePay',
              iconColor: Colors.green.shade700,
              bgColor: Colors.green.shade50,
            ),
          ],
        ),
      ),
        bottomSheet: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            margin: EdgeInsets.only(bottom: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.all(15)
              ),
              onPressed: () {
                controller.processSuccessPayment();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.confirmation_num_outlined, color: Colors.white,size: 20,),
                   SizedBox(width: 5,),
                  Text('Buy Now',style: TextStyle(color: Colors.white, fontSize: 18),),
                ],
              ),
            ),
          ),
        ),
      ),
   
    );
  }

  // Helper untuk membuat tombol opsi pembayaran yang seragam
  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required Color bgColor,
  }) {
    return InkWell(
      onTap: () {
        
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          color: Colors.white, // Latar belakang utama item
        ),
        child: Row(
          children: [
            // Ikon dengan background warna lembut
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            SizedBox(width: 16),
            // Teks Judul & Subjudul
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            // Indikator panah ke kanan
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

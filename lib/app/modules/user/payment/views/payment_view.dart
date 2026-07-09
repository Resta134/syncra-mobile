import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../controllers/payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Background Neumorphism
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Pembayaran',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1E293B),
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- 1. CARD TOTAL PEMBAYARAN ---
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Colors.blue.shade800, Colors.blue.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Pembayaran',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller
                        .eventPrice, // Memanggil harga dinamis dari controller
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      controller.eventData['title'] ?? 'Event',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),

            // --- 2. HEADER METODE PEMBAYARAN ---
            Row(
              children: [
                Icon(
                  MdiIcons.walletOutline,
                  color: Colors.blue.shade700,
                  size: 24,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Pilih Metode Pembayaran',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // --- 3. LIST METODE PEMBAYARAN ---
            _buildPaymentOption(
              methodId: 'QRIS',
              icon: Icons.qr_code_2_rounded,
              title: 'QRIS',
              subtitle: 'Scan cepat dari m-banking atau e-wallet',
              iconColor: Colors.orange.shade700,
              bgColor: Colors.orange.shade50,
            ),
            const SizedBox(height: 12),
            _buildPaymentOption(
              methodId: 'VA',
              icon: MdiIcons.bankOutline,
              title: 'Transfer Bank (VA)',
              subtitle: 'BCA, Mandiri, BRI, BNI',
              iconColor: Colors.blue.shade700,
              bgColor: Colors.blue.shade50,
            ),
            const SizedBox(height: 12),
            _buildPaymentOption(
              methodId: 'EWALLET',
              icon: MdiIcons.cellphoneNfc,
              title: 'E-Wallet',
              subtitle: 'GoPay, OVO, DANA, ShopeePay',
              iconColor: Colors.green.shade700,
              bgColor: Colors.green.shade50,
            ),
          ],
        ),
      ),

      // --- 4. TOMBOL BAYAR BAWAH ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(
          left: 24,
          right: 24,
          top: 15,
          bottom: 35,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 55,
            child: Obx(() {
              // Cek status apakah tombol boleh aktif secara visual
              final isFree = controller.eventPrice == 'Gratis';
              final isMethodSelected =
                  controller.selectedMethod.value.isNotEmpty;
              final canProceed = isFree || isMethodSelected;

              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // Jika belum pilih metode, tombol otomatis menjadi abu-abu
                  backgroundColor: canProceed
                      ? Colors.blueAccent
                      : Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                // Fungsi di controller tetap dipanggil agar memunculkan Snackbar "Silakan pilih metode"
                onPressed: () => controller.processSuccessPayment(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      // Ikon menyesuaikan warna tombol
                      color: canProceed ? Colors.white : Colors.grey.shade500,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Bayar Sekarang',
                      style: TextStyle(
                        // Teks menyesuaikan warna tombol
                        color: canProceed ? Colors.white : Colors.grey.shade500,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // Helper untuk membuat opsi pembayaran yang bisa dipilih (Interaktif)
  Widget _buildPaymentOption({
    required String methodId,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Obx(() {
      final isSelected = controller.selectedMethod.value == methodId;

      return InkWell(
        onTap: () => controller.selectMethod(methodId),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? Colors.blueAccent : Colors.grey.shade200,
              width: isSelected ? 2 : 1,
            ),
            color: isSelected
                ? Colors.blue.shade50.withOpacity(0.5)
                : Colors.white,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              // Radio Button Visual
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? Colors.blueAccent
                        : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blueAccent,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      );
    });
  }
}

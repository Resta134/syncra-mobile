import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih bersih
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 35.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ==========================================
                // 1. AREA LOGO SYNCRA
                // ==========================================
                Image.asset(
                  'assets/images/logo_syncro.png', // Pastikan gambar logo kamu ditaruh di folder assets
                  height: 90,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.api_rounded,
                      size: 50,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // ==========================================
                // 2. TEKS SAMBUTAN (Bahasa Indonesia)
                // ==========================================
                Text(
                  'login_welcome_title'.tr,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'login_welcome_subtitle'.tr,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 40),

                // ==========================================
                // 3. INPUT EMAIL (Desain Kapsul Melayang)
                // ==========================================
                _buildSoftShadowTextField(
                  controller: controller.emailC,
                  hintText: 'login_email_hint'.tr,
                  icon: Icons.person_outline,
                  inputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                // ==========================================
                // 4. INPUT PASSWORD
                // ==========================================
                _buildSoftShadowTextField(
                  controller: controller.passC,
                  hintText: 'login_password_hint'.tr,
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Get.toNamed('/forgot-password'),
                    child: Text(
                      'login_forgot_password'.tr,
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // ==========================================
                // 6. TOMBOL MASUK UTAMA
                // ==========================================
                Obx(
                  () => SizedBox(
                    width: 180, // Ukuran tombol elegan
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.loginUser(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                        shadowColor: Colors.blueAccent.withOpacity(0.5),
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'login_btn'.tr,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 35),

                // ==========================================
                // 7. GARIS PEMISAH
                // ==========================================
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.grey[300], thickness: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'login_or_with'.tr,
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.grey[300], thickness: 1),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // ==========================================
                // 8. TOMBOL LOGIN GOOGLE (Google Sign-In)
                // ==========================================
                InkWell(
                  onTap: () => controller.signInWithGoogle(),
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueGrey.withOpacity(0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/googleSymbol.png', height: 24),
                        const SizedBox(width: 12),
                        Text(
                          'login_google_btn'.tr,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // ==========================================
                // 9. TEKS BUAT AKUN BARU
                // ==========================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'login_dont_have_account'.tr,
                      style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    ),
                    GestureDetector(
                      onTap: () =>
                          controller.goToSignUp(), // Pindah ke halaman Register
                      child: Text(
                        'login_register_here'.tr,
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // WIDGET BANTUAN UNTUK MEMBUAT FORM MELAYANG (SOFT SHADOW)
  // ==========================================
  Widget _buildSoftShadowTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: inputType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 15, right: 10),
            child: Icon(icon, color: Colors.blue[300], size: 22),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}

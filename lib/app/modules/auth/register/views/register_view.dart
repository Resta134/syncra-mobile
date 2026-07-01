import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

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
                  'assets/images/logo_syncro.png', 
                  height: 80, 
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.api_rounded,
                      size: 40,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // ==========================================
                // 2. TEKS JUDUL
                // ==========================================
                const Text(
                  "Buat Akun Baru",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Daftarkan diri Anda untuk bergabung ke Syncro",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 35),

                // ==========================================
                // 3. INPUT NAMA LENGKAP
                // ==========================================
                _buildSoftShadowTextField(
                  controller: controller.nameC,
                  hintText: "Nama Lengkap",
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 20),

                // ==========================================
                // 4. INPUT EMAIL
                // ==========================================
                _buildSoftShadowTextField(
                  controller: controller.emailC,
                  hintText: "Email",
                  icon: Icons.email_outlined,
                  inputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                // ==========================================
                // 5. INPUT PASSWORD
                // ==========================================
                _buildSoftShadowTextField(
                  controller: controller.passC,
                  hintText: "Password",
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 40),

                // ==========================================
                // 6. TOMBOL BUAT AKUN (MANUAL)
                // ==========================================
                Obx(
                  () => SizedBox(
                    width: 180, 
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.registerAccount(),
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
                          : const Text(
                              "Daftar",
                              style: TextStyle(
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
                        "Atau daftar dengan",
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
                // 8. TOMBOL DAFTAR GOOGLE
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
                          "Daftar dengan Google",
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
                // 9. TEKS KEMBALI LOGIN
                // ==========================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sudah punya akun? ",
                      style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(), 
                      child: const Text(
                        "Masuk di sini",
                        style: TextStyle(
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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.blueAccent, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'fp_appbar_title'.tr,
          style: const TextStyle(color: Color(0xFF2D3748), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 35.0),
            child: Obx(() => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon Header
                Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    controller.isCodeSent.value ? Icons.mark_email_read_rounded : Icons.lock_reset_rounded,
                    size: 50,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 30),

                // Title & Instructions
                Text(
                  controller.isCodeSent.value ? 'fp_header_enter_code'.tr : 'fp_header_reset_pass'.tr,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.isCodeSent.value
                      ? 'fp_desc_enter_code'.tr
                      : 'fp_desc_reset_pass'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
                ),
                const SizedBox(height: 35),

                // Form Fields
                if (!controller.isCodeSent.value) ...[
                  // Phase 1: Input Email
                  _buildSoftShadowTextField(
                    controller: controller.emailC,
                    hintText: 'fp_email_hint'.tr,
                    icon: Icons.email_outlined,
                    inputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 30),
                  
                  // Submit Button Phase 1
                  SizedBox(
                    width: 220,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value ? null : () => controller.sendResetEmail(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Text(
                              'fp_send_code_btn'.tr,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                    ),
                  ),
                ] else ...[
                  // Phase 2: Input OTP & New Password
                  _buildSoftShadowTextField(
                    controller: controller.emailC,
                    hintText: 'fp_email_fixed_hint'.tr,
                    icon: Icons.email_outlined,
                    inputType: TextInputType.emailAddress,
                    enabled: false,
                  ),
                  const SizedBox(height: 16),
                  _buildSoftShadowTextField(
                    controller: controller.tokenC,
                    hintText: 'fp_otp_hint'.tr,
                    icon: Icons.vpn_key_outlined,
                    inputType: TextInputType.text,
                  ),
                  const SizedBox(height: 16),
                  _buildSoftShadowTextField(
                    controller: controller.newPasswordC,
                    hintText: 'fp_new_password_hint'.tr,
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),
                  const SizedBox(height: 16),
                  _buildSoftShadowTextField(
                    controller: controller.confirmNewPasswordC,
                    hintText: 'fp_confirm_new_password_hint'.tr,
                    icon: Icons.lock_clock_outlined,
                    isPassword: true,
                  ),
                  const SizedBox(height: 30),

                  // Submit Button Phase 2
                  SizedBox(
                    width: 220,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value ? null : () => controller.resetPassword(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Text(
                              'fp_update_password_btn'.tr,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Tombol Kirim Ulang Email
                  TextButton(
                    onPressed: controller.isLoading.value ? null : () => controller.isCodeSent.value = false,
                    child: Text(
                      'fp_resend_email_btn'.tr,
                      style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
              ],
            )),
          ),
        ),
      ),
    );
  }

  Widget _buildSoftShadowTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    TextInputType inputType = TextInputType.text,
    bool enabled = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: enabled ? Colors.white : Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          if (enabled)
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
        enabled: enabled,
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

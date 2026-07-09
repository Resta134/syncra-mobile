import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tranlator_v1/app/components/custom_bottom_nav.dart';
import '../controllers/profil_controller.dart';

class ProfilView extends GetView<ProfilController> {
  const ProfilView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final currentRole = args?['role'] ?? 'user';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[50],
        elevation: 0,
        title: Text(
          'profile'.tr, // Multi-bahasa
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // ==========================================
                  // 1. AREA FOTO PROFIL (Dinamic dari Database)
                  // ==========================================
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Obx(() {
                              // Cek apakah user punya URL avatar di database
                              final avatarUrl = controller.userprofil.isNotEmpty
                                  ? controller.userprofil[0]['avatar_url']
                                  : null;

                              return Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blueGrey.withOpacity(0.15),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                  image: DecorationImage(
                                    // Logika: Jika ada URL dari DB pakai NetworkImage, jika null pakai Asset default
                                    image:
                                        (avatarUrl != null &&
                                            avatarUrl.isNotEmpty)
                                        ? NetworkImage(avatarUrl)
                                              as ImageProvider
                                        : const AssetImage(
                                            "assets/images/profil.png",
                                          ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            }),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () => controller.ubahfoto(),
                                child: Container(
                                  height: 38,
                                  width: 38,
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blueAccent.withOpacity(
                                          0.3,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Obx(
                          () => Text(
                            controller.userprofil.isNotEmpty
                                ? controller.userprofil[0]['name'] ?? 'No Name'
                                : 'Loading...',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Obx(
                          () => Text(
                            controller.userprofil.isNotEmpty
                                ? controller.userprofil[0]['email'] ??
                                      'No Email'
                                : '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),

                  // ==========================================
                  // 2. KARTU PERSONAL INFORMATION (Melayang Lembut)
                  // ==========================================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Personal Information',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueGrey.withOpacity(0.06),
                                blurRadius: 15,
                                spreadRadius: 2,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          // BUNGKUS COLUMN INI DENGAN SATU OBX SAJA
                          child: Obx(() => Column(
                            children: [
                              _buildInfoTile(
                                icon: Icons.person_outline,
                                title: "Nama Lengkap",
                                valueText: controller.userprofil.isNotEmpty ? controller.userprofil[0]['name'] ?? '-' : 'Loading...',
                              ),
                              Divider(height: 1, color: Colors.grey[100], indent: 20, endIndent: 20),
                              _buildInfoTile(
                                icon: Icons.email_outlined,
                                title: "Email",
                                valueText: controller.userprofil.isNotEmpty ? controller.userprofil[0]['email'] ?? '-' : 'Loading...',
                              ),
                              Divider(height: 1, color: Colors.grey[100], indent: 20, endIndent: 20),
                              _buildInfoTile(
                                icon: Icons.phone_outlined,
                                title: "No Telepon",
                                valueText: controller.userprofil.isNotEmpty ? controller.userprofil[0]['phone'] ?? '-' : '-',
                              ),
                            ],
                          )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // TOMBOL EDIT PROFILE
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[50],
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: () => controller.ubahProfil(),
                        icon: const Icon(
                          Icons.edit_note_rounded,
                          color: Colors.blueAccent,
                        ),
                        label: Text(
                          'edit_profile'.tr,
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),

                  // ==========================================
                  // 3. KARTU SECURITY & SETTING
                  // ==========================================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'security_setting'.tr,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueGrey.withOpacity(0.06),
                                blurRadius: 15,
                                spreadRadius: 2,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildActionTile(
                                icon: Icons.lock_outline_rounded,
                                title: 'change_password'.tr,
                                subtitle: "******",
                                onTap: () => controller.ubahPassword(),
                              ),
                              Divider(
                                height: 1,
                                color: Colors.grey[100],
                                indent: 20,
                                endIndent: 20,
                              ),

                              // --- BAGIAN FACE VERIFICATION YANG SUDAH DINAMIS ---
                              Obx(() {
                                final isVerified =
                                    controller.isFaceVerified.value;
                                return _buildActionTile(
                                  icon: MdiIcons.faceRecognition,
                                  title: "Face Verification",
                                  subtitle: isVerified
                                      ? "Verified (Ready for Event)"
                                      : "Verification required",
                                  subtitleColor: isVerified
                                      ? Colors.green[600]
                                      : Colors.red[400],
                                  onTap: () =>
                                      controller.handleFaceVerification(),
                                );
                              }),

                              Divider(
                                height: 1,
                                color: Colors.grey[100],
                                indent: 20,
                                endIndent: 20,
                              ),

                              // TOMBOL GANTI BAHASA
                              Obx(
                                () => _buildActionTile(
                                  icon: Icons.language_rounded,
                                  title: 'language'.tr,
                                  // Gunakan controller.currentLanguage.value di sini!
                                  subtitle:
                                      controller.currentLanguage.value == 'en'
                                      ? "English"
                                      : "Indonesia",
                                  onTap: () => controller.showLanguagePopup(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // TOMBOL SIGN OUT
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red[50],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: () => controller.deleteProfile(),
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: Colors.redAccent,
                        ),
                        label: Text(
                          'logout'.tr,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2,
        role: currentRole,
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String valueText,
  }) {
    // (Isi fungsi ini biarkan sama persis seperti kodingan aslimu)
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.blueAccent, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  valueText,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? subtitleColor,
    required VoidCallback onTap,
  }) {
    // (Isi fungsi ini biarkan sama persis seperti kodingan aslimu)
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.blueAccent, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Color(0xFF1E293B),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: subtitleColor ?? Colors.grey.shade500,
          fontSize: 12,
          fontWeight: subtitleColor != null
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
        color: Colors.grey.shade400,
      ),
    );
  }
}

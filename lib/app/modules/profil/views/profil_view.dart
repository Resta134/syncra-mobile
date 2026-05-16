import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tranlator_v1/app/components/custom_bottom_nav.dart';
import '../controllers/profil_controller.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProfilView extends GetView<ProfilController> {
  const ProfilView({super.key});
  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final currentRole = args?['role'] ?? 'user';
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Profil", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // =======================================================
          // BAGIAN ATAS: BISA DI-SCROLL (Expanded)
          // =======================================================
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      // ====== BACKGROUND MELENGKONG
                      Container(
                        width: double.infinity,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),

                      // ====== PROFIL
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                                image: DecorationImage(
                                  image: AssetImage("images/profil.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Obx(
                              () => Text(
                                controller.userprofil[0]['name'] ?? '',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Obx(
                              () => Text(
                                controller.userprofil[0]['email'] ?? '',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ====== PEN
                      Positioned(
                        top: 90,
                        right: 180,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue[900],
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              controller.ubahfoto();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  // ------------- DATA USER
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Icon(
                                    Icons.person,
                                    color: Colors.blue,
                                  ),
                                  title: Text("Name"),
                                  subtitle: Obx(
                                    () => Text(
                                      controller.userprofil[0]['name'] ?? '',
                                    ),
                                  ),
                                ),
                                Divider(),
                                ListTile(
                                  leading: Icon(
                                    Icons.email,
                                    color: Colors.blue,
                                  ),
                                  title: Text("Email"),
                                  subtitle: Obx(
                                    () => Text(
                                      controller.userprofil[0]['email'] ?? '',
                                    ),
                                  ),
                                ),
                                Divider(),
                                ListTile(
                                  leading: Icon(
                                    Icons.phone,
                                    color: Colors.blue,
                                  ),
                                  title: Text("Phone"),
                                  subtitle: Obx(
                                    () => Text(
                                      controller.userprofil[0]['phone'] ?? '',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 45,
                    width: 460,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => controller.ubahProfil(),
                      icon: Icon(Icons.edit, color: Colors.white),
                      label: Text(
                        "Edit Profil",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),
                  // -------------- SETTING & BIOMETRIC
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Security & Setting',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () => controller.ubahPassword(),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.lock,
                                      color: Colors.blue,
                                    ),
                                    title: Text("Change Password"),
                                    subtitle: Text('******'),
                                  ),
                                ),
                                Divider(),
                                InkWell(
                                  onTap: () {},
                                  child: ListTile(
                                    leading: Icon(
                                      MdiIcons.faceRecognition,
                                      color: Colors.blue,
                                    ),
                                    title: Text("Face Verification"),
                                    subtitle: Text('Verification required'),
                                  ),
                                ),
                                Divider(),
                                InkWell(
                                  onTap: () {},
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.language_sharp,
                                      color: Colors.blue,
                                    ),
                                    title: Text("Change Language"),
                                    subtitle: Text('English'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 45,
                    width: 460,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.red),
                        ),
                      ),
                      onPressed: () => controller.deleteProfile(),
                      icon: Icon(Icons.output_sharp, color: Colors.red),
                      label: Text(
                        "Sign Out",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),

      // =================================================================
      // BOTTOM NAVIGATION BAR (UI/UX Profesional)
      // =================================================================
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2,
        role: currentRole, // <-- Mengikuti role asli user yang sedang aktif
      ),
    );
  }

  // Helper untuk membuat struktur tombol Bottom Navigation yang konsisten
  Widget _buildNavTab({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ), // Memperluas area klik jempol
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Pastikan tidak memakan tinggi berlebih
          children: [
            Icon(
              icon,
              size: 24,
              // Kontras warna: Biru pekat untuk aktif, abu-abu redup untuk tidak aktif
              color: isActive ? Colors.blue.shade700 : Colors.grey.shade400,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? Colors.blue.shade700 : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

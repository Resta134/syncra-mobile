import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profil_controller.dart';

class ProfilView extends GetView<ProfilController> {
  const ProfilView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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

                  // ---------- BUTTON TICKET & HISTORY
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => controller.goToTicket(),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 60,
                          ),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.blue[200],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.confirmation_num_outlined,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'My Tickets',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () => controller.goToHistory(),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 60,
                          ),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.blue[200],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.history_outlined,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Event History',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

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
                                      Icons.fingerprint,
                                      color: Colors.blue,
                                    ),
                                    title: Text("Biometric"),
                                    subtitle: Text('Belum Terverifikasi'),
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
                    height: 20,
                  ), // Jarak ekstra biar pas di-scroll mentok bawah ga nabrak
                ],
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.only(top: 20, bottom: 24, left: 20, right: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -5), // Bayangan ke arah atas
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Biar ngambil tinggi secukupnya aja
                children: [
                  // BUTTON UBAH ==================================================
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
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

                  SizedBox(height: 15),

                  // BUTTON HAPUS / SIGN OUT ======================================
                  SizedBox(
                    height: 45,
                    width: double.infinity,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

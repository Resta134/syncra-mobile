import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilController extends GetxController {
  //TODO: Implement ProfilController

  void updateProfile(String newName, String newEmail, String newPhone) {
    // name.value = newName;
    // email.value = newEmail;
    // phone.value = newPhone;

    Get.snackbar(
      "Berhasil",
      "Profil berhasil diperbarui",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void deleteProfile() {
  Get.defaultDialog(
    title: "Konfirmasi",
    middleText: "Yakin mau hapus profil?",
    textConfirm: "Ya",
    textCancel: "Tidak",
    confirmTextColor: Colors.white, // Tambahan biar teks "Ya" kelihatan jelas
    buttonColor: Colors.red, // Opsional: Karena ini aksi hapus, warna merah lebih intuitif
    onConfirm: () {
      // 1. Tutup dialognya terlebih dahulu
      Get.back(); 

      // 2. Munculkan pesan sukses
      Get.snackbar(
        "Berhasil",
        "Akun berhasil dihapus",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey.withOpacity(0.1), // Opsional: Biar makin cakep
        colorText: Colors.black,
      );

      // 3. Beri sedikit jeda agar user bisa baca snackbar, lalu pindah ke Login
      Future.delayed(const Duration(milliseconds: 800), () {
        goToLogin(); // Sudah ditambah titik koma
      });
    },
  );
}

  void ubahProfil() {
    Get.defaultDialog(
      title: "Personal Information",
      buttonColor: Colors.blue[900],
      content: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2)
      ), 
      padding: EdgeInsets.symmetric(horizontal: 20,),
       
        child: Column(
          children: [
            TextField(
              onChanged: (value) => userprofil[0]['name'] = value,
              
              decoration: InputDecoration(labelText: "Name", hint: Text(userprofil[0]['name']!)),
            ),
            TextField(
              onChanged: (value) => userprofil[0]['email'] = value,
              decoration: InputDecoration(labelText: "Email", hint: Text(userprofil[0]['email']!)),
            ),
            TextField(
              onChanged: (value) => userprofil[0]['phone'] = value,
              decoration: InputDecoration(labelText: "Phone", hint: Text(userprofil[0]['phone']!)),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
      textConfirm: "Save",
      textCancel: "Cancel",

      onConfirm: () {
        Get.back();
        Get.snackbar("Successful", "Profile successfully updated", 
        margin: EdgeInsets.only(top: 50) ,padding: EdgeInsets.all(30));
        
      },
    );
  }

  void ubahfoto() {
    //get botton
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 12, bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Wrap(
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Ambil Foto'),
              onTap: () {
                Get.back();
                Get.snackbar(
                  "Maaf nyakk",
                  "Fitur belum tersedia nihhh",
                  snackPosition: SnackPosition.BOTTOM,
                );
                print("Ambil Foto");
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Galeri'),
              onTap: () {
                Get.back();
                Get.snackbar(
                  "Maaf nyakkk",
                  "Fitur belum tersedia nihhh",
                  snackPosition: SnackPosition.BOTTOM,
                );
                print("Pilih dari Galeri");
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void ubahPassword() {
    Get.defaultDialog(
      title: "Ubah Password",
      buttonColor: Colors.blue[900],
      content: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2)
      ), 
      padding: EdgeInsets.symmetric(horizontal: 20,),
       
        child: Column(
          children: [
            TextField(
              onChanged: (value) => userprofil[0]['password'] = value,
              decoration: InputDecoration(labelText: "Password Lama", hint: Text(userprofil[0]['password']!)),
            ),
            TextField(
              onChanged: (value) => userprofil[0]['password'] = value,
              decoration: InputDecoration(labelText: "Password Baru", ),
            ),
            TextField(
              onChanged: (value) => userprofil[0]['password'] = value,
              decoration: InputDecoration(labelText: "Konfirmasi Password" ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
      textConfirm: "Save",
      textCancel: "Cancel",

      onConfirm: () {
        Get.back();
        Get.snackbar("Berhasil", "Password berhasil diubah", 
        margin: EdgeInsets.only(top: 50) ,padding: EdgeInsets.all(30));
        
      },
    );
  }

  final userprofil =[
    {
      'name': 'Rhiki Sulistiyo',
      'email': 'rhikisulistiyo@example.com',
      'phone': '0895339162828',
      'password':'Admin123'
    }
  ].obs;

  final transkrip = [
    {
      'title': 'AI Ethics & The Future of Work: A Global Perspective',
      'author': 'Dr. Rhiki',
      'Date': 'Oct 19 2025',
      'Time': '14.00 - 16.00'
    },
    {
      'title': 'Machine Learning Implementation in Healthcare',
      'author': 'Prof. Alan',
       'Date': 'Oct 01 2025',
       'Time': '11.00 - 13.00'
    },
    {
      
      'title': 'Building Accessible User Interfaces in 2026',
      'author': 'Sarah Jane',
      'Date': 'Oct 06 2025',
      'Time': '14.00 - 16.00'
    },
   
  ].obs;

 void goToLogin() {
    Get.toNamed('/login');
  }
 void goToDashboard() {
    Get.toNamed('/dashboard');
  }
 void goToTicket() {
    Get.toNamed('/ticket');
  }
 
}

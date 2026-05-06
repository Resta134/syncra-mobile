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
      onConfirm: () {
        Get.back();

        Get.back(result: true);

        Future.delayed(Duration(milliseconds: 50), () {
          Get.snackbar(
            "Berhasil",
            "Akun berhasil dihapus",
            snackPosition: SnackPosition.BOTTOM,
          );
        });
      },
    );
  }

  void ubahProfil() {
    Get.defaultDialog(
      title: "Ubah Profil",
      content: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => userprofil[0]['name'] = value,
              decoration: InputDecoration(labelText: "Nama"),
            ),
            TextField(
              onChanged: (value) => userprofil[0]['email'] = value,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              onChanged: (value) => userprofil[0]['phone'] = value,
              decoration: InputDecoration(labelText: "Telepon"),
            ),
          ],
        ),
      ),
      textConfirm: "Simpan",
      textCancel: "Batal",
      onConfirm: () {
        Get.back();
        Get.snackbar("Berhasil", "Profil berhasil diubah");
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

  final userprofil =[
    {
      'name': 'Rhiki Sulistiyo',
      'email': 'rhikisulistiyo@example.com',
      'phone': '0895339162828',

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
      'title': 'AI Ethics & The Future of Work: A Global Perspective',
      'author': 'Dr. Rhiki',
      'Date': 'Oct 19 2025',
      'Time': '14.00 - 16.00'
    }
  ].obs;
 

 
}

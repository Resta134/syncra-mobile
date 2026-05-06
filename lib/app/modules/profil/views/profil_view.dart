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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // 1. BACKGROUND MELENGKUNG (Taruh paling atas agar posisinya di belakang)
                Container(
                  width: double.infinity,
                  height: 90, // Sesuaikan tingginya agar pas membingkai foto
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    // Membuat lengkungan dengan borderRadius hanya di bagian bawah
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
                          border: Border.all(color: Colors.white, width: 4),
                          image: DecorationImage(
                            image: AssetImage("images/profil.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      SizedBox(height: 10),

                      // NAMA DAN ROLE ================================================
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
                      icon: Icon(Icons.edit, size: 20, color: Colors.white),
                      onPressed: () {
                        print("klik");
                        controller.ubahfoto();
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
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
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
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

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul ditaruh di luar ListView biar ga ngulang-ngulang
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 19.0, vertical: 10),
                  child: Text(
                    'Recent Transcripts',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                // ListView di dalam Obx
                Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: controller.transkrip.length > 2
                        ? 2
                        : controller.transkrip.length,
                    itemBuilder: (context, index) {
                      final data = controller.transkrip[index];
                      return history_transcript(data);
                    },
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(15.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.person, color: Colors.blue),
                        title: Text("Name"),
                        subtitle: Obx(
                          () => Text(controller.userprofil[0]['name'] ?? ''),
                        ),
                      ),
                      Divider(),

                      ListTile(
                        leading: Icon(Icons.email, color: Colors.blue),
                        title: Text("Email"),
                        subtitle: Obx(
                          () => Text(controller.userprofil[0]['email'] ?? ''),
                        ),
                      ),
                      Divider(),

                      ListTile(
                        leading: Icon(Icons.phone, color: Colors.blue),
                        title: Text("Phone"),
                        subtitle: Obx(
                          () => Text(controller.userprofil[0]['phone'] ?? ''),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // BUTTON UBAH ==================================================
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 45,
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  controller.ubahProfil();
                },
                icon: Icon(Icons.edit, color: Colors.white),
                label: Text(
                  "Ubah Profil",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            // BUTTON SIMPAN ================================================
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton.icon(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.green,
            //       padding:  EdgeInsets.symmetric(vertical: 15),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //     ),
            //     onPressed: () {
            //       controller.updateProfile(
            //         controller.userprofil[0]['name'] ?? '',
            //         controller.userprofil[0]['email'] ?? '',
            //         controller.userprofil[0]['phone'] ?? '',
            //       );
            //     },
            //     icon:  Icon(Icons.check, color: Colors.white),
            //     label:  Text(
            //       "Simpan Perubahan",
            //       style: TextStyle(color: Colors.white),
            //     ),
            //   ),
            // ),
            SizedBox(height: 15),

            // BUTTON HAPUS =================================================
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 45,
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.red),
                  ),
                ),
                onPressed: () {
                  controller.deleteProfile();
                },
                icon: Icon(Icons.output_sharp, color: Colors.red),
                label: Text("Sign Out", style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget history_transcript(Map<String, String> data) {
  return Card(
    margin: EdgeInsets.only(bottom: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
      side: BorderSide(color: Colors.grey.shade200), // Ganti Container border pakai ini
    ),
    elevation: 2, // Gak usah terlalu tinggi elevationnya
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 16.0),
      child: Row(
        children: [
          // Expanded sangat penting di sini biar teks panjang ga bikin error overflow
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AMBIL DATA TITLE DENGAN BENER
                Text(
                  data['title']!,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
               SizedBox(height: 8),
                Row(
                  children: [
                   Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                   SizedBox(width: 5),
                    // AMBIL DATA DATE DARI CONTROLLER
                    Text(
                      data['Date']!, 
                      style: TextStyle(fontSize: 12, color: Colors.grey)
                    ),
                   SizedBox(width: 8),
                   Icon(Icons.circle, size: 5, color: Colors.grey),
                   SizedBox(width: 8),
                   Icon(Icons.access_time, size: 14, color: Colors.grey),
                   SizedBox(width: 5),
                    // AMBIL DATA TIME DARI CONTROLLER
                    Text(
                      data['Time']!, 
                      style: TextStyle(fontSize: 12, color: Colors.grey)
                    ),
                  ],
                ),
              ],
            ),
          ),
         SizedBox(width: 10),
          // Icon Download
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.download_outlined, color: Colors.blue, size: 20),
          ),
        ],
      ),
    ),
  );
}
}

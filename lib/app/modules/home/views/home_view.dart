import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage("images/image.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            SizedBox(width: 10),
            Text("Translator App"),
          ],
        ),
        elevation: 50,
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  controller.goToHistory();
                },
                icon: Icon(
                  Icons.notifications_active,
                  color: Colors.blue[700],
                  size: 25,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: InkWell(
                  onTap: () {
                    controller.goToProfil();
                  },
                  child: Container(
                    child: CircleAvatar(
                      backgroundImage: AssetImage("images/profil.png"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 8.0,
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Masukkan teks untuk diterjemahkan",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  suffixIcon: Icon(Icons.translate),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Card(
                child: Container(
                  width: double.infinity,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("images/profil.png", width: 50, height: 50),
                      SizedBox(width: 30),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // isi card event dengan nama pembicara, topik event, dan waktu event
                          Text(
                            "Nama Pembicara",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Topik Event",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Waktu Event",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            ElevatedButton(onPressed: controller.goToDashboard, child: Text("Go to Dashboard")),

            ElevatedButton(onPressed: controller.goToRegister, child: Text("Go to Register"))


          ],
        ),
      ),
    );
  }
}

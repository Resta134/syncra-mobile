import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tranlator_v1/app/components/custom_bottom_nav.dart';

import '../controllers/user_validation_controller.dart';

class UserValidationView extends GetView<UserValidationController> {
  const UserValidationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,//hapus arrow
        backgroundColor: Colors.blue.shade900,
        title: Text(
          'Title Events',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),

          PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: TextField(
                onChanged: (value) => controller.searchQuery.value = value,
                style: TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  hintText: 'Search name or ticket...',
                  fillColor: Colors.white,
                  hoverColor: Colors.grey.shade100,
                  filled: true,
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'List Name Participant In Events',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              final list = controller.filteredParticipants;

              if (list.isEmpty) {
                return Center(child: Text('Participant not found.'));
              }

              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final person = list[index];
                  final isPresent = person['status'] == 'Present';

                  return Card(
                    margin: EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isPresent
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                        child: Icon(
                          isPresent ? Icons.check : Icons.close,
                          color: isPresent ? Colors.green : Colors.red,
                        ),
                      ),
                      title: Text(
                        person['name']!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('ID: ${person['id']}'),
                      trailing: Text(
                        isPresent ? 'PRESENT' : 'ABSENT',
                        style: TextStyle(
                          color: isPresent ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        role: 'gatekeeper', // <-- Otomatis nampilin menu Q&A menyala
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('HistoryView'),
        // centerTitle: true,
      ),
      body: Center(
        child: Text(
          'HistoryView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

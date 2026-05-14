import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/facescanner_controller.dart';

class FacescannerView extends GetView<FacescannerController> {
  const FacescannerView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FacescannerView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'FacescannerView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

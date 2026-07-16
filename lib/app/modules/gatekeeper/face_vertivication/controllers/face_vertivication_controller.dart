// ABSENSI
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tranlator_v1/app/modules/gatekeeper/face_vertivication/helpers/image_helper.dart';
import 'package:tranlator_v1/app/modules/gatekeeper/face_vertivication/services/face_service.dart';

class FaceVertivicationController extends GetxController {
  CameraController? cameraController;
  late List<CameraDescription> cameras;

  final isCameraInitialized = false.obs;

  late FaceDetector faceDetector;
  late Interpreter interpreter;

  late FaceService faceService;

  final supabase = Supabase.instance.client;

  bool isDetecting = false;
  bool isVerifying = false;

  // =========================
  // UI STATE & DATA EVENT
  // =========================

  final statusText = "Posisikan wajah di dalam bingkai".obs;

  int stableFrame = 0;
  static const int requiredStableFrame = 8;
  
  String eventName = 'Syncra Event'; 

  @override
  void onInit() {
    super.onInit();
    
    if (Get.arguments != null) {
      eventName = Get.arguments['title'] ?? Get.arguments['nama_event'] ?? Get.arguments['name'] ?? 'Syncra Event';
    }
    
    _initialize();
  }

  Future<void> _initialize() async {
    faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableTracking: true,
        performanceMode: FaceDetectorMode.fast,
      ),
    );

    interpreter = await Interpreter.fromAsset('assets/mobilefacenet.tflite');
    faceService = FaceService(interpreter: interpreter, supabase: supabase);

    await faceService.loadRegisteredUsers();
    await _initializeCamera();

    print("✅ [Controller Ready] Pemindai siap digunakan.");
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();

    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await cameraController!.initialize();

    cameraController!.startImageStream((image) {
      if (!isCameraInitialized.value) return;
      _doFaceDetection(image);
    });

    isCameraInitialized.value = true;
    print("📷 [Camera] Kamera depan aktif.");
  }

  bool _isFaceInsideScanner(Face face) {
    final rect = face.boundingBox;
    final preview = cameraController!.value.previewSize!;

    final imageWidth = preview.height;
    final imageHeight = preview.width;

    const scannerSize = 320.0;
    final scannerLeft = (imageWidth - scannerSize) / 2;
    final scannerTop = (imageHeight - scannerSize) / 2;
    final scannerRight = scannerLeft + scannerSize;
    final scannerBottom = scannerTop + scannerSize;

    return rect.left > scannerLeft &&
        rect.top > scannerTop &&
        rect.right < scannerRight &&
        rect.bottom < scannerBottom;
  }

  Future<void> _doFaceDetection(CameraImage image) async {
    if (isDetecting || isVerifying) return;

    isDetecting = true;

    try {
      final inputImage = ImageHelper.cameraImageToInputImage(
        image,
        cameraController!.description,
      );

      if (inputImage == null) return;

      final faces = await faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        stableFrame = 0;
        statusText.value = "Arahkan wajah ke dalam bingkai";
        return;
      }

      final face = faces.first;

      stableFrame++;
      // UX Update: Teks lebih rapi tanpa menunjukkan angka konstan internal
      statusText.value = "Wajah terdeteksi, tahan posisi...";

      if (stableFrame >= requiredStableFrame) {
        stableFrame = 0;
        statusText.value = "Memverifikasi data...";

        await _doFaceVerification(image, face);
        return;
      }
    } finally {
      isDetecting = false;
    }
  }

  Future<void> _doFaceVerification(CameraImage image, Face face) async {
  if (isVerifying) return; // Mencegah proses ganda
  isVerifying = true; // Kunci proses

  try {
    final result = await faceService.verifyFace(image, face);

    if (result != null) {
      statusText.value = "Mencatat kehadiran...";
      
      // Stop stream SEBELUM menyimpan agar tidak ada deteksi ganda di latar belakang
      await cameraController?.stopImageStream();
      
      try {
        final now = DateTime.now();
        final jamSekarang = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} WIB";

        // Tambahkan pengecekan atau gunakan upsert jika ingin mengizinkan update
        await supabase.from('attendance').insert({
          'event_name': eventName,
          'user_id': result.id,
          'full_name': result.name, 
          'waktu_checkin': jamSekarang, 
        });
        
        print("✅ [Database] Kehadiran a.n ${result.name} berhasil disimpan!");
      } catch (dbError) {
        print("⚠️ [Database Error]: $dbError");
        // Jika error karena sudah absen, tetap tampilkan pop-up sukses/info
      }

      statusText.value = "Verifikasi Berhasil!";
      _showSuccessPopup(result.name);
      return; // Keluar dari fungsi setelah sukses
    }

    // Jika hasil null (tidak dikenali)
    statusText.value = "Wajah tidak dikenali";
    await Future.delayed(const Duration(milliseconds: 1200));
    statusText.value = "Posisikan wajah di dalam bingkai";
    stableFrame = 0;
    isVerifying = false; // Buka kunci agar bisa memindai lagi
  } catch (e) {
    print("❌ [Verification Error] $e");
    isVerifying = false;
  }
}
  // =========================================================
  // UX UPGRADE: POP-UP SUKSES MODERN (DARK GLASSMORPHISM)
  // =========================================================
  void _showSuccessPopup(String name) {
    Get.defaultDialog(
      title: "Check-In Berhasil! ✅",
      titleStyle: const TextStyle(
        color: Color(0xFF00dbe7),
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      backgroundColor: const Color(0xFF010f1f),
      radius: 20,
      barrierDismissible: false,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      content: Column(
        children: [
          const SizedBox(height: 5),
          const Icon(
            Icons.verified_user_rounded,
            color: Color(0xFF00dbe7),
            size: 50,
          ),
          const SizedBox(height: 15),
          Text(
            "Selamat datang,\n$name",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "Kehadiran Anda pada '$eventName' telah tercatat.",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00dbe7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () async {
                Get.back(); // Tutup Pop-up

                await Future.delayed(const Duration(milliseconds: 500));

                statusText.value = "Posisikan wajah di dalam bingkai";
                stableFrame = 0;
                isVerifying = false;
                isDetecting = false;

                // Nyalakan kembali stream kamera secara aman
                if (cameraController != null && !cameraController!.value.isStreamingImages) {
                  await cameraController!.startImageStream((image) {
                    if (!isCameraInitialized.value) return;
                    _doFaceDetection(image);
                  });
                }
              },
              child: const Text(
                "Lanjutkan Scan",
                style: TextStyle(
                  color: Color(0xFF010f1f),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    cameraController?.dispose();
    faceDetector.close();
    interpreter.close();
    super.onClose();
  }

  void dashboard() {
    Get.toNamed('/dashboard-gatekeeper');
  }

  void qr() {
    Get.toNamed('/qr-scanner');
  }
}
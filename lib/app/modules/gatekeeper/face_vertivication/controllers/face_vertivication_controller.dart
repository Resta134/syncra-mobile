// ABSENSI
import 'dart:io';
import 'package:camera/camera.dart';

import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tranlator_v1/app/modules/gatekeeper/face_vertivication/helpers/image_helper.dart';
import 'package:tranlator_v1/app/modules/gatekeeper/face_vertivication/services/face_service.dart';

class FaceVertivicationController extends GetxController {
  late CameraController cameraController;
  late List<CameraDescription> cameras;

  final isCameraInitialized = false.obs;

  late FaceDetector faceDetector;
  late Interpreter interpreter;

  late FaceService faceService;

  final supabase = Supabase.instance.client;

  bool isDetecting = false;
  bool isVerifying = false;

  // =========================
  // UI STATE
  // =========================

  final statusText = "Posisikan wajah di dalam frame".obs;

  int stableFrame = 0;
  static const int requiredStableFrame = 8;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    // Face Detector
    faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableTracking: true,
        performanceMode: FaceDetectorMode.fast,
      ),
    );

    // MobileFaceNet
    interpreter = await Interpreter.fromAsset('assets/mobilefacenet.tflite');

    faceService = FaceService(interpreter: interpreter, supabase: supabase);

    await faceService.loadRegisteredUsers();

    await _initializeCamera();

    print("✅ Face Verification Ready");
    print(interpreter.getInputTensor(0).shape);
    print(interpreter.getOutputTensor(0).shape);
  }
  // 3. INISIALISASI KAMERA

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

    await cameraController.initialize();

    cameraController.startImageStream((image) {
      if (!isCameraInitialized.value) return;

      _doFaceDetection(image);
    });

    isCameraInitialized.value = true;

    print("📷 Camera Ready");
  }

  // boundingBox ML Kit
  bool _isFaceInsideScanner(Face face) {
    final rect = face.boundingBox;

    // ukuran preview kamera
    final preview = cameraController.value.previewSize!;

    final imageWidth = preview.height;
    final imageHeight = preview.width;

    // area scanner (320x320)
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

  // 4. DETEKSI WAJAH DI FRAME
  Future<void> _doFaceDetection(CameraImage image) async {
    if (isDetecting || isVerifying) return;

    isDetecting = true;

    try {
      final inputImage = ImageHelper.cameraImageToInputImage(
        image,
        cameraController.description,
      );

      if (inputImage == null) return;

      final faces = await faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        stableFrame = 0;
        statusText.value = "Arahkan wajah ke frame";
        return;
      }

      final face = faces.first;

      // if (_isFaceInsideScanner(face)) {
      //   stableFrame++;
      //   print("Stable : $stableFrame");

      //   statusText.value =
      //       "Menstabilkan wajah ($stableFrame/$requiredStableFrame)";
      // } else {
      //   stableFrame = 0;
      //   statusText.value = "Posisikan wajah di tengah";
      //   return;
      // }
      stableFrame++;

      print("Stable : $stableFrame");

      statusText.value =
          "Menstabilkan wajah ($stableFrame/$requiredStableFrame)";

      if (stableFrame >= requiredStableFrame) {
        stableFrame = 0;

        statusText.value = "Memverifikasi...";

        await _doFaceVerification(image, face);
        return;
      }
      print("Stable : $stableFrame");
    } finally {
      isDetecting = false;
    }
  }

  Future<void> _doFaceVerification(CameraImage image, Face face) async {
    if (isVerifying) return;

    isVerifying = true;

    try {
      final result = await faceService.verifyFace(image, face);

      if (result != null) {
        statusText.value = "Verifikasi berhasil";

        await cameraController.stopImageStream();

        print("AAAAAAAAAAAA");
        print(result.name);
        print("BBBBBBBBBBBB");
        _showSuccessPopup(result.name);

        return;
      }

      statusText.value = "Wajah tidak dikenali";

      await Future.delayed(const Duration(milliseconds: 1200));
      statusText.value = "Posisikan wajah di dalam frame";

      stableFrame = 0;

      isVerifying = false;
    } catch (e) {
      print(e);

      isVerifying = false;
    }
  }

  void _showSuccessPopup(String name) {
    Get.defaultDialog(
      title: "Check In Berhasil",
      middleText: "Selamat datang,\n$name",
      barrierDismissible: false,
      textConfirm: "OK",
      onConfirm: () async {
        Get.back();

        await Future.delayed(const Duration(milliseconds: 1200));

        statusText.value = "Posisikan wajah di dalam frame";

        stableFrame = 0;

        isVerifying = false;
        isDetecting = false;

        if (!cameraController.value.isStreamingImages) {
          await cameraController.startImageStream((image) {
            if (!isCameraInitialized.value) return;

            _doFaceDetection(image);
          });
        }
      },
    );
  }

  @override
  void onClose() {
    cameraController.dispose();

    faceDetector.close();

    interpreter.close();

    super.onClose();
  }

  void dashboard() {
    Get.toNamed('dashboard-gatekeeper');
  }

  void qr() {
    Get.toNamed('qr-scanner');
  }
}

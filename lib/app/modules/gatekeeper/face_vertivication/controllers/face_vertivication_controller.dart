// ABSENSI
import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class FaceVertivicationController extends GetxController {
  late CameraController cameraController;
  late List<CameraDescription> cameras;
  var isCameraInitialized = false.obs;

  late FaceDetector faceDetector;
  Interpreter? interpreter;

  final supabase = Supabase.instance.client;

  bool isDetecting = false;
  bool isVerifying = false;

  // List untuk menyimpan data peserta dari Supabase di memori lokal agar scan cepat
  List<Map<String, dynamic>> registeredUsers = [];

  @override
  void onInit() {
    super.onInit();
    _fetchRegisteredFaces().then((_) {
      _initializeDlModels().then((_) {
        _initializeCamera();
      });
    });
  }

  // 1. AMBIL DATA REFERENSI WAJAH DARI DATABASE
  Future<void> _fetchRegisteredFaces() async {
    try {
      print("☁️ LOG: Mengunduh data wajah peserta dari Supabase...");
      // Ambil profil peserta yang sudah mendaftarkan wajah (face_vector tidak null)
      final response = await supabase
          .from('profiles')
          .select('id, full_name, face_vector')
          .not('face_vector', 'is', null);

      registeredUsers = List<Map<String, dynamic>>.from(response);
      print(
        "☁️ LOG: Berhasil memuat ${registeredUsers.length} data wajah peserta.",
      );
    } catch (e) {
      print("❌ LOG ERROR SUPABASE: Gagal mengambil data wajah. $e");
    }
  }

  // 2. INISIALISASI MODEL AI
  Future<void> _initializeDlModels() async {
    final options = FaceDetectorOptions(
      enableTracking: true,
      performanceMode: FaceDetectorMode.fast,
    );
    faceDetector = FaceDetector(options: options);

    try {
      //D:\Kuliah\SEMESTER_6\Mobile\capstone\syncra-mobile\assets\mobilefacenet.tflite
      interpreter = await Interpreter.fromAsset('assets/mobilefacenet.tflite');
      print("✅ LOG: Model TFLite berhasil dimuat!");
    } catch (e) {
      print("❌ LOG ERROR: Gagal memuat model TFLite: $e");
    }
  }

  // 3. INISIALISASI KAMERA
  void _initializeCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(
      cameras[1], // Gunakan kamera depan
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await cameraController.initialize();

    cameraController.startImageStream((CameraImage image) {
      if (isCameraInitialized.value) {
        _doFaceDetection(image);
      }
    });

    isCameraInitialized.value = true;
  }

  // 4. DETEKSI WAJAH DI FRAME
  // Di bagian _doFaceDetection
  void _doFaceDetection(CameraImage image) async {
    // Tambahkan kondisi: kalau sedang verifikasi, jangan deteksi, tapi kalau verifikasi
    // macet (misal 5 detik lebih), paksa reset.
    if (isVerifying) return;

    if (isDetecting) return;
    isDetecting = true;

    try {
      final inputImage = _convertCameraImageToInputImage(image);
      if (inputImage == null) return;

      final List<Face> faces = await faceDetector.processImage(inputImage);

      if (faces.isNotEmpty) {
        // Panggil verifikasi
        _doFaceVerification(image, faces.first);
      }
    } finally {
      isDetecting = false;
    }
  }

  //=============================
  // 5. PROSES TFLITE & PENCOCOKAN WAJAH (TUNGGAL & TERPADU)
  void _doFaceVerification(CameraImage rawImage, Face faceCoords) async {
    if (isVerifying) return;

    isVerifying = true;

    try {
      print("======================================");
      print("🚀 MULAI FACE VERIFICATION");
      print("======================================");

      img.Image? convertedImage = _convertCameraImageToImg(rawImage);

      if (convertedImage == null) {
        throw Exception("Gagal konversi gambar");
      }

      // =====================================================
      // A. CROP WAJAH
      // =====================================================

      final rect = faceCoords.boundingBox;

      int x = rect.left.toInt().clamp(0, convertedImage.width - 1);
      int y = rect.top.toInt().clamp(0, convertedImage.height - 1);
      int w = rect.width.toInt().clamp(0, convertedImage.width - x);
      int h = rect.height.toInt().clamp(0, convertedImage.height - y);

      img.Image croppedFace = img.copyCrop(
        convertedImage,
        x: x,
        y: y,
        width: w,
        height: h,
      );

      img.Image resizedFace = img.copyResize(
        croppedFace,
        width: 112,
        height: 112,
        interpolation: img.Interpolation.linear,
      );

      print("✅ Crop wajah berhasil");

      // =====================================================
      // B. INFERENCE MODEL
      // =====================================================

      var input = _imageToFloat32List(resizedFace);

      var outputShape = interpreter!.getOutputTensor(0).shape;

      print("🧠 Output Shape Model : $outputShape");

      int embeddingSize = outputShape[1];

      print("🧠 Embedding Size : $embeddingSize");

      var outputEmbedding = List.generate(
        1,
        (_) => List.filled(embeddingSize, 0.0),
      );

      interpreter!.run(input, outputEmbedding);

      List<double> liveFaceVector = outputEmbedding[0];

      print("Embedding sebelum normalize:");
      print(liveFaceVector.sublist(0, 5));

      liveFaceVector = _normalizeEmbedding(liveFaceVector);

      double norm = sqrt(liveFaceVector.fold(0.0, (s, e) => s + e * e));

      print("Norm = $norm");

      print("================================");
      print("LIVE NORMALIZED VECTOR");
      print("${liveFaceVector.sublist(0, 5)}");
      print("================================");
      print("LIVE VECTOR");
      print(liveFaceVector.sublist(0, 10));

      // =====================================================
      // C. FACE MATCHING
      // =====================================================

      String? matchedName;
      double bestMatchScore = 0.0;

      double threshold = 0.40;
      print("👥 Registered Users : ${registeredUsers.length}");

      for (var user in registeredUsers) {
        try {
          final faceVectorData = user['face_vector'];

          print("--------------------------------");
          print("👤 User : ${user['full_name']}");
          print("📦 Type : ${faceVectorData.runtimeType}");

          List<double> dbVector;

          if (faceVectorData is String) {
            dbVector = faceVectorData
                .replaceAll('[', '')
                .replaceAll(']', '')
                .split(',')
                .map((e) => double.parse(e.trim()))
                .toList();
          } else if (faceVectorData is List) {
            dbVector = faceVectorData
                .map((e) => (e as num).toDouble())
                .toList();
          } else {
            continue;
          }

          dbVector = _normalizeEmbedding(dbVector);

          print("🗄️ DB Vector Length : ${dbVector.length}");

          if (dbVector.length != liveFaceVector.length) {
            print(
              "❌ Panjang vector beda. Live=${liveFaceVector.length}, DB=${dbVector.length}",
            );
            continue;
          }

          double score = _cosineSimilarity(liveFaceVector, dbVector);
          print("🎯 Score ${user['full_name']} : $score");

          if (score > bestMatchScore) {
            bestMatchScore = score;
            matchedName = user['full_name'];
          }
          if (bestMatchScore > threshold) {
            // cocok
          } else {
            matchedName = null;
          }
        } catch (e) {
          print("❌ ERROR saat proses user ${user['full_name']} : $e");
        }
      }

      // =====================================================
      // D. HASIL
      // =====================================================

      print("======================================");
      print("🏁 VERIFICATION FINISHED");
      print("🏆 BEST SCORE : $bestMatchScore");
      print("🎯 THRESHOLD : $threshold");
      print("======================================");

      if (matchedName != null) {
        print("🎉 WAJAH COCOK DENGAN : $matchedName");

        // await cameraController.stopImageStream();

        _showSuccessPopup(matchedName);
      } else {
        print("⚠️ TIDAK ADA WAJAH YANG LOLOS THRESHOLD");

        isVerifying = false;
      }
    } catch (e, stackTrace) {
      print("❌ LOG ERROR Verifikasi: $e");
      print(stackTrace);

      isVerifying = false;
    }
  }

  // --- RUMUS MATEMATIKA: COSINE SIMILARITY ---
  // Fungsi ini membandingkan 2 array angka dan menghasilkan nilai 0.0 (Beda Jauh) sampai 1.0 (Sama Persis)

  double _cosineSimilarity(List<double> vectorA, List<double> vectorB) {
    if (vectorA.length != vectorB.length) return 0.0;

    double dotProduct = 0.0;
    double normA = 0.0;
    double normB = 0.0;

    for (int i = 0; i < vectorA.length; i++) {
      dotProduct += vectorA[i] * vectorB[i];
      normA += pow(vectorA[i], 2);
      normB += pow(vectorB[i], 2);
    }

    if (normA == 0.0 || normB == 0.0) return 0.0;
    return dotProduct / (sqrt(normA) * sqrt(normB));
  }

  void _showSuccessPopup(String userName) {
    Get.defaultDialog(
      title: "Check-In Berhasil",
      middleText: "Selamat datang, $userName!\n\nIdentitas terverifikasi.",
      backgroundColor: const Color(0xFF010f1f),
      titleStyle: const TextStyle(
        color: Color(0xFF00dbe7),
        fontWeight: FontWeight.bold,
      ),
      middleTextStyle: const TextStyle(color: Colors.white),
      barrierDismissible: false,
      radius: 10,
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF89CEFF),
        ),
        onPressed: () {
          Get.back(); // Tutup popup
          // Beri jeda 1.5 detik agar pengunjung punya waktu untuk bergeser
          // sebelum gembok AI dibuka lagi untuk pengunjung berikutnya.
          Future.delayed(const Duration(milliseconds: 1500), () {
            isVerifying = false;
            isDetecting = false; // Pastikan flag deteksi juga direset
          });
        },

        child: const Text(
          "Lanjut Scan",
          style: TextStyle(
            color: Color(0xFF00344d),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  } // =========================================================================
  // FUNGSI BANTUAN UI & IMAGE PROCESSING (Sama seperti ScanPageController)

  // =========================================================================

  void report() {
    Get.snackbar('Report', 'Membuka formulir pelaporan isu scanner...');
  }

  void qr() {
    Get.toNamed('/qr-scanner');
  }

  InputImage? _convertCameraImageToInputImage(CameraImage image) {
    final camera = cameras[1];
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation = InputImageRotationValue.fromRawValue(
      sensorOrientation,
    );
    if (rotation == null) return null;

    InputImageFormat? format = InputImageFormatValue.fromRawValue(
      image.format.raw,
    );
    if (format == null) {
      format = Platform.isAndroid
          ? InputImageFormat.nv21
          : InputImageFormat.bgra8888;
    }
    if (image.planes.isEmpty) return null;

    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final Size imageSize = Size(
      image.width.toDouble(),
      image.height.toDouble(),
    );
    final InputImageMetadata metadata = InputImageMetadata(
      size: imageSize,
      rotation: rotation,
      format: format,
      bytesPerRow: image.planes.first.bytesPerRow,
    );
    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  img.Image? _convertCameraImageToImg(CameraImage image) {
    try {
      final int width = image.width;
      final int height = image.height;
      final int frameSize = width * height;
      var imgImage = img.Image(width: width, height: height);

      if (image.planes.length == 1) {
        var bytes = image.planes[0].bytes;
        if (bytes.length == frameSize * 4) {
          for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
              final int index = (y * width + x) * 4;
              imgImage.setPixelRgb(
                x,
                y,
                bytes[index + 2],
                bytes[index + 1],
                bytes[index],
              );
            }
          }
        } else if (bytes.length == (frameSize * 1.5).round()) {
          for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
              int yIndex = y * width + x;
              int uvIndex = frameSize + (y >> 1) * width + (x & ~1);
              int yp = bytes[yIndex],
                  vp = bytes[uvIndex],
                  up = bytes[uvIndex + 1];
              int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
              int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
                  .round()
                  .clamp(0, 255);
              int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
              imgImage.setPixelRgb(x, y, r, g, b);
            }
          }
        }
      } else if (image.planes.length >= 3) {
        final int uvRowStride = image.planes[1].bytesPerRow;
        final int uvPixelStride = image.planes[1].bytesPerPixel ?? 1;
        for (int x = 0; x < width; x++) {
          for (int y = 0; y < height; y++) {
            final int uvIndex =
                uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
            final int index = y * width + x;
            final yp = image.planes[0].bytes[index];
            final up = image.planes[1].bytes[uvIndex];
            final vp = image.planes[2].bytes[uvIndex];
            int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
            int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
                .round()
                .clamp(0, 255);
            int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
            imgImage.setPixelRgb(x, y, r, g, b);
          }
        }
      }
      return img.copyRotate(imgImage, angle: -90);
    } catch (e) {
      return null;
    }
  }

  List<List<List<List<double>>>> _imageToFloat32List(img.Image image) {
    var input = List.generate(
      1,
      (i) => List.generate(
        112,
        (y) => List.generate(112, (x) => List.filled(3, 0.0)),
      ),
    );

    for (int y = 0; y < 112; y++) {
      for (int x = 0; x < 112; x++) {
        var pixel = image.getPixel(x, y);

        input[0][y][x][0] = (pixel.r - 127.5) / 127.5;
        input[0][y][x][1] = (pixel.g - 127.5) / 127.5;
        input[0][y][x][2] = (pixel.b - 127.5) / 127.5;
      }
    }

    return input;
  }

  List<double> _normalizeEmbedding(List<double> embedding) {
    double norm = 0.0;

    for (double value in embedding) {
      norm += value * value;
    }

    norm = sqrt(norm);

    if (norm == 0) return embedding;

    return embedding.map((e) => e / norm).toList();
  }

  @override
  void onClose() {
    cameraController.dispose();
    faceDetector.close();
    interpreter?.close();
    super.onClose();
  }

  void dashboard() {
    Get.toNamed('dashboard-gatekeeper');
  }
}

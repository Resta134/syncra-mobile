import 'package:get/get.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class ScanPageController extends GetxController {
  //TODO: Implement ScanPageController

  late CameraController cameraController;
  late List<CameraDescription> cameras;
  var isCameraInitialized = false.obs;

  // ML Kit Face Detector
  late FaceDetector faceDetector;
  var detectedFace = Rxn<Face>();

  // TFLite Interpreter
  // late Interpreter interpreter;
  Interpreter? interpreter;

  // Supabase Client
  final supabase = Supabase.instance.client;

  // --- KUNCI PENGAMAN (LOCKS) ---
  bool isDetecting = false;
  bool isVerifying = false;

  @override
  void onInit() {
    super.onInit();
    _initializeDlModels().then((_) {
      _initializeCamera();
    });
  }

  // 1. Inisialisasi Kamera & Stream
  void _initializeCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(
      cameras[1],
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
    print("📸 LOG: Kamera berhasil dimulai!");
  }

  // 2. Inisialisasi Model ML Kit & TFLite
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

  // 3. Logika Deteksi Wajah (ML Kit)
  void _doFaceDetection(CameraImage image) async {
    if (isDetecting || isVerifying) return;

    isDetecting = true;

    try {
      final inputImage = _convertCameraImageToInputImage(image);
      if (inputImage == null) {
        isDetecting = false;
        return;
      }

      final List<Face> faces = await faceDetector.processImage(inputImage);

      if (faces.isNotEmpty) {
        detectedFace.value = faces.first;
        if (_isFaceInTargetArea(detectedFace.value!)) {
          _doFaceVerification(image, detectedFace.value!);
        }
      } else {
        detectedFace.value = null;
      }
    } catch (e) {
      print("❌ LOG ERROR ML Kit: $e");
    } finally {
      isDetecting = false;
    }
  }

  bool _isFaceInTargetArea(Face face) => true;

  // 4. Logika Verifikasi Wajah (Model TFLite) & Kirim ke Supabase
  void _doFaceVerification(CameraImage rawImage, Face faceCoords) async {
    isVerifying = true;
    print("⏳ LOG: Memulai proses ekstraksi fitur wajah asli...");

    try {
      img.Image? convertedImage = _convertCameraImageToImg(rawImage);
      if (convertedImage == null) throw Exception("Gagal konversi gambar");

      // 1. Ambil koordinat wajah (Tambah pengaman agar crop tidak out-of-bounds)
      final rect = faceCoords.boundingBox;
      int x = rect.left.toInt().clamp(0, convertedImage.width);
      int y = rect.top.toInt().clamp(0, convertedImage.height);
      int w = rect.width.toInt().clamp(0, convertedImage.width - x);
      int h = rect.height.toInt().clamp(0, convertedImage.height - y);

      // 2. Crop & Resize
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
      );

      // 3. Konversi ke bentuk array multi-dimensi [1][112][112][3]
      var input = _imageToFloat32List(resizedFace);

      // 4. BACA BENTUK MODEL ASLIMU
      // Biasanya MobileFaceNet mengeluarkan 192 dimensi, bukan 128. Kita cek otomatis!
      var outputShape = interpreter!.getOutputTensor(0).shape;
      int embeddingSize =
          outputShape[1]; // Mengambil angka 128 atau 192 dari model

      // Buat wadah output tipe Murni [1][ukuran_model]
      var outputEmbedding = List.generate(
        1,
        (index) => List.filled(embeddingSize, 0.0),
      );

      // 5. JALANKAN TFLITE (Sekarang pasti dieksekusi)
      interpreter!.run(input, outputEmbedding);
      print("================================");
      print("REGISTER OUTPUT SHAPE : ${interpreter!.getOutputTensor(0).shape}");
      print("REGISTER VECTOR LENGTH : ${outputEmbedding[0].length}");
      print("================================");

      // 6. Ambil hasilnya
      // 6. Ambil hasil embedding
      List<double> vektorWajahAsli = outputEmbedding[0];

      print("================================");
      print("FINAL VECTOR LENGTH : ${vektorWajahAsli.length}");
      print("================================");

      print(
        "✅ LOG: Vektor Asli Didapat! 3 angka pertama: ${vektorWajahAsli.sublist(0, 3)}",
      );

      // 7. Simpan ke Supabase
      await simpanDataWajah(vektorWajahAsli);

      print("☁️ LOG: Face Vector berhasil disimpan");

      // 8. Stop scanner & tampilkan popup
      await cameraController.stopImageStream();

      _showSuccessPopup();
    } catch (e) {
      print("❌ LOG ERROR Verifikasi TFLite: $e");
      isVerifying = false;
    }
  }

  // FUNGSI SUPABASE BARU
  // FUNGSI SUPABASE BARU (Sudah Diperbaiki)
  Future<void> simpanDataWajah(List<double> vektor) async {
  try {
    print("☁️ LOG: Mencoba mengirim embedding ke Supabase...");

    final currentUser = supabase.auth.currentUser;

    if (currentUser == null) {
      print("❌ LOG: User belum login");
      return;
    }

    final userId = currentUser.id;

    print("================================");
    print("USER ID : $userId");
    print("VECTOR LENGTH : ${vektor.length}");
    print("================================");

    await supabase
        .from('profiles')
        .update({
          'face_vector': vektor,
        })
        .eq('id', userId);

    print("✅ LOG: Face Vector berhasil diupdate");
  } on PostgrestException catch (e) {
    print("❌ LOG ERROR SUPABASE: ${e.message}");
  } catch (e) {
    print("❌ LOG ERROR UMUM: $e");
  }
}
  void _showSuccessPopup() {
    Get.defaultDialog(
      title: "Berhasil",
      middleText: "Data wajah tersimpan di Cloud!",
      backgroundColor: const Color(0xFF010f1f),
      titleStyle: const TextStyle(
        color: Color(0xFF89CEFF),
        fontWeight: FontWeight.bold,
      ),
      middleTextStyle: const TextStyle(color: Colors.white),
      barrierDismissible: false,
      radius: 15,
      confirm: TextButton(
        onPressed: () {
          Get.back();
          Get.back();
        },
        child: const Text(
          "Lanjutkan",
          style: TextStyle(color: Color(0xFF00dbe7)),
        ),
      ),
    );
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

  // --- FUNGSI BANTUAN 1: Mengubah Gambar ke Matriks Float32 ---
  // --- FUNGSI BANTUAN 1: Mengubah Gambar ke Matriks Float32 (Murni Multi-Dimensi) ---
  List<List<List<List<double>>>> _imageToFloat32List(img.Image image) {
    // Buat wadah [1, 112, 112, 3] yang spesifik bertipe List<double>
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
        // Normalisasi MobileFaceNet: (pixel - 127.5) / 128.0
        input[0][y][x][0] = (pixel.r - 127.5) / 128.0; // Red
        input[0][y][x][1] = (pixel.g - 127.5) / 128.0; // Green
        input[0][y][x][2] = (pixel.b - 127.5) / 128.0; // Blue
      }
    }
    return input;
  }

  // --- FUNGSI BANTUAN 2: Convert YUV420 CameraImage ke img.Image ---
  // --- FUNGSI BANTUAN 2: Convert CameraImage ke img.Image (Versi Tahan Banting) ---
  // --- FUNGSI BANTUAN 2: Convert CameraImage ke img.Image (Versi Paling Kebal) ---
  img.Image? _convertCameraImageToImg(CameraImage image) {
    try {
      final int width = image.width;
      final int height = image.height;
      final int frameSize = width * height;
      var imgImage = img.Image(width: width, height: height);

      // JIKA KAMERA MENGIRIM DATA DALAM 1 LAPIS (1 PLANE)
      if (image.planes.length == 1) {
        var bytes = image.planes[0].bytes;

        // KONDISI A: Format BGRA8888 (4 bytes per pixel)
        if (bytes.length == frameSize * 4) {
          for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
              final int index = (y * width + x) * 4;
              final int b = bytes[index];
              final int g = bytes[index + 1];
              final int r = bytes[index + 2];
              imgImage.setPixelRgb(x, y, r, g, b);
            }
          }
        }
        // KONDISI B: Format NV21 (1.5 bytes per pixel) -> INI YANG TERJADI DI HP KAMU
        else if (bytes.length == (frameSize * 1.5).round()) {
          for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
              int yIndex = y * width + x;
              // Rumus khusus melompat ke blok warna (UV) di akhir array NV21
              int uvIndex = frameSize + (y >> 1) * width + (x & ~1);

              int yp = bytes[yIndex];
              int vp = bytes[uvIndex]; // Di NV21, warna V ada di depan U
              int up = bytes[uvIndex + 1];

              // Normalisasi YUV ke RGB
              int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
              int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
                  .round()
                  .clamp(0, 255);
              int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);

              imgImage.setPixelRgb(x, y, r, g, b);
            }
          }
        }
      }
      // JIKA KAMERA MENGIRIM DATA DALAM 3 LAPIS STANDARD (YUV420)
      else if (image.planes.length >= 3) {
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

      // Rotasi -90 karena tangkapan hardware kamera depan biasanya landscape
      return img.copyRotate(imgImage, angle: -90);
    } catch (e) {
      print("Error convert image: $e");
      return null;
    }
  }

  @override
  void onClose() {
    cameraController.dispose();
    faceDetector.close();

    // GANTI JADI:
    interpreter?.close();

    super.onClose();
  }
}

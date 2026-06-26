// REGISTRASI
import 'dart:math';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart'
    as img; // Alias untuk membedakan dengan Image Flutter
import 'package:supabase_flutter/supabase_flutter.dart';

class FaceScannerController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Variabel Kamera
  CameraController? cameraController;
  var isCameraInitialized = false.obs;

  // ML Kit Face Detector
  late FaceDetector faceDetector;
  var isDetecting = false;

  // TFLite Interpreter
  Interpreter? interpreter;

  // State UI
  var instructionText = "Arahkan wajah Anda ke dalam area".obs;
  var hasBlinked = false.obs;

  late Map<String, dynamic> eventData;

  @override
  void onInit() {
    super.onInit();
    eventData = Get.arguments ?? {};

    // Inisialisasi ML Kit Face Detector
    final options = FaceDetectorOptions(
      enableClassification: true, // Untuk deteksi kedip
      enableTracking: true,
      performanceMode: FaceDetectorMode.fast,
    );
    faceDetector = FaceDetector(options: options);

    initCamera();
    loadTFLiteModel(); // Load otak AI
  }

  // =========================================
  // 1. INISIALISASI KAMERA & MODEL AI
  // =========================================
  Future<void> initCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      cameraController = CameraController(
        frontCamera,
        ResolutionPreset
            .medium, // Medium lebih aman untuk image processing realtime
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await cameraController!.initialize();
      isCameraInitialized.value = true;

      cameraController!.startImageStream((image) {
        if (!isDetecting) {
          isDetecting = true;
          processImage(image);
        }
      });
    } catch (e) {
      print("Error kamera: $e");
    }
  }

  Future<void> loadTFLiteModel() async {
    try {
      interpreter = await Interpreter.fromAsset('assets/mobilefacenet.tflite');
      print("TFLite Model Berhasil Dimuat!");
    } catch (e) {
      print("Gagal memuat TFLite Model: $e");
    }
  }

  // =========================================
  // 2. DETEKSI WAJAH & KEDIPAN (ML KIT)
  // =========================================
  Future<void> processImage(CameraImage image) async {
    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final Size imageSize = Size(
        image.width.toDouble(),
        image.height.toDouble(),
      );
      final imageRotation =
          InputImageRotationValue.fromRawValue(
            cameraController!.description.sensorOrientation,
          ) ??
          InputImageRotation.rotation270deg;

      final inputImageFormat =
          InputImageFormatValue.fromRawValue(image.format.raw) ??
          InputImageFormat.nv21;

      final metadata = InputImageMetadata(
        size: imageSize,
        rotation: imageRotation,
        format: inputImageFormat,
        bytesPerRow: image.planes.first.bytesPerRow,
      );

      final inputImage = InputImage.fromBytes(bytes: bytes, metadata: metadata);

      final faces = await faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        instructionText.value = "Wajah tidak terdeteksi";
      } else {
        final face = faces.first;

        if (face.leftEyeOpenProbability != null &&
            face.rightEyeOpenProbability != null) {
          final leftEyeOpen = face.leftEyeOpenProbability!;
          final rightEyeOpen = face.rightEyeOpenProbability!;

          if (!hasBlinked.value) {
            instructionText.value = "Tolong kedipkan mata Anda...";

            // Liveness Terdeteksi! (Kedip)
            if (leftEyeOpen < 0.3 && rightEyeOpen < 0.3) {
              hasBlinked.value = true;
              instructionText.value = "Memproses Vektor Wajah...";

              await cameraController!.stopImageStream();

              // Mulai proses ekstraksi AI sungguhan
              await extractAndSaveVector(image, face);
            }
          }
        }
      }
    } catch (e) {
      print("Error proses gambar: $e");
    } finally {
      isDetecting = false;
    }
  }

  // =========================================
  // 3. EKSTRAKSI VEKTOR & SIMPAN (TFLITE)
  // =========================================
  Future<void> extractAndSaveVector(CameraImage cameraImage, Face face) async {
    if (interpreter == null) {
      Get.snackbar('Error', 'Model AI belum siap.');
      return;
    }

    try {
      // 1. Konversi format raw kamera ke format gambar standar yang bisa dimanipulasi
      img.Image convertedImage = _convertYUV420ToImage(cameraImage);

      // Rotate gambar sesuai orientasi sensor (kamera depan biasanya perlu diputar 270 derajat)
      convertedImage = img.copyRotate(convertedImage, angle: 270);

      // 2. Crop bagian wajah sesuai kotak (BoundingBox) dari ML Kit
      final rect = face.boundingBox;
      img.Image croppedFace = img.copyCrop(
        convertedImage,
        x: rect.left.toInt(),
        y: rect.top.toInt(),
        width: rect.width.toInt(),
        height: rect.height.toInt(),
      );

      // 3. Resize ke 112x112 untuk MobileFaceNet
      img.Image resizedFace = img.copyResize(
        croppedFace,
        width: 112,
        height: 112,
      );

      // 4. Ubah gambar ke format array input [1, 112, 112, 3] Float32
      List input = imageToByteListFloat32(resizedFace, 112, 127.5, 127.5);

      // Siapkan array kosong untuk menampung hasil dari AI (128 angka)
      List output = List.filled(1 * 192, 0).reshape(
        [1, 192],
      ); // Catatan: MobileFaceNet tertentu outputnya 192, jika error ubah ke 128.

      // 5. JALANKAN AI SUNGGUHAN
      interpreter!.run(input, output);

      // 6. Tangkap hasil Vektor
      List<double> vektorWajahAsli = output[0];

      // NORMALISASI
      vektorWajahAsli = _normalizeEmbedding(vektorWajahAsli);

      print("================================");
      print("NORMALIZED VECTOR LENGTH : ${vektorWajahAsli.length}");
      print("3 ANGKA PERTAMA : ${vektorWajahAsli.sublist(0, 3)}");
      print("================================");
      print("REGISTER VECTOR");
      print(vektorWajahAsli.sublist(0, 10));

      // 7. Simpan Vektor ke Supabase (Pastikan kamu punya tabel users/profiles dengan kolom tipe vector)
      /* // KODE SUPABASE NANTI (Di-comment dulu agar tidak error jika kolom belum dibuat)
      final userId = _supabase.auth.currentUser?.id;
      if (userId != null) {
        await _supabase.from('users').update({
          'face_vector': faceVector
        }).eq('id', userId);
      }
      */

      Get.snackbar(
        'Registrasi Selesai',
        'Data wajah berhasil diamankan dan didaftarkan.',
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );

      Get.offAllNamed('/ticket', arguments: eventData);
    } catch (e) {
      print("Gagal Ekstraksi Vektor: $e");
      Get.snackbar(
        'Error',
        'Gagal memproses wajah. Coba lagi.',
        backgroundColor: Colors.red.withOpacity(0.1),
      );

      // Ulangi deteksi jika gagal
      hasBlinked.value = false;
      initCamera();
    }
  }

  // =========================================
  // FUNGSI HELPER (MANIPULASI GAMBAR)
  // =========================================

  // Mengubah data mentah YUV kamera menjadi objek Gambar (Image)
  img.Image _convertYUV420ToImage(CameraImage image) {
    final width = image.width;
    final height = image.height;
    final uvRowStride = image.planes[1].bytesPerRow;
    final uvPixelStride = image.planes[1].bytesPerPixel!;
    final img.Image result = img.Image(width: width, height: height);

    for (int y = 0; y < height; y++) {
      int pY = y * image.planes[0].bytesPerRow;
      int pUV = (y >> 1) * uvRowStride;

      for (int x = 0; x < width; x++) {
        final int uvOffset = pUV + (x >> 1) * uvPixelStride;
        final int yValue = image.planes[0].bytes[pY];
        final int uValue = image.planes[1].bytes[uvOffset];
        final int vValue = image.planes[2].bytes[uvOffset];

        int r = (yValue + 1.402 * (vValue - 128)).toInt();
        int g = (yValue - 0.344136 * (uValue - 128) - 0.714136 * (vValue - 128))
            .toInt();
        int b = (yValue + 1.772 * (uValue - 128)).toInt();

        // Batasi nilai warna 0-255
        r = r.clamp(0, 255);
        g = g.clamp(0, 255);
        b = b.clamp(0, 255);

        result.setPixelRgb(x, y, r, g, b);
        pY++;
      }
    }
    return result;
  }

  // Menormalisasi warna gambar (0-255) menjadi angka desimal (untuk input TFLite)
  Float32List imageToByteListFloat32(
    img.Image image,
    int inputSize,
    double mean,
    double std,
  ) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        // Normalize: (PixelValue - Mean) / Std
        buffer[pixelIndex++] = (pixel.r - mean) / std; // Red
        buffer[pixelIndex++] = (pixel.g - mean) / std; // Green
        buffer[pixelIndex++] = (pixel.b - mean) / std; // Blue
      }
    }
    return convertedBytes.buffer.asFloat32List();
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
    cameraController?.dispose();
    faceDetector.close();
    interpreter?.close();
    super.onClose();
  }
}

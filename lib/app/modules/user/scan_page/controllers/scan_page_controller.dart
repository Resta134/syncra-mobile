import 'package:get/get.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';

class ScanPageController extends GetxController {
  late CameraController cameraController;
  late List<CameraDescription> cameras;
  var isCameraInitialized = false.obs;

  // ML Kit Face Detector
  late FaceDetector faceDetector;
  var detectedFace = Rxn<Face>();

  // TFLite Interpreter
  Interpreter? interpreter;

  // Supabase Client
  final supabase = Supabase.instance.client;

  // --- KUNCI PENGAMAN (LOCKS) ---
  bool isDetecting = false;
  bool isVerifying = false;
  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    _resetState();

    _initializeDlModels().then((_) {
      if (!_isDisposed) {
        _initializeCamera();
      }
    });
  }

  void _resetState() {
    _isDisposed = false;
    isDetecting = false;
    isVerifying = false;
    isCameraInitialized.value = false;
    detectedFace.value = null;
    print("🔄 LOG: State ScanPageController berhasil di-reset total!");
  }

  // 1. Inisialisasi Kamera & Stream
  void _initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.length < 2) {
        print("❌ LOG ERROR: Kamera depan tidak ditemukan!");
        return;
      }

      cameraController = CameraController(
        cameras[1], // Kamera Depan
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );

      await cameraController.initialize();

      if (_isDisposed) return;

      cameraController.startImageStream((CameraImage image) {
        if (isCameraInitialized.value &&
            !_isDisposed &&
            !isVerifying &&
            !isDetecting) {
          _doFaceDetection(image);
        }
      });

      isCameraInitialized.value = true;
      print("📸 LOG: Kamera berhasil dimulai!");
    } catch (e) {
      print("❌ LOG ERROR Kamera: $e");
    }
  }

  // 2. Inisialisasi Model ML Kit & TFLite
  Future<void> _initializeDlModels() async {
    final options = FaceDetectorOptions(
      enableTracking: true,
      performanceMode: FaceDetectorMode.fast,
    );
    faceDetector = FaceDetector(options: options);

    try {
      interpreter = await Interpreter.fromAsset('assets/mobilefacenet.tflite');
      print("✅ LOG: Model TFLite berhasil dimuat!");
    } catch (e) {
      print("❌ LOG ERROR: Gagal memuat model TFLite: $e");
    }
  }

  // 3. Logika Deteksi Wajah (ML Kit)
  void _doFaceDetection(CameraImage image) async {
    if (_isDisposed || isDetecting || isVerifying) return;

    isDetecting = true;

    try {
      final inputImage = _convertCameraImageToInputImage(image);
      if (inputImage == null) return;

      final List<Face> faces = await faceDetector.processImage(inputImage);

      if (faces.isNotEmpty && !isVerifying && !_isDisposed) {
        detectedFace.value = faces.first;
        if (_isFaceInTargetArea(detectedFace.value!)) {
          isVerifying = true;
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
    print("⏳ LOG: Memulai proses ekstraksi fitur wajah asli...");

    try {
      if (cameraController.value.isStreamingImages) {
        await cameraController.stopImageStream();
      }

      img.Image? convertedImage = _convertCameraImage(rawImage);
      if (convertedImage == null) {
        throw Exception("Gagal konversi gambar dari kamera");
      }

      final rect = faceCoords.boundingBox;

      int x = (rect.left - 10).toInt().clamp(0, convertedImage.width);
      int y = (rect.top - 10).toInt().clamp(0, convertedImage.height);
      int w = (rect.width + 20).toInt().clamp(0, convertedImage.width - x);
      int h = (rect.height + 20).toInt().clamp(0, convertedImage.height - y);

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

      var input = _imageToFloat32List(resizedFace);
      var outputShape = interpreter!.getOutputTensor(0).shape;
      int embeddingSize = outputShape[1];

      var outputEmbedding = List.generate(
        1,
        (index) => List.filled(embeddingSize, 0.0),
      );

      interpreter!.run(input, outputEmbedding);
      List<double> vektorWajahAsli = List<double>.from(outputEmbedding[0]);

      print("✅ LOG: Vektor Berhasil Didapat! Sampel: ${vektorWajahAsli.sublist(0, 3)}");

      // =========================================================================
      // SOLUSI UX BERSIH: Langsung simpan ke cloud tanpa pop-up debug teknis!
      // =========================================================================
      if (!_isDisposed) {
        print("🚀 LOG UX: Ekstraksi selesai, langsung menyimpan ke cloud secara senyap...");
        await simpanDataWajah(vektorWajahAsli);
        _showSuccessPopup(); // Tampilkan pop-up elegan untuk end-user
      }
    } catch (e) {
      print("❌ LOG ERROR Verifikasi TFLite / Simpan Wajah: $e");
      isVerifying = false;
      if (!_isDisposed &&
          isCameraInitialized.value &&
          !cameraController.value.isStreamingImages) {
        cameraController.startImageStream(_doFaceDetection);
      }
    }
  }

  // ===================================================================
  // FUNGSI KONVERSI GAMBAR (TIDAK DIUBAH SAMA SEKALI)
  // ===================================================================
  img.Image? _convertCameraImage(CameraImage image) {
    try {
      print("📸 LOG FORMAT: ${image.format.group} | Jumlah Planes: ${image.planes.length}");

      if (image.planes.length == 1) {
        return _convertSinglePlaneToImage(image);
      } else if (image.planes.length >= 3) {
        return _convertYUV420ToImageSafe(image);
      }

      print("❌ LOG: Jumlah planes (${image.planes.length}) tidak dikenali!");
      return null;
    } catch (e) {
      print("❌ LOG ERROR Konversi Gambar: $e");
      return null;
    }
  }

  img.Image _convertSinglePlaneToImage(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final bytes = image.planes[0].bytes;

    var imgImage = img.Image(width: width, height: height);

    if (bytes.length >= width * height * 4) {
      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          final int index = (y * width + x) * 4;
          if (index + 2 < bytes.length) {
            imgImage.setPixelRgb(
              x,
              y,
              bytes[index + 2],
              bytes[index + 1],
              bytes[index],
            );
          }
        }
      }
    } else {
      final int frameSize = width * height;
      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          int yIndex = y * width + x;
          int uvIndex = frameSize + (y >> 1) * width + (x & ~1);

          int yp = (yIndex < bytes.length) ? (bytes[yIndex] & 0xff) : 0;
          int vp = (uvIndex < bytes.length) ? (bytes[uvIndex] & 0xff) : 128;
          int up = (uvIndex + 1 < bytes.length)
              ? (bytes[uvIndex + 1] & 0xff)
              : 128;

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
  }

  img.Image _convertYUV420ToImageSafe(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final int uvRowStride = image.planes[1].bytesPerRow;
    final int uvPixelStride = image.planes[1].bytesPerPixel ?? 1;

    var imgImage = img.Image(width: width, height: height);

    final yBytes = image.planes[0].bytes;
    final uBytes = image.planes[1].bytes;
    final vBytes = image.planes[2].bytes;

    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final int uvIndex = uvPixelStride * (x >> 1) + uvRowStride * (y >> 1);
        final int index = y * width + x;

        final yp = (index < yBytes.length) ? (yBytes[index] & 0xff) : 0;
        final up = (uvIndex < uBytes.length) ? (uBytes[uvIndex] & 0xff) : 128;
        final vp = (uvIndex < vBytes.length) ? (vBytes[uvIndex] & 0xff) : 128;

        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
            .round()
            .clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);

        imgImage.setPixelRgb(x, y, r, g, b);
      }
    }
    return img.copyRotate(imgImage, angle: -90);
  }

  Future<void> simpanDataWajah(List<double> vektor) async {
    try {
      print("☁️ LOG: Mencoba mengirim embedding ke Supabase...");

      final session = supabase.auth.currentSession;
      final currentUser = supabase.auth.currentUser;

      if (currentUser == null || session == null) {
        print("❌ LOG ERROR: User belum login atau sesi expired!");
        Get.snackbar("Error", "Sesi login tidak valid, silakan login ulang");
        return;
      }

      final userId = currentUser.id;
      final userEmail = currentUser.email;

      print("🔍 DEBUG AUTH: Menyimpan vektor untuk Email: $userEmail (ID: $userId)");

      final response = await supabase
          .from('profiles')
          .update({'face_vector': vektor})
          .eq('id', userId)
          .select();

      print("✅ LOG SUKSES: Data di database terupdate -> $response");
    } on PostgrestException catch (e) {
      print("❌ LOG ERROR SUPABASE: ${e.message}");
      rethrow;
    } catch (e) {
      print("❌ LOG ERROR UMUM: $e");
      rethrow;
    }
  }

  // =========================================================================
  // UX POP-UP SUKSES: Dibuat lebih elegan untuk pengguna akhir
  // =========================================================================
  void _showSuccessPopup() {
    Get.defaultDialog(
      title: "Verifikasi Berhasil! ✅",
      middleText: "Wajah Anda telah berhasil dipindai dan terdaftar dengan aman di sistem.",
      backgroundColor: const Color(0xFF010f1f),
      titleStyle: const TextStyle(
        color: Color(0xFF00dbe7),
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      middleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 13,
        height: 1.4,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      barrierDismissible: false,
      radius: 20,
      confirm: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00dbe7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: () {
            _isDisposed = true;

            Get.back(); // Tutup dialog sukses
            Get.back(); // Keluar dari ScanPage kembali ke alur utama

            Future.delayed(const Duration(milliseconds: 300), () {
              if (Get.isRegistered<ScanPageController>()) {
                Get.delete<ScanPageController>(force: true);
                print("🗑️ LOG: Controller dipaksa hapus (force delete) dari memori!");
              }
            });
          },
          child: const Text(
            "Lanjutkan",
            style: TextStyle(
              color: Color(0xFF010f1f),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
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

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
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
        input[0][y][x][0] = (pixel.r - 127.5) / 128.0;
        input[0][y][x][1] = (pixel.g - 127.5) / 128.0;
        input[0][y][x][2] = (pixel.b - 127.5) / 128.0;
      }
    }
    return input;
  }

  @override
  void onClose() {
    _isDisposed = true;

    if (isCameraInitialized.value) {
      try {
        if (cameraController.value.isStreamingImages) {
          cameraController.stopImageStream().then((_) {
            cameraController.dispose();
          });
        } else {
          cameraController.dispose();
        }
      } catch (e) {
        print("⚠️ Warning saat tutup kamera: $e");
      }
    }

    try {
      faceDetector.close();
      interpreter?.close();
    } catch (e) {
      print("⚠️ Warning saat tutup model: $e");
    }

    print("🧹 LOG: ScanPageController berhasil di-dispose bersih 100%!");
    super.onClose();
  }
}
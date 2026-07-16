import 'dart:math';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tranlator_v1/app/modules/gatekeeper/face_vertivication/helpers/image_helper.dart';
import 'package:tranlator_v1/app/modules/gatekeeper/face_vertivication/helpers/similarity_helper.dart';

class FaceService {
  final Interpreter interpreter;
  final SupabaseClient supabase;

  FaceService({required this.interpreter, required this.supabase});

  List<Map<String, dynamic>> registeredUsers = [];

  /// ===============================
  /// LOAD SEMUA WAJAH DARI DATABASE
  /// ===============================
  // Di dalam FaceService.dart, perbarui cara load registered users
Future<void> loadRegisteredUsers() async {
  final response = await supabase
      .from('profiles')
      .select('id, full_name, face_vector')
      .not('face_vector', 'is', null);

  registeredUsers = (response as List).map((user) {
    List<double> vector;
    if (user['face_vector'] is String) {
      vector = (user['face_vector'] as String)
          .replaceAll('[', '').replaceAll(']', '')
          .split(',').map((e) => double.parse(e.trim())).toList();
    } else {
      vector = (user['face_vector'] as List)
          .map((e) => (e as num).toDouble()).toList();
    }
    
    // PENTING: Normalisasi saat load agar sama dengan liveVector
    return {
      'id': user['id'],
      'full_name': user['full_name'],
      'face_vector': SimilarityHelper.normalizeEmbedding(vector) 
    };
  }).toList();
} 

  /// ===============================
  /// VERIFIKASI WAJAH (NO CHANGE LOGIC)
  /// ===============================
  Future<MatchResult?> verifyFace(CameraImage rawImage, Face face) async {
    
    img.Image? image = ImageHelper.cameraImageToImage(rawImage);

    if (image == null) return null;

    //--------------------------------
    // Crop wajah
    //--------------------------------
    Rect rect = face.boundingBox;

    int x = rect.left.toInt().clamp(0, image.width - 1);
    int y = rect.top.toInt().clamp(0, image.height - 1);
    int w = rect.width.toInt().clamp(0, image.width - x);
    int h = rect.height.toInt().clamp(0, image.height - y);

    img.Image crop = img.copyCrop(image, x: x, y: y, width: w, height: h);

    crop = img.copyResize(
      crop,
      width: 112,
      height: 112,
      interpolation: img.Interpolation.linear,
    );

    //--------------------------------
    // Inference
    //--------------------------------
    var input = ImageHelper.imageToInput(crop);
    int embeddingSize = interpreter.getOutputTensor(0).shape[1];

    var output = List.generate(1, (_) => List.filled(embeddingSize, 0.0));

    interpreter.run(input, output);

    List<double> liveVector = SimilarityHelper.normalizeEmbedding(output[0]);

    //--------------------------------
    // Compare ke database
    //--------------------------------
  
    double bestScore = -1;
    String? bestName;
    String? bestId;
    // Gunakan 0.10 sebagai batas toleransi, 
    // tapi pastikan di bawah ini kita cek apakah bestScore mencapai threshold
    const double minThreshold = 0.10; 

    for (final user in registeredUsers) {
      List<double> dbVector = user['face_vector'] as List<double>; 
      double score = SimilarityHelper.cosineSimilarity(liveVector, dbVector);
      
      print("${user['full_name']} -> ${score.toStringAsFixed(4)}");

      // 1. Jika sangat mirip (Early Exit)
      if (score >= 0.85) { 
        return MatchResult(id: user['id'].toString(), name: user['full_name'], score: score);
      }

      // 2. Simpan kandidat jika memenuhi threshold
      if (score >= minThreshold && score > bestScore) {
        bestScore = score;
        bestName = user['full_name'];
        bestId = user['id'].toString();
      }
    }

    // PENTING: Hanya return jika bestScore memenuhi syarat
    if (bestId != null && bestScore >= minThreshold) {
      return MatchResult(id: bestId, name: bestName!, score: bestScore);
    }
    
    // Jika tidak ada yang memenuhi threshold, kembalikan null
    return null;
    }}
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
  Future<void> loadRegisteredUsers() async {
    final response = await supabase
        .from('profiles')
        .select('id, full_name, face_vector')
        .not('face_vector', 'is', null);

    registeredUsers = List<Map<String, dynamic>>.from(response);

    print("✅ Registered User : ${registeredUsers.length}");
  }

  /// ===============================
  /// VERIFIKASI WAJAH
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
    print(face.boundingBox);

    print(image.width);
    print(image.height);

    img.Image crop = img.copyCrop(image, x: x, y: y, width: w, height: h);
    print("${x}, ${y}, ${w}, ${h}");

    crop = img.copyResize(
      crop,
      width: 112,
      height: 112,
      interpolation: img.Interpolation.linear,
    );
    print("${crop.width} x ${crop.height}");
    //--------------------------------
    // Inference
    //--------------------------------

    var input = ImageHelper.imageToInput(crop);
    int embeddingSize = interpreter.getOutputTensor(0).shape[1];

    var output = List.generate(1, (_) => List.filled(embeddingSize, 0.0));

    interpreter.run(input, output);
    print("Inference selesai");

    List<double> liveVector = SimilarityHelper.normalizeEmbedding(output[0]);
    //--------------------------------
    // Compare ke database
    //--------------------------------

    double bestScore = -1;

    String? bestName;
    String? bestId;

    for (final user in registeredUsers) {
      try {
        List<double> dbVector;

        if (user['face_vector'] is String) {
          dbVector = (user['face_vector'] as String)
              .replaceAll('[', '')
              .replaceAll(']', '')
              .split(',')
              .map((e) => double.parse(e.trim()))
              .toList();
        } else {
          dbVector = (user['face_vector'] as List)
              .map((e) => (e as num).toDouble())
              .toList();
        }

        dbVector = SimilarityHelper.normalizeEmbedding(dbVector);
        if (dbVector.length != liveVector.length) {
          continue;
        }

        double score = SimilarityHelper.cosineSimilarity(liveVector, dbVector);
        print(liveVector.sublist(0,10));

        print("${user['full_name']} -> ${score.toStringAsFixed(4)}");

        if (score > bestScore) {
          bestScore = score;
          bestName = user['full_name'];
          bestId = user['id'].toString();
        }
      } catch (e, s) {
        print("ERROR USER : ${user['full_name']}");
        print(e);
        print(s);
      }
    }
    print("=========== VERIFY ===========");
    print("Registered : ${registeredUsers.length}");
    print("----------------------------");
    print("BEST MATCH : $bestName");
    print("BEST SCORE : $bestScore");
    print("----------------------------");

    //--------------------------------
    // Threshold
    //--------------------------------

    const threshold = 0.60;

    if (bestScore >= threshold) {
      return MatchResult(id: bestId!, name: bestName!, score: bestScore);
    }

    print("----------------------------");
    print("BEST ID    : $bestId");
    print("BEST NAME  : $bestName");
    print("Threshold  : $threshold");
    print("BEST SCORE : $bestScore");
    print("----------------------------");

    return null;
  }

}


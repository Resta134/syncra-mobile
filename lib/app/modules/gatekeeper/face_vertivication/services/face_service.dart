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

  /// 1. LOAD WAJAH (Kecuali yang sudah absen di event saat ini)
  Future<void> loadRegisteredUsers({String? eventName}) async {
    try {
      print("======================================");
      print("🚀 LOAD REGISTERED USERS DIMULAI");
      print("📌 Event : $eventName");

      // ================================
      // Ambil semua profile yang punya face_vector
      // ================================
      final response = await supabase
          .from('profiles')
          .select('id, full_name, face_vector')
          .not('face_vector', 'is', null);

      print("========== RESPONSE DARI DB ==========");
      print(response);
      print("Jumlah profile dari DB : ${(response as List).length}");
      print("======================================");

      // ================================
      // Ambil daftar user yang sudah check-in
      // ================================
      List<String> alreadyCheckedInIds = [];

      if (eventName != null) {
        final attendanceRes = await supabase
            .from('attendance')
            .select('user_id')
            .eq('event_name', eventName);

        alreadyCheckedInIds = (attendanceRes as List)
            .map((e) => e['user_id'].toString())
            .toList();

        print("User yang sudah check-in:");
        print(alreadyCheckedInIds);
      }

      // ================================
      // Filter user
      // ================================
      registeredUsers = (response)
          .where((user) => !alreadyCheckedInIds.contains(user['id'].toString()))
          .map((user) {
            List<double> vector;

            if (user['face_vector'] is String) {
              vector = (user['face_vector'] as String)
                  .replaceAll('[', '')
                  .replaceAll(']', '')
                  .split(',')
                  .map((e) => double.parse(e.trim()))
                  .toList();
            } else {
              vector = (user['face_vector'] as List)
                  .map((e) => (e as num).toDouble())
                  .toList();
            }

            print("✅ ${user['full_name']} | Vector Length : ${vector.length}");

            return {
              'id': user['id'].toString(),
              'full_name': user['full_name'],
              'face_vector': SimilarityHelper.normalizeEmbedding(vector),
            };
          })
          .toList();

      print("========== REGISTERED USERS ==========");

      for (final user in registeredUsers) {
        print("${user['full_name']} (${user['id']})");
      }

      print("======================================");

      print("🎯 [FaceService] Siap memindai ${registeredUsers.length} orang.");
    } catch (e, stackTrace) {
      print("❌ ERROR loadRegisteredUsers()");
      print(e);
      print(stackTrace);
    }
  }

  //
  /// 2. ELIMINASI INSTAN DARI RAM (Dianjurkan dipanggil setelah insert DB berhasil)
  void removeUserFromMemory(String userId) {
    registeredUsers.removeWhere((user) => user['id'] == userId);
    print(
      "[Eliminasi] User ID $userId telah dihapus dari antrean scan RAM. Sisa: ${registeredUsers.length} orang.",
    );
  }

  /// ===============================
  /// VERIFIKASI WAJAH (NO CHANGE LOGIC)
  /// ===============================
  Future<MatchResult?> verifyFace(
  CameraImage rawImage,
  Face face,
) async {
  img.Image? image = ImageHelper.cameraImageToImage(rawImage);

  if (image == null) return null;

  // ============================
  // Crop wajah
  // ============================

  final rect = face.boundingBox;

  final x = (rect.left - 10).toInt().clamp(0, image.width - 1);
  final y = (rect.top - 10).toInt().clamp(0, image.height - 1);
  final w =
      (rect.width + 20).toInt().clamp(0, image.width - x);
  final h =
      (rect.height + 20).toInt().clamp(0, image.height - y);

  img.Image crop = img.copyCrop(
    image,
    x: x,
    y: y,
    width: w,
    height: h,
  );

  crop = img.copyResize(
    crop,
    width: 112,
    height: 112,
    interpolation: img.Interpolation.linear,
  );

  // ============================
  // Inference (HANYA SEKALI)
  // ============================

  final input = ImageHelper.imageToInput(crop);

  final embeddingSize =
      interpreter.getOutputTensor(0).shape[1];

  final output = List.generate(
    1,
    (_) => List.filled(embeddingSize, 0.0),
  );

  interpreter.run(input, output);

  final liveVector =
      SimilarityHelper.normalizeEmbedding(output[0]);

  print("========== LIVE VECTOR ==========");
  print(output[0].take(10).toList());

  print("========== NORMALIZED ==========");
  print(liveVector.take(10).toList());

  // ============================
  // Compare
  // ============================

  double bestScore = -1;

  String? bestId;
  String? bestName;

  for (final user in registeredUsers) {
    final dbVector =
        user['face_vector'] as List<double>;

    final score = SimilarityHelper.cosineSimilarity(
      liveVector,
      dbVector,
    );

    print(
      "${user['full_name']} -> ${score.toStringAsFixed(4)}",
    );

    if (score > bestScore) {
      bestScore = score;
      bestId = user['id'].toString();
      bestName = user['full_name'];
    }
  }

  print("==================================");
  print("BEST : $bestName");
  print("SCORE : $bestScore");
  print("==================================");

  const threshold = 0.20;

  if (bestId == null) {
    return null;
  }

  if (bestScore < threshold) {
    return null;
  }

  return MatchResult(
    id: bestId,
    name: bestName!,
    score: bestScore,
  );
}
}

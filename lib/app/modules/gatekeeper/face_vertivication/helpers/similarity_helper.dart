import 'dart:math';

/// =======================================================
///
/// HASIL FACE MATCHING
///
/// =======================================================

class MatchResult {
  final String id;
  final String name;
  final double score;

  MatchResult({
    required this.id,
    required this.name,
    required this.score,
  });
}

/// =======================================================
///
/// SIMILARITY HELPER
///
/// =======================================================

class SimilarityHelper {
  /// -----------------------------------------
  /// Cari wajah terbaik dari database
  /// -----------------------------------------
  static MatchResult? findBestMatch(
    List<double> liveEmbedding,
    List<Map<String, dynamic>> users, {
    double threshold = 0.55,
  }) {
    MatchResult? bestMatch;

    print("=====================================");
    print("🔍 START FACE MATCHING");
    print("=====================================");
    print("👥 Registered Users : ${users.length}");
    print("🎯 Threshold : $threshold");

    for (final user in users) {
      try {
        final rawVector = user['face_vector'];

        List<double>? dbEmbedding = parseVector(rawVector);

        if (dbEmbedding == null) {
          print("❌ ${user['full_name']} vector invalid");
          continue;
        }

        dbEmbedding = normalizeEmbedding(dbEmbedding);

        if (dbEmbedding.length != liveEmbedding.length) {
          print(
            "❌ ${user['full_name']} panjang embedding beda",
          );
          continue;
        }

        final score = cosineSimilarity(
          liveEmbedding,
          dbEmbedding,
        );

        print(
          "👤 ${user['full_name']} -> ${score.toStringAsFixed(5)}",
        );

        if (bestMatch == null || score > bestMatch.score) {
          bestMatch = MatchResult(
            id: user['id'].toString(),
            name: user['full_name'],
            score: score,
          );

          print(
            "🏆 Best sementara : ${bestMatch.name}"
            " (${bestMatch.score.toStringAsFixed(5)})",
          );
        }
      } catch (e) {
        print(
          "❌ Error compare ${user['full_name']} : $e",
        );
      }
    }

    print("-------------------------------------");

    if (bestMatch == null) {
      print("❌ Tidak ada kandidat.");
      return null;
    }

    print(
      "🥇 Best Score : ${bestMatch.score.toStringAsFixed(5)}",
    );

    if (bestMatch.score >= threshold) {
      print("✅ MATCH : ${bestMatch.name}");
      return bestMatch;
    }

    print("⚠️ Tidak lolos threshold");
    return null;
  }

  /// -----------------------------------------
  /// Parse Vector Supabase
  /// -----------------------------------------
  static List<double>? parseVector(dynamic value) {
    try {
      if (value is List) {
        return value
            .map((e) => (e as num).toDouble())
            .toList();
      }

      if (value is String) {
        return value
            .replaceAll('[', '')
            .replaceAll(']', '')
            .split(',')
            .map((e) => double.parse(e.trim()))
            .toList();
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  /// -----------------------------------------
  /// Normalize Embedding
  /// -----------------------------------------
  static List<double> normalizeEmbedding(
    List<double> embedding,
  ) {
    double norm = 0.0;

    for (final value in embedding) {
      norm += value * value;
    }

    norm = sqrt(norm);

    if (norm == 0) {
      return embedding;
    }

    return embedding
        .map((e) => e / norm)
        .toList();
  }

  /// -----------------------------------------
  /// Cosine Similarity
  /// -----------------------------------------
  static double cosineSimilarity(
    List<double> vectorA,
    List<double> vectorB,
  ) {
    if (vectorA.length != vectorB.length) {
      return 0.0;
    }

    double dotProduct = 0.0;
    double normA = 0.0;
    double normB = 0.0;

    for (int i = 0; i < vectorA.length; i++) {
      dotProduct += vectorA[i] * vectorB[i];
      normA += vectorA[i] * vectorA[i];
      normB += vectorB[i] * vectorB[i];
    }

    if (normA == 0 || normB == 0) {
      return 0.0;
    }

    return dotProduct / (sqrt(normA) * sqrt(normB));
  }
}
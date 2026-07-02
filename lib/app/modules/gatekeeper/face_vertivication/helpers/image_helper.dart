import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;

class ImageHelper {
  // =====================================================
  // CameraImage -> InputImage (ML Kit)
  // =====================================================

  static InputImage? cameraImageToInputImage(
    CameraImage image,
    CameraDescription camera,
  ) {
    final rotation = InputImageRotationValue.fromRawValue(
      camera.sensorOrientation,
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

    final WriteBuffer buffer = WriteBuffer();

    for (final plane in image.planes) {
      buffer.putUint8List(plane.bytes);
    }

    final bytes = buffer.done().buffer.asUint8List();

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(
          image.width.toDouble(),
          image.height.toDouble(),
        ),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  // =====================================================
  // CameraImage -> image package
  // =====================================================

  static img.Image? cameraImageToImage(CameraImage image) {
    try {
      final width = image.width;
      final height = image.height;
      final frameSize = width * height;

      img.Image imgImage = img.Image(
        width: width,
        height: height,
      );

      // ===================================================
      // BGRA8888 (IOS)
      // ===================================================

      if (image.planes.length == 1) {
        final bytes = image.planes[0].bytes;

        if (bytes.length == frameSize * 4) {
          for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
              final index = (y * width + x) * 4;

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

        // =================================================
        // NV21
        // =================================================

        else if (bytes.length == (frameSize * 1.5).round()) {
          for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
              final yIndex = y * width + x;
              final uvIndex =
                  frameSize +
                  (y >> 1) * width +
                  (x & ~1);

              final yp = bytes[yIndex];
              final vp = bytes[uvIndex];
              final up = bytes[uvIndex + 1];

              final r = (yp + vp * 1436 / 1024 - 179)
                  .round()
                  .clamp(0, 255);

              final g = (yp -
                      up * 46549 / 131072 +
                      44 -
                      vp * 93604 / 131072 +
                      91)
                  .round()
                  .clamp(0, 255);

              final b = (yp + up * 1814 / 1024 - 227)
                  .round()
                  .clamp(0, 255);

              imgImage.setPixelRgb(x, y, r, g, b);
            }
          }
        }
      }

      // ===================================================
      // YUV420 Android
      // ===================================================

      else if (image.planes.length >= 3) {
        final uvRowStride = image.planes[1].bytesPerRow;
        final uvPixelStride =
            image.planes[1].bytesPerPixel ?? 1;

        for (int x = 0; x < width; x++) {
          for (int y = 0; y < height; y++) {
            final uvIndex =
                uvPixelStride * (x ~/ 2) +
                uvRowStride * (y ~/ 2);

            final index = y * width + x;

            final yp = image.planes[0].bytes[index];
            final up = image.planes[1].bytes[uvIndex];
            final vp = image.planes[2].bytes[uvIndex];

            final r = (yp + vp * 1436 / 1024 - 179)
                .round()
                .clamp(0, 255);

            final g = (yp -
                    up * 46549 / 131072 +
                    44 -
                    vp * 93604 / 131072 +
                    91)
                .round()
                .clamp(0, 255);

            final b = (yp + up * 1814 / 1024 - 227)
                .round()
                .clamp(0, 255);

            imgImage.setPixelRgb(x, y, r, g, b);
          }
        }
      }

      return img.copyRotate(
        imgImage,
        angle:-90,
      );
    } catch (e) {
      print("❌ ImageHelper Error : $e");
      return null;
    }
  }

  // =====================================================
  // Resize Face
  // =====================================================

  static img.Image resizeFace(img.Image face) {
    return img.copyResize(
      face,
      width: 112,
      height: 112,
    );
  }

  // =====================================================
  // MobileFaceNet Input
  // =====================================================

  static List<List<List<List<double>>>> imageToInput(
    img.Image image,
  ) {
    final input = List.generate(
      1,
      (_) => List.generate(
        112,
        (_) => List.generate(
          112,
          (_) => List.filled(3, 0.0),
        ),
      ),
    );

    for (int y = 0; y < 112; y++) {
      for (int x = 0; x < 112; x++) {
        final pixel = image.getPixel(x, y);

        input[0][y][x][0] =
            (pixel.r - 127.5) / 127.5;

        input[0][y][x][1] =
            (pixel.g - 127.5) / 127.5;

        input[0][y][x][2] =
            (pixel.b - 127.5) / 127.5;
      }
    }

    return input;
  }

}
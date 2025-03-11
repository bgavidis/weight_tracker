import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:camera/camera.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class OCRService {
  final textRecognizer = TextRecognizer();

  Future<String?> processImage(CameraImage image) async {
    try {
      final bytes = _concatenatePlanes(image.planes);
      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: InputImageRotation.rotation0deg,
          format: InputImageFormat.nv21,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );

      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          if (RegExp(r'\d+\.?\d*').hasMatch(line.text)) {
            return line.text;
          }
        }
      }
    } catch (e) {
      debugPrint("OCR Error: $e");
    }
    return null;
  }

  Uint8List _concatenatePlanes(List<Plane> planes) {
    final List<int> allBytes = <int>[];
    for (final Plane plane in planes) {
      allBytes.addAll(plane.bytes);
    }
    return Uint8List.fromList(allBytes);
  }

  void dispose() {
    textRecognizer.close();
  }
}

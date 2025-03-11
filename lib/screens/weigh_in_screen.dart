import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/ocr_service.dart';

class WeighInScreen extends StatefulWidget {
  const WeighInScreen({super.key});

  @override
  WeighInScreenState createState() => WeighInScreenState();
}

class WeighInScreenState extends State<WeighInScreen> {
  late CameraController _cameraController;
  bool _isProcessing = false;
  String? detectedWeight;
  final OCRService _ocrService = OCRService();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _cameraController.initialize();
    if (!mounted) return;
    setState(() {});
    _startImageStream();
  }

  void _startImageStream() {
    _cameraController.startImageStream((CameraImage image) async {
      if (_isProcessing) return;
      _isProcessing = true;
      final weight = await _ocrService.processImage(image);
      if (weight != null) {
        setState(() {
          detectedWeight = weight;
        });
      }
      _isProcessing = false;
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weigh In")),
      body: Column(
        children: [
          if (_cameraController.value.isInitialized)
            AspectRatio(
              aspectRatio: _cameraController.value.aspectRatio,
              child: CameraPreview(_cameraController),
            ),
          const SizedBox(height: 20),
          Text("Detected Weight: ${detectedWeight ?? "Waiting..."}",
              style: const TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}

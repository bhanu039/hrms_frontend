import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceCaptureView extends StatefulWidget {
  const FaceCaptureView({super.key});

  @override
  State<FaceCaptureView> createState() => _FaceCaptureViewState();
}

class _FaceCaptureViewState extends State<FaceCaptureView> {
  CameraController? _controller;
  late FaceDetector _faceDetector;

  bool isReady = false;
  bool isFaceDetected = false;
  bool areEyesOpen = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initDetector();
    _initCamera();
  }

  void _initDetector() {
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableLandmarks: true,
        enableClassification: true, // 👈 required for eyes open detection
        performanceMode: FaceDetectorMode.fast,
      ),
    );
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      front,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();

    if (!mounted) return;

    setState(() => isReady = true);

    _startFaceDetection();
  }

  void _startFaceDetection() {
    _controller!.startImageStream((CameraImage image) async {
      if (_isProcessing) return;
      _isProcessing = true;

      try {
        final inputImage = _convertCameraImage(image);
        final faces = await _faceDetector.processImage(inputImage);

        if (faces.isNotEmpty) {
          final face = faces.first;
          final leftEye = face.leftEyeOpenProbability ?? 0.0;
          final rightEye = face.rightEyeOpenProbability ?? 0.0;

          debugPrint('Face detected! Left eye: $leftEye, Right eye: $rightEye');

          setState(() {
            isFaceDetected = true; // Green border when face appears
            // Button enabled only when both eyes are open (> 0.5)
            areEyesOpen = leftEye > 0.5 && rightEye > 0.5;
            debugPrint('Eyes open: $areEyesOpen');
          });
        } else {
          debugPrint('No face detected');
          setState(() {
            isFaceDetected = false;
            areEyesOpen = false;
          });
        }
      } catch (e) {
        debugPrint('Face detection error: $e');
      } finally {
        _isProcessing = false;
      }
    });
  }

  InputImage _convertCameraImage(CameraImage image) {
    final WriteBuffer allBytes = WriteBuffer();

    for (final plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }

    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(
      image.width.toDouble(),
      image.height.toDouble(),
    );

    final camera = _controller!.description;

    // Use actual sensor orientation for both front and back cameras
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
        InputImageRotation.rotation0deg;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw) ??
        InputImageFormat.yuv420;

    debugPrint(
      'Image: ${image.width}x${image.height}, Format: ${image.format}, Rotation: $imageRotation, SensorOrientation: ${camera.sensorOrientation}',
    );

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: imageSize,
        rotation: imageRotation,
        format: inputImageFormat,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  Future<void> _capture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      debugPrint('Camera not ready for capture');
      return;
    }

    try {
      debugPrint('Starting capture process...');

      // Stop image stream before capture
      await _controller!.stopImageStream();
      debugPrint('Image stream stopped');

      // Add a small delay to ensure stream is fully stopped
      await Future.delayed(const Duration(milliseconds: 100));

      debugPrint('Taking picture...');
      final xfile = await _controller!.takePicture();
      debugPrint('Image captured successfully: ${xfile.path}');
      final file = File(xfile.path);

      if (mounted) {
        Navigator.pop(context, file);
      }
    } catch (e) {
      debugPrint('Capture error type: ${e.runtimeType}');
      debugPrint('Capture error message: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Capture failed: ${e.toString().substring(0, 50)}'),
          ),
        );
      }
      // Resume stream on error
      _startFaceDetection();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isReady || _controller == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final canCapture = isFaceDetected && areEyesOpen;

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_controller!),

          Container(color: Colors.black.withOpacity(0.2)),

          Center(
            child: Container(
              width: 260,
              height: 340,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                border: Border.all(
                  color: canCapture ? Colors.green : Colors.red,
                  width: 4,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Icon(
                  canCapture ? Icons.check_circle : Icons.error,
                  color: canCapture ? Colors.green : Colors.red,
                  size: 30,
                ),
                const SizedBox(height: 8),
                Text(
                  canCapture
                      ? "Perfect! Ready to capture"
                      : "Keep your face inside frame & open eyes",
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: canCapture ? _capture : null,
                child: const Text("Capture"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

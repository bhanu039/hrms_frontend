import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class FaceCaptureView extends StatefulWidget {
  const FaceCaptureView({super.key});

  @override
  State<FaceCaptureView> createState() => _FaceCaptureViewState();
}

class _FaceCaptureViewState extends State<FaceCaptureView> {
  CameraController? _controller;
  bool isReady = false;
  bool isFaceDetected = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    print("this is face ditection");
    _init();
  }

  Future<void> _init() async {
    await _start();
    if (isReady) {
      _mockFaceDetection();
    }
  }

  Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.status;

    if (status.isGranted) {
      return true;
    }

    status = await Permission.camera.request();

    return status.isGranted;
  }

  Future<void> _start() async {
    setState(() {
      errorMessage = null;
    });

    print("STEP 1: Requesting permission");

    final granted = await requestCameraPermission();

    print("STEP 2: Permission granted = $granted");

    if (!granted) {
      print("Permission denied");
      setState(() {
        errorMessage = "Camera permission is required to use this feature.";
      });
      return;
    }

    try {
      await _initCamera();
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = "Unable to open the camera. $e";
        });
      }
      debugPrint("Camera initialization error: $e");
    }
  }

  Future<void> _initCamera() async {
    print("STEP 3: Getting cameras");

    try {
      final cameras = await availableCameras();

      print("STEP 4: Cameras found = ${cameras.length}");

      if (cameras.isEmpty) {
        throw Exception("No cameras found on this device.");
      }

      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();

      if (!mounted) return;

      setState(() {
        isReady = true;
      });
    } catch (e) {
      debugPrint("Error initializing camera: $e");
      rethrow;
    }
  }

  void _mockFaceDetection() {
    // ⚠️ FOR TESTING ONLY - Remove this in production
    // This simulates face detection for testing purposes
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        isFaceDetected = true;
      });
    });
  }

  Future<void> _capture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    final file = await _controller!.takePicture();

    // ✅ RETURN FILE TO PREVIOUS SCREEN
    Navigator.pop(context, File(file.path));
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Camera error')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 20),
                Text(
                  errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: _init, child: const Text('Retry')),
              ],
            ),
          ),
        ),
      );
    }

    if (!isReady || _controller == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          /// CAMERA
          CameraPreview(_controller!),

          /// OVERLAY
          Container(color: Colors.black.withOpacity(0.2)),

          /// FACE FRAME
          Center(
            child: Container(
              width: 260,
              height: 340,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                border: Border.all(
                  color: isFaceDetected ? Colors.green : Colors.red,
                  width: 4,
                ),
              ),
            ),
          ),

          /// CLOSE
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const CircleAvatar(
                backgroundColor: Colors.black45,
                child: Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),

          /// STATUS
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Icon(
                  isFaceDetected ? Icons.check_circle : Icons.error,
                  color: isFaceDetected ? Colors.green : Colors.red,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Place your face inside the frame",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          /// CAPTURE BUTTON
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: isFaceDetected ? _capture : null,
                child: const Text("Capture"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

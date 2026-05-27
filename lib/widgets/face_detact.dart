import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceCaptureWidget extends StatefulWidget {
  final Function(File? image) onCaptured;

  const FaceCaptureWidget({super.key, required this.onCaptured});

  @override
  State<FaceCaptureWidget> createState() => _FaceCaptureWidgetState();
}

class _FaceCaptureWidgetState extends State<FaceCaptureWidget> {
  late CameraController controller;

  bool isReady = false;
  bool isCapturing = false;

  final faceDetector = FaceDetector(
    options: FaceDetectorOptions(enableContours: false, enableLandmarks: false),
  );

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await controller.initialize();

    if (mounted) {
      setState(() {
        isReady = true;
      });
    }
  }

  Future<File?> capture() async {
    try {
      final picture = await controller.takePicture();

      final inputImage = InputImage.fromFilePath(picture.path);

      final faces = await faceDetector.processImage(inputImage);

      if (faces.isNotEmpty) {
        return File(picture.path);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Capture Error: $e");
      return null;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CameraPreview(controller),

          // FACE GUIDE BOX
          Center(
            child: Container(
              width: 250,
              height: 320,

              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 4),

                borderRadius: BorderRadius.circular(500),
              ),
            ),
          ),

          // BUTTON
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: FloatingActionButton(
                onPressed: isCapturing
                    ? null
                    : () async {
                        setState(() {
                          isCapturing = true;
                        });

                        File? image = await capture();

                        setState(() {
                          isCapturing = false;
                        });

                        // ✅ RETURN IMAGE OR NULL
                        widget.onCaptured(image);

                        Navigator.pop(context);
                      },

                child: isCapturing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Icon(Icons.camera_alt),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

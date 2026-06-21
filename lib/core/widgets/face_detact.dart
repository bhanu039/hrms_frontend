import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceCaptureView extends StatefulWidget {
  const FaceCaptureView({super.key});

  @override
  State<FaceCaptureView> createState() => _FaceCaptureViewState();
}

class _FaceCaptureViewState extends State<FaceCaptureView> {
  CameraController? _cameraController;
  CameraDescription? _camera;
  late FaceDetector _faceDetector;

  bool _isInitialized = false;
  bool _isProcessing = false;

  bool _faceDetected = false;
  bool _eyesOpen = false;
  String? _statusMessage;

  static const _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  @override
  void initState() {
    super.initState();
    _initializeFaceDetector();
    _initializeCamera();
  }

  void _initializeFaceDetector() {
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        enableLandmarks: true,
        performanceMode: FaceDetectorMode.accurate,
      ),
    );
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        _setStatus('No camera found on this device');
        return;
      }

      final frontCamera = cameras.firstWhere(
        (e) => e.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      _camera = frontCamera;

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );

      await _cameraController!.initialize();

      if (!mounted) return;
      setState(() {
        _isInitialized = true;
        _statusMessage = null;
      });

      _startDetection();
    } catch (e) {
      debugPrint('Camera initialization error: $e');
      _setStatus('Unable to start camera');
    }
  }

  void _startDetection() {
    _cameraController?.startImageStream((CameraImage image) async {
      if (_isProcessing || !mounted) return;

      _isProcessing = true;

      try {
        final inputImage = _inputImageFromCameraImage(image);
        if (inputImage == null) {
          _setStatus('Unsupported camera image format');
          return;
        }

        final faces = await _faceDetector.processImage(inputImage);

        if (faces.isNotEmpty) {
          final face = faces.first;

          final left = face.leftEyeOpenProbability ?? 0.0;

          final right = face.rightEyeOpenProbability ?? 0.0;

          final eyesOpen = left > 0.7 && right > 0.7;

          if (mounted) {
            setState(() {
              _faceDetected = true;
              _eyesOpen = eyesOpen;
              _statusMessage = null;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _faceDetected = false;
              _eyesOpen = false;
            });
          }
        }
      } catch (e) {
        debugPrint('Face detection error: $e');
        _setStatus('Face detection is not available right now');
      } finally {
        _isProcessing = false;
      }
    });
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    final camera = _camera;
    final controller = _cameraController;
    if (camera == null || controller == null) return null;

    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;

    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[controller.value.deviceOrientation];
      if (rotationCompensation == null) return null;

      if (camera.lensDirection == CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }

      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }

    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    final isSupportedFormat =
        (Platform.isAndroid && format == InputImageFormat.nv21) ||
        (Platform.isIOS && format == InputImageFormat.bgra8888);

    if (format == null || !isSupportedFormat || image.planes.length != 1) {
      debugPrint(
        'Unsupported image format: ${image.format.raw}, '
        'planes: ${image.planes.length}',
      );
      return null;
    }

    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  void _setStatus(String message) {
    if (!mounted) return;
    if (_statusMessage == message) return;
    setState(() {
      _statusMessage = message;
    });
  }

  Future<void> _captureImage() async {
    debugPrint("CAPTURE BUTTON CLICKED");

    try {
      final controller = _cameraController;
      if (controller == null || !controller.value.isInitialized) {
        _setStatus('Camera is not ready');
        return;
      }

      debugPrint("Stopping stream");

      if (controller.value.isStreamingImages) {
        await controller.stopImageStream();
      }

      debugPrint("Taking picture");

      final XFile file = await controller.takePicture();

      debugPrint("IMAGE PATH = ${file.path}");

      await controller.dispose();
      _cameraController = null;
      _isInitialized = false;

      if (mounted) {
        Navigator.pop(context, File(file.path));
      }
    } catch (e, s) {
      debugPrint("CAPTURE ERROR = $e");
      debugPrintStack(stackTrace: s);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canCapture = _faceDetected && _eyesOpen;

    if (!_isInitialized || _cameraController == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: _statusMessage == null
              ? const CircularProgressIndicator()
              : Text(
                  _statusMessage!,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CameraPreview(_cameraController!),

          Container(color: Colors.black.withValues(alpha: 0.25)),

          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 280,
              height: 360,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                border: Border.all(
                  color: canCapture ? Colors.greenAccent : Colors.redAccent,
                  width: 5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: canCapture
                        ? Colors.greenAccent.withValues(alpha: 0.5)
                        : Colors.redAccent.withValues(alpha: 0.5),
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 70,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        _faceDetected ? Icons.check_circle : Icons.cancel,
                        color: _faceDetected ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Face Detected",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        _eyesOpen ? Icons.visibility : Icons.visibility_off,
                        color: _eyesOpen ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Eyes Open",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 140,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                _statusMessage ??
                    (canCapture
                        ? "Perfect! Ready to Capture"
                        : "Align your face and keep eyes open"),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: canCapture ? _captureImage : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 85,
                  height: 85,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: canCapture ? Colors.green : Colors.grey,
                    boxShadow: [
                      BoxShadow(
                        color: (canCapture ? Colors.green : Colors.grey)
                            .withValues(alpha: 0.5),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

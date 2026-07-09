import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class FaceCaptureView extends StatefulWidget {
  const FaceCaptureView({super.key});

  @override
  State<FaceCaptureView> createState() => _FaceCaptureViewState();
}

class _FaceCaptureViewState extends State<FaceCaptureView>
    with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  CameraDescription? _camera;
  late FaceDetector _faceDetector;
  late AnimationController _pulseController;
  OverlayEntry? _overlayEntry;

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
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _initializeFaceDetector();
    _initializeCamera();

    // Inject the camera UI directly onto the global overlay layer after frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) => _showGlobalOverlay());
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
      _overlayEntry?.markNeedsBuild(); // Refresh global overlay once ready
    } catch (e) {
      _setStatus('Unable to start camera');
    }
  }

  void _startDetection() {
    _cameraController?.startImageStream((CameraImage image) async {
      if (_isProcessing || !mounted) return;
      _isProcessing = true;

      try {
        final inputImage = _inputImageFromCameraImage(image);
        if (inputImage == null) return;

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
            });
            _overlayEntry?.markNeedsBuild();
          }
        } else {
          if (mounted) {
            setState(() {
              _faceDetected = false;
              _eyesOpen = false;
            });
            _overlayEntry?.markNeedsBuild();
          }
        }
      } catch (_) {
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

      rotationCompensation = camera.lensDirection == CameraLensDirection.front
          ? (sensorOrientation + rotationCompensation) % 360
          : (sensorOrientation - rotationCompensation + 360) % 360;

      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }

    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;

    // Combine planes for multi-plane formats (common on Android YUV)
    final allBytes = WriteBuffer();
    for (final plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final bytesPerRow = image.planes.isNotEmpty
        ? image.planes.first.bytesPerRow
        : 0;

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: bytesPerRow,
      ),
    );
  }

  void _setStatus(String message) {
    if (!mounted) return;
    setState(() => _statusMessage = message);
    _overlayEntry?.markNeedsBuild();
  }

  void _showGlobalOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: AppColors.black,
        child: StatefulBuilder(
          builder: (context, setOverlayState) {
            final bool canCapture = _faceDetected && _eyesOpen;

            if (!_isInitialized ||
                _cameraController == null ||
                !_cameraController!.value.isInitialized) {
              return Center(
                child: _statusMessage == null
                    ?  CircularProgressIndicator(
                        color: AppColors.red,
                      )
                    : Text(
                        _statusMessage!,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                        ),
                      ),
              );
            }

            return Stack(
              children: [
                Positioned.fill(child: CameraPreview(_cameraController!)),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.black.withValues(alpha: 0.5),
                          AppColors.transparent,
                          AppColors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 12,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColors.white,
                        ),
                        onPressed: _closeAndExit,
                      ),
                      const Text(
                        "Face Verification",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Center(
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      final statusColor = canCapture
                          ? AppColors.  successColor
                          : AppColors.danger;
                      return Container(
                        width: 400,
                        height: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(180),
                          border: Border.all(color: statusColor, width: 3.5),
                          boxShadow: [
                            BoxShadow(
                              color: statusColor.withValues(alpha: 0.3),
                              blurRadius: 12 + (_pulseController.value * 8),
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 140,
                  left: 24,
                  right: 24,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.black.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _statusMessage ??
                              (canCapture
                                  ? "Verification Ready"
                                  : !_faceDetected
                                  ? "Position Face Inside Oval"
                                  : "Please Open Your Eyes"),
                          style: TextStyle(
                            color: canCapture
                                ? AppColors.emeraldLight
                                : AppColors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildStatusIndicator("Face Found", _faceDetected),
                            const SizedBox(width: 24),
                            _buildStatusIndicator("Eyes Open", _eyesOpen),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: canCapture ? _captureImage : null,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: canCapture
                                ? AppColors.white
                                : AppColors.grey.shade600,
                            width: 4,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: canCapture
                              ? AppColors.successColor
                              : AppColors.grey.shade900,
                          child: Icon(
                            Icons.face_retouching_natural,
                            color: canCapture
                                ? AppColors.white
                                : AppColors.grey.shade600,
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  Future<void> _captureImage() async {
    try {
      if (_cameraController == null ||
          !_cameraController!.value.isInitialized) {
        return;
      }
      if (_cameraController!.value.isStreamingImages) {
        await _cameraController!.stopImageStream();
      }
      final XFile file = await _cameraController!.takePicture();
      final File imageFile = File(file.path);
      _removeOverlay();
      if (mounted) {
        Navigator.pop(context, imageFile);
      }
    } catch (e) {
      // ignore: avoid_print
      print('Face capture failed: $e');
    }
  }

  void _closeAndExit() {
    _cameraController?.stopImageStream().catchError((_) {});
    _removeOverlay();
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget _buildStatusIndicator(String label, bool isSuccess) {
    final color = isSuccess ? AppColors.emeraldLight : AppColors.white38;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isSuccess
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          color: color,
          size: 16,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    _cameraController?.dispose();
    _faceDetector.close();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Return an empty canvas widget while the root global window handles layout painting
    return const Scaffold(
      backgroundColor: AppColors.black,
      body: SizedBox.shrink(),
    );
  }
}

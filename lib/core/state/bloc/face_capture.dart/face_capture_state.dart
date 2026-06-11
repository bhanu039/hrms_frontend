import 'package:camera/camera.dart';
import 'dart:io';

class FaceCaptureState {
  final bool isLoading;
  final bool isCameraReady;
  final bool isFaceDetected;
  final bool isInsideFrame;
  final bool isCapturing;
  final File? image;
  final CameraController? controller; // ✅ ADD THIS

  const FaceCaptureState({
    this.isLoading = false,
    this.isCameraReady = false,
    this.isFaceDetected = false,
    this.isInsideFrame = false,
    this.isCapturing = false,
    this.image,
    this.controller,
  });

  FaceCaptureState copyWith({
    bool? isLoading,
    bool? isCameraReady,
    bool? isFaceDetected,
    bool? isInsideFrame,
    bool? isCapturing,
    File? image,
    CameraController? controller,
  }) {
    return FaceCaptureState(
      isLoading: isLoading ?? this.isLoading,
      isCameraReady: isCameraReady ?? this.isCameraReady,
      isFaceDetected: isFaceDetected ?? this.isFaceDetected,
      isInsideFrame: isInsideFrame ?? this.isInsideFrame,
      isCapturing: isCapturing ?? this.isCapturing,
      image: image ?? this.image,
      controller: controller ?? this.controller,
    );
  }

  bool get canCapture =>
      isCameraReady && isFaceDetected && !isCapturing;

  @override
  List<Object?> get props => [
        isLoading,
        isCameraReady,
        isFaceDetected,
        isInsideFrame,
        isCapturing,
        image,
        controller, // ✅ IMPORTANT
      ];
}
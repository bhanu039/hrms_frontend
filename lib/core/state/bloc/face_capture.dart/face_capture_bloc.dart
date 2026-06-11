import 'dart:io';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'face_capture_event.dart';
import 'face_capture_state.dart';

class FaceCaptureBloc extends Bloc<FaceCaptureEvent, FaceCaptureState> {
  CameraController? controller;
  late FaceDetector faceDetector;

  bool _isProcessing = false;

  FaceCaptureBloc() : super(const FaceCaptureState()) {
    on<InitCamera>(_onInitCamera);
    on<ProcessImage>(_onProcessImage);
    on<CaptureFace>(_onCaptureFace);
  }

  /// 📷 INIT CAMERA + START STREAM
  Future<void> _onInitCamera(
      InitCamera event, Emitter<FaceCaptureState> emit) async {
    emit(state.copyWith(isLoading: true));

    final cameras = await availableCameras();

    final frontCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
    );

    controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await controller!.initialize();

    /// 🧠 face detector
    faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: false,
        enableLandmarks: false,
        performanceMode: FaceDetectorMode.fast,
      ),
    );

    emit(state.copyWith(
      isLoading: false,
      isCameraReady: true,
    ));

    /// 🚀 LIVE STREAM START
    controller!.startImageStream((image) {
      if (_isProcessing) return;
      _isProcessing = true;

      add(ProcessImage(image));
    });
  }

  /// 🧠 PROCESS FRAME (FACE DETECTION)
  Future<void> _onProcessImage(
      ProcessImage event, Emitter<FaceCaptureState> emit) async {
    try {
     final inputImage = InputImage.fromBytes(
  bytes: event.image.planes[0].bytes,
  metadata: InputImageMetadata(
    size: Size(
      event.image.width.toDouble(),
      event.image.height.toDouble(),
    ),
    rotation: InputImageRotation.rotation0deg,
    format: InputImageFormat.nv21,
    bytesPerRow: event.image.planes[0].bytesPerRow,
  ),
);

      final faces = await faceDetector.processImage(inputImage);

      final detected = faces.isNotEmpty;

      emit(state.copyWith(
        isFaceDetected: detected,
        isInsideFrame: detected,
      ));

      /// 🚀 AUTO CAPTURE CONDITION
      if (state.canCapture && detected) {
        add(CaptureFace());
      }
    } catch (e) {
      // ignore errors
    }

    _isProcessing = false;
  }

  /// 📸 CAPTURE IMAGE
  Future<void> _onCaptureFace(
      CaptureFace event, Emitter<FaceCaptureState> emit) async {
    try {
      emit(state.copyWith(isCapturing: true));

      final file = await controller!.takePicture();

      await controller!.stopImageStream();

      emit(state.copyWith(
        isCapturing: false,
        image: File(file.path),
      ));
    } catch (e) {
      emit(state.copyWith(isCapturing: false));
    }
  }

  @override
  Future<void> close() {
    controller?.dispose();
    faceDetector.close();
    return super.close();
  }
}
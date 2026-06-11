

abstract class FaceCaptureEvent  {
  const FaceCaptureEvent();

  @override
  List<Object?> get props => [];
}

/// 🚀 initialize camera
class InitCamera extends FaceCaptureEvent {}

/// 📸 process live camera frame
class ProcessImage extends FaceCaptureEvent {
  final dynamic image;
  const ProcessImage(this.image);
}

/// 📷 capture final image
class CaptureFace extends FaceCaptureEvent {}
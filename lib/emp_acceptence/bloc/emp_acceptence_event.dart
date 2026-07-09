abstract class OnboardingReviewEvent {}

class LoadOnboardingDetails extends OnboardingReviewEvent {
  final String employeeId;
  final String screen;
  LoadOnboardingDetails(this.employeeId,this.screen);
}

class UpdateDocumentStatusEvent extends OnboardingReviewEvent {
  final String docId;
  final String status; // "APPROVED" or "REJECTED"
  final String? remarks;

  UpdateDocumentStatusEvent({
    required this.docId,
    required this.status,
    this.remarks,
  });
}

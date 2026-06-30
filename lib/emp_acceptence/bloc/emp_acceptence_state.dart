import '../data/emp_acceptence_modal.dart';

enum ReviewStatus { initial, loading, success, failure }

class OnboardingReviewState {
  final ReviewStatus status;
  final EmployeeReviewModel? employee;
  final String message;

  OnboardingReviewState({
    this.status = ReviewStatus.initial,
    this.employee,
    this.message = '',
  });

  OnboardingReviewState copyWith({
    ReviewStatus? status,
    EmployeeReviewModel? employee,
    String? message,
  }) {
    return OnboardingReviewState(
      status: status ?? this.status,
      employee: employee ?? this.employee,
      message: message ?? this.message,
    );
  }
}

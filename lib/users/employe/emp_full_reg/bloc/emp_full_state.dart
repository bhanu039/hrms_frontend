import '../data/models/emp_fullreg.dart';

class EmpFullRegState {
  final int currentStep;
  final bool isLoading;
  final String? error;
  final bool isActive;

  final bool? success;

  final EmpFullRegModel model;

  EmpFullRegState({
    this.currentStep = 0,
    this.isLoading = false,
    required this.model,
    this.error,
    this.success,
    this.isActive = false,
  });

  EmpFullRegState copyWith({
    int? currentStep,
    bool? isLoading,
    EmpFullRegModel? model,
    String? error,
    bool? isActive,
    bool?success,
  }) {
    return EmpFullRegState(
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      model: model ?? this.model,
      error: error,
      success:success,

      isActive: isActive ?? this.isActive,
    );
  }
}

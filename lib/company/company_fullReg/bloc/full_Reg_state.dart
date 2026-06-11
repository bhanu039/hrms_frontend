import '../data/modal/full_Reg_modal.dart';

class FullRegState {
  final int currentStep;
  final bool isLoading;

  final FullRegModel model;

  

  FullRegState({
    this.currentStep = 0,
    this.isLoading = false,
    required this.model,
  });

  FullRegState copyWith({
    int? currentStep,
    bool? isLoading,
    FullRegModel? model,
  }) {
    return FullRegState(
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      model: model ?? this.model,
    );
  }
}

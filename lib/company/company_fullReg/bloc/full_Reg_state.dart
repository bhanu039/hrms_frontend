
import '../data/modal/full_Reg_modal.dart';

class FullRegState  {
  final FullRegModel model;
  final bool loading;
  final bool success;
  final String? error;

  const FullRegState({
    required this.model,
    this.loading = false,
    this.success = false,
    this.error,
  });

  FullRegState copyWith({
    FullRegModel? model,
    bool? loading,
    bool? success,
    String? error,
  }) {
    return FullRegState(
      model: model ?? this.model,
      loading: loading ?? this.loading,
      success: success ?? this.success,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        model,
        loading,
        success,
        error,
      ];
}
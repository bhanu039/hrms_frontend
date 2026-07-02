




import '../data/industry_type_modal.dart';

enum IndustryTypeStatus { initial, loading, success, failure }

class IndustryTypeState {
  final IndustryTypeStatus status;
  final List<IndustryTypeModel>? industryTypes;
  final bool isActionLoading;
  final String? alertMessage;
  final bool isActionSuccess;

  IndustryTypeState({
    required this.status, 
    required this.industryTypes, 
    required this.isActionLoading, 
    this.alertMessage, 
    required this.isActionSuccess
  });

  factory IndustryTypeState.initial() => IndustryTypeState(
        status: IndustryTypeStatus.initial, 
        industryTypes: [], 
        isActionLoading: false, 
        alertMessage: null, 
        isActionSuccess: false
      );

  IndustryTypeState copyWith({
    IndustryTypeStatus? status, 
    List<IndustryTypeModel>? industryTypes, 
    bool? isActionLoading, 
    String? alertMessage, 
    bool? isActionSuccess
  }) {
    return IndustryTypeState(
      status: status ?? this.status,
      industryTypes: industryTypes ?? this.industryTypes,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      alertMessage: alertMessage,
      isActionSuccess: isActionSuccess ?? this.isActionSuccess,
    );
  }
}
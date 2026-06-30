enum EmpProfileStatus { initial, loading, loaded, failure }

class EmpProfileState {
  const EmpProfileState({
    this.status = EmpProfileStatus.initial,
    this.isLoadingDetails = false,
    this.updatingSection = '',
    this.employeeId = '',
    this.basic = const {},
    this.personal = const {},
    this.professional = const {},
    this.financial = const {},
    this.documents = const [],
    this.message = '',
    this.successMessage = '',
  });

  final EmpProfileStatus status;
  final bool isLoadingDetails;
  final String updatingSection;
  final String employeeId;
  final Map<String, dynamic> basic;
  final Map<String, dynamic> personal;
  final Map<String, dynamic> professional;
  final Map<String, dynamic> financial;
  final List<Map<String, dynamic>> documents;
  final String message;
  final String successMessage;

  bool get hasBasic => basic.isNotEmpty;
  bool get isUpdating => updatingSection.isNotEmpty;

  EmpProfileState copyWith({
    EmpProfileStatus? status,
    bool? isLoadingDetails,
    String? updatingSection,
    String? employeeId,
    Map<String, dynamic>? basic,
    Map<String, dynamic>? personal,
    Map<String, dynamic>? professional,
    Map<String, dynamic>? financial,
    List<Map<String, dynamic>>? documents,
    String? message,
    String? successMessage,
  }) {
    return EmpProfileState(
      status: status ?? this.status,
      isLoadingDetails: isLoadingDetails ?? this.isLoadingDetails,
      updatingSection: updatingSection ?? this.updatingSection,
      employeeId: employeeId ?? this.employeeId,
      basic: basic ?? this.basic,
      personal: personal ?? this.personal,
      professional: professional ?? this.professional,
      financial: financial ?? this.financial,
      documents: documents ?? this.documents,
      message: message ?? this.message,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}


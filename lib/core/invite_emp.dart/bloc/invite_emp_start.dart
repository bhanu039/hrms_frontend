class InviteEmpState {
  final bool loading;
  final bool submitting;

  final List<Map<String, dynamic>> departments;
  final List<Map<String, dynamic>> designations;
  final String? workModel;

  final String? selectedDepartmentId;
  final String? selectedDesignationId;
  final int? expectedOfficeDays;

  final bool isNewHire;
  final bool success;
  final String? error;

  InviteEmpState({
    this.loading = false,
    this.submitting = false,
    this.departments = const [],
    this.designations = const [],
    this.selectedDepartmentId,
    this.selectedDesignationId,
  
    this.expectedOfficeDays,
    this.workModel,
    this.isNewHire = true,
    this.success = false,
    this.error,
  });

  InviteEmpState copyWith({
    bool? loading,
    bool? submitting,
    List<Map<String, dynamic>>? departments,
    List<Map<String, dynamic>>? designations,
    String? selectedDepartmentId,
    String? selectedDesignationId,
    int?expectedOfficeDays,
    String? workModel,
    bool? isNewHire,
    bool? success,
    String? error,
  }) {
    return InviteEmpState(
      loading: loading ?? this.loading,
      submitting: submitting ?? this.submitting,
      departments: departments ?? this.departments,
      designations: designations ?? this.designations,
      selectedDepartmentId: selectedDepartmentId ?? this.selectedDepartmentId,
      selectedDesignationId:selectedDesignationId ?? this.selectedDesignationId,
      expectedOfficeDays:expectedOfficeDays??this.expectedOfficeDays,
      workModel: workModel ?? this.workModel,
      isNewHire: isNewHire ?? this.isNewHire,
      success: success ?? this.success,
      error: error,
    );
  }
}

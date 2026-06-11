class AddCompanyState {
  final String name;
  final String email;
  final String ownerName;
  final String ownerEmail;
  final String location;
  final String? industryId;

  final List<Map<String, dynamic>> industries;

  final bool loading;
  final bool submitting;
  final String? error;
  final bool success;

  AddCompanyState({
    this.name = "",
    this.email = "",
    this.ownerName = "",
    this.ownerEmail = "",
    this.location = "",
    this.industryId,
    this.industries = const [],
    this.loading = false,
    this.submitting = false,
    this.error,
    this.success = false,
  });

  AddCompanyState copyWith({
    String? name,
    String? email,
    String? ownerName,
    String? ownerEmail,
    String? location,
    String? industryId,
    List<Map<String, dynamic>>? industries,
    bool? loading,
    bool? submitting,
    String? error,
    bool? success,
  }) {
    return AddCompanyState(
      name: name ?? this.name,
      email: email ?? this.email,
      ownerName: ownerName ?? this.ownerName,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      location: location ?? this.location,
      industryId: industryId ?? this.industryId,
      industries: industries ?? this.industries,
      loading: loading ?? this.loading,
      submitting: submitting ?? this.submitting,
      error: error,
      success: success ?? this.success,
    );
  }
}
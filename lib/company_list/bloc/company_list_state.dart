// ==========================
// STATES
// ==========================

abstract class CompaniesState {}

class CompaniesInitial extends CompaniesState {}

class CompaniesLoading extends CompaniesState {}

class CompaniesLoaded extends CompaniesState {
  final List companies;
  final List filteredCompanies;
  final String searchQuery;

  CompaniesLoaded({
    required this.companies,
    required this.filteredCompanies,
    this.searchQuery = '',
  });
}

class DeletedCompaniesActionSuccess extends CompaniesState {
  final String message;
  DeletedCompaniesActionSuccess(this.message);
}

class DeletedCompaniesError extends CompaniesState {
  final String error;
  DeletedCompaniesError(this.error);
}

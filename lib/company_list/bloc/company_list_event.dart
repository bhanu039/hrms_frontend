// ==========================
// EVENTS
// ==========================

abstract class CompaniesEvent {}

class FetchCompanies extends CompaniesEvent {
  final String data;
  FetchCompanies({ required this.data});
}

class SearchCompanies extends CompaniesEvent {
  final String query;
  SearchCompanies(this.query);
}

class RestoreCompanyEvent extends CompaniesEvent {
 
  final String companyId;
  RestoreCompanyEvent(     this.companyId);
}

class DeleteCompanyPermanentEvent extends CompaniesEvent {
  final String status;
  final String companyId;
  DeleteCompanyPermanentEvent(this.status, this.companyId);
}


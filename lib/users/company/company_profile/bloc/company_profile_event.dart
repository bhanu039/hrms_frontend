part of 'company_profile_bloc.dart';

abstract class CompanyProfileEvent {
  const CompanyProfileEvent();

  @override
  List<Object?> get props => [];
}

class FetchCompanyProfileEvent extends CompanyProfileEvent {
  final String? id;
  const FetchCompanyProfileEvent(this.id);

  @override
  List<Object?> get props => [];
}

class UpdateCompanyProfileEvent extends CompanyProfileEvent {
  final Map<String, dynamic> data;
  final String? logoPath;
  final String? signaturePath;

  const UpdateCompanyProfileEvent({
    required this.data,
    this.logoPath,
    this.signaturePath,
  });

  @override
  List<Object?> get props => [data, logoPath, signaturePath];
}

class UploadCompanyDocumentEvent extends CompanyProfileEvent {
  final String filePath;
  final String documentType;

  const UploadCompanyDocumentEvent({
    required this.filePath,
    required this.documentType,
  });

  @override
  List<Object?> get props => [filePath, documentType];
}

class FetchIndustryTypesEvent extends CompanyProfileEvent {
  const FetchIndustryTypesEvent();
}

class DeleteCompanyDocumentEvent extends CompanyProfileEvent {
  final String documentId;
  const DeleteCompanyDocumentEvent({required this.documentId});

  @override
  List<Object?> get props => [documentId];
}

class AproveCompanyEvent extends CompanyProfileEvent {
  final String companyid;
  const AproveCompanyEvent(this.companyid);
}

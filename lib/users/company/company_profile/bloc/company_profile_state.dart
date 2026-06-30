part of 'company_profile_bloc.dart';

abstract class CompanyProfileState {
  const CompanyProfileState();

  @override
  List<Object?> get props => [];
}

class CompanyProfileInitial extends CompanyProfileState {
  const CompanyProfileInitial();
}

class CompanyProfileLoading extends CompanyProfileState {
  const CompanyProfileLoading();
}

class CompanyProfileLoaded extends CompanyProfileState {
  final CompanyProfileData profile;
  final List<IndustryType> industryTypes;

  const CompanyProfileLoaded({
    required this.profile,
    this.industryTypes = const [],
  });

  @override
  List<Object?> get props => [profile, industryTypes];

  CompanyProfileLoaded copyWith({
    CompanyProfileData? profile,
    List<IndustryType>? industryTypes,
  }) {
    return CompanyProfileLoaded(
      profile: profile ?? this.profile,
      industryTypes: industryTypes ?? this.industryTypes,
    );
  }
}

class CompanyProfileUpdating extends CompanyProfileState {
  const CompanyProfileUpdating();
}

class CompanyProfileUpdated extends CompanyProfileState {
  final String message;
  const CompanyProfileUpdated({this.message = "Profile updated successfully"});

  @override
  List<Object?> get props => [message];
}

class CompanyDocumentUploading extends CompanyProfileState {
  const CompanyDocumentUploading();
}

class CompanyDocumentUploaded extends CompanyProfileState {
  final String message;
  const CompanyDocumentUploaded({
    this.message = "Document uploaded successfully",
  });

  @override
  List<Object?> get props => [message];
}

class CompanyProfileError extends CompanyProfileState {
  final String message;
  const CompanyProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}

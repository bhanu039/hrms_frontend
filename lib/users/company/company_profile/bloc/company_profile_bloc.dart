import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/api_service.dart';
import '../data/company_profile_modal.dart';

part 'company_profile_event.dart';
part 'company_profile_state.dart';

class CompanyProfileBloc
    extends Bloc<CompanyProfileEvent, CompanyProfileState> {
  final ApiService apiService;

  CompanyProfileBloc({required this.apiService})
    : super(const CompanyProfileInitial()) {
    on<FetchCompanyProfileEvent>(_onFetchProfile);
    on<UpdateCompanyProfileEvent>(_onUpdateProfile);
    on<UploadCompanyDocumentEvent>(_onUploadDocument);
    on<DeleteCompanyDocumentEvent>(_onDeleteDocument);
  }

  Future<void> _onFetchProfile(
    FetchCompanyProfileEvent event,
    Emitter<CompanyProfileState> emit,
  ) async {
    emit(const CompanyProfileLoading());
    try {
      final profile = await ApiService.getCompanyProfile();
      if (profile != null) {
        emit(CompanyProfileLoaded(profile: profile, industryTypes: const []));
      } else {
        emit(const CompanyProfileError(message: "Profile not found"));
      }
    } catch (e) {
      emit(CompanyProfileError(message: e.toString()));
    }
  }



  Future<void> _onUpdateProfile(
    UpdateCompanyProfileEvent event,
    Emitter<CompanyProfileState> emit,
  ) async {
    emit(const CompanyProfileUpdating());
    try {
      final updatedProfile = await ApiService.updateCompanyProfile(
        data: event.data,
        companyLogoPath: event.logoPath,
        signaturePath: event.signaturePath,
      );

      if (updatedProfile != null) {
        emit(const CompanyProfileUpdated());
        emit(
          CompanyProfileLoaded(
            profile: updatedProfile,
            industryTypes: (state as CompanyProfileLoaded).industryTypes,
          ),
        );
      } else {
        emit(const CompanyProfileError(message: "Failed to update profile"));
      }
    } catch (e) {
      emit(CompanyProfileError(message: e.toString()));
    }
  }

  Future<void> _onUploadDocument(
    UploadCompanyDocumentEvent event,
    Emitter<CompanyProfileState> emit,
  ) async {
    emit(const CompanyDocumentUploading());
    try {
      await ApiService.uploadCompanyDocument(
        companyId: (state as CompanyProfileLoaded).profile.id ?? 'current',
        filePath: event.filePath,
        documentType: event.documentType,
      );
      emit(const CompanyDocumentUploaded());
      // Refresh profile to get updated documents
      add(const FetchCompanyProfileEvent());
    } catch (e) {
      emit(CompanyProfileError(message: e.toString()));
    }
  }

  Future<void> _onDeleteDocument(
    DeleteCompanyDocumentEvent event,
    Emitter<CompanyProfileState> emit,
  ) async {
    try {
      // Call delete endpoint when available
      // await ApiService.deleteCompanyDocument(event.documentId);
      emit(const CompanyDocumentUploaded(message: "Document deleted"));
    } catch (e) {
      emit(CompanyProfileError(message: e.toString()));
    }
  }
}

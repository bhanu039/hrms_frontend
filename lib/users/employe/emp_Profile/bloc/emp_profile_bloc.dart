import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/sessionservice.dart';
import '../data/emp_profile_repository.dart';
import 'emp_profile_event.dart';
import 'emp_profile_state.dart';

class EmpProfileBloc extends Bloc<EmpProfileEvent, EmpProfileState> {
  EmpProfileBloc({EmpProfileRepository? repository})
    : repository = repository ?? EmpProfileRepository(),
      super(const EmpProfileState()) {
    on<LoadEmpProfile>(_loadProfile);
    on<RefreshEmpProfile>(_refreshProfile);
    on<UpdateEmpProfileSection>(_updateSection);
    on<UploadEmpProfileDocument>(_uploadDocument);
  }

  final EmpProfileRepository repository;

  Future<void> _loadProfile(
    LoadEmpProfile event,
    Emitter<EmpProfileState> emit,
  ) async {
    await _fetchProfile(event.employeeId, emit, keepCurrentData: false);
  }

  Future<void> _refreshProfile(
    RefreshEmpProfile event,
    Emitter<EmpProfileState> emit,
  ) async {
    await _fetchProfile(event.employeeId, emit, keepCurrentData: true);
  }

  Future<void> _fetchProfile(
    String? employeeId,
    Emitter<EmpProfileState> emit, {
    required bool keepCurrentData,
  }) async {
    try {
      // final id = (employeeId?.trim().isNotEmpty ?? false)
      //     ? employeeId!.trim()
      //     : (await SessionService.getID()) ?? '';

      // if (id.isEmpty) {
      //   emit(
      //     state.copyWith(
      //       status: EmpProfileStatus.failure,
      //       message: 'Employee id not found',
      //       isLoadingDetails: false,
      //     ),
      //   );
      //   return;
      // }

      // emit(
      //   keepCurrentData
      //       ? state.copyWith(
      //           status: EmpProfileStatus.loading,
      //           employeeId: id,
      //           message: '',
      //         )
      //       : EmpProfileState(status: EmpProfileStatus.loading, employeeId: id),
      // );

      final basic = await repository.fetchBasic();
      emit(
        state.copyWith(
          status: EmpProfileStatus.loaded,
          
          basic: basic,
          isLoadingDetails: true,
          message: '',
        ),
      );

      final details = await Future.wait([
        repository.fetchPersonal(),
        repository.fetchProfessional(),
        repository.fetchFinancial(),
        repository.fetchDocuments(),
      ]);

      emit(
        state.copyWith(
          status: EmpProfileStatus.loaded,
          isLoadingDetails: false,
          personal: details[0] as Map<String, dynamic>,
          professional: details[1] as Map<String, dynamic>,
          financial: details[2] as Map<String, dynamic>,
          documents: details[3] as List<Map<String, dynamic>>,
          message: '',
          successMessage: '',
        ),
      );
    } on DioException catch (error) {
      final errormsg =
          error.response?.statusMessage ?? "Failed to load Details";
      emit(
        state.copyWith(
          status: state.hasBasic
              ? EmpProfileStatus.loaded
              : EmpProfileStatus.failure,
          isLoadingDetails: false,
          message: errormsg,
        ),
      );
    }
  }

  Future<void> _updateSection(
    UpdateEmpProfileSection event,
    Emitter<EmpProfileState> emit,
  ) async {
    if (state.employeeId.isEmpty) {
      emit(state.copyWith(message: 'Employee id not found'));
      return;
    }

    try {
      emit(
        state.copyWith(
          updatingSection: event.section,
          message: '',
          successMessage: '',
        ),
      );

      switch (event.section) {
        case 'basic':
          final values = Map<String, dynamic>.from(event.values)
            ..remove('profilePhoto');
          await repository.updateBasic(
            employeeId: state.employeeId,
            values: values,
            profilePhoto: event.values['profilePhoto'],
          );
          emit(
            state.copyWith(
              basic: await repository.fetchBasic(),
              updatingSection: '',
              successMessage: 'Basic details updated',
            ),
          );
          break;
        case 'personal':
          await repository.updatePersonal(state.employeeId, event.values);
          emit(
            state.copyWith(
              personal: await repository.fetchPersonal(),
              updatingSection: '',
              successMessage: 'Personal details updated',
            ),
          );
          break;
        case 'professional':
          await repository.updateProfessional(state.employeeId, event.values);
          emit(
            state.copyWith(
              professional: await repository.fetchProfessional( ),
              updatingSection: '',
              successMessage: 'Professional details updated',
            ),
          );
          break;
        case 'financial':
          await repository.updateFinancial(state.employeeId, event.values);
          emit(
            state.copyWith(
              financial: await repository.fetchFinancial(),
              updatingSection: '',
              successMessage: 'Financial details updated',
            ),
          );
          break;
        default:
          emit(
            state.copyWith(
              updatingSection: '',
              message: 'Unsupported update section',
            ),
          );
      }
    } catch (error) {
      emit(
        state.copyWith(
          updatingSection: '',
          message: error.toString(),
          successMessage: '',
        ),
      );
    }
  }

  Future<void> _uploadDocument(
    UploadEmpProfileDocument event,
    Emitter<EmpProfileState> emit,
  ) async {
    if (state.employeeId.isEmpty) {
      emit(state.copyWith(message: 'Employee id not found'));
      return;
    }

    try {
      emit(
        state.copyWith(
          updatingSection: 'documents',
          message: '',
          successMessage: '',
        ),
      );

      await repository.uploadDocument(
        employeeId: state.employeeId,
        documentType: event.documentType,
        file: event.file,
      );

      emit(
        state.copyWith(
          documents: await repository.fetchDocuments(),
          updatingSection: '',
          successMessage: 'Document uploaded',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          updatingSection: '',
          message: error.toString(),
          successMessage: '',
        ),
      );
    }
  }
}

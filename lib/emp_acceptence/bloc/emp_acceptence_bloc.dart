import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/emp_acceptence_modal.dart';
import '../data/emp_acceptence_repo.dart';
import 'emp_acceptence_event.dart';
import 'emp_acceptence_state.dart';

class OnboardingReviewBloc
    extends Bloc<OnboardingReviewEvent, OnboardingReviewState> {
  final OnboardingRepository repository;

  OnboardingReviewBloc({required this.repository})
    : super(OnboardingReviewState()) {
    on<LoadOnboardingDetails>(_onLoadDetails);
    on<UpdateDocumentStatusEvent>(_onUpdateDocumentStatus);
  }

  /// ================= FETCH DETAILS DATA =================
  Future<void> _onLoadDetails(
    LoadOnboardingDetails event,
    Emitter<OnboardingReviewState> emit,
  ) async {
    emit(state.copyWith(status: ReviewStatus.loading));
    try {
      final Map<String, dynamic> response = await repository.getReviewData(
        event.employeeId,
        event.screen,
      );

      final dynamic rawData = response['data'];
      Map<String, dynamic> employeeMap = {};

      if (rawData is List) {
        if (rawData.isNotEmpty) {
          employeeMap = rawData.first as Map<String, dynamic>;
        } else {
          throw Exception('Employee list array payload arrived empty.');
        }
      } else if (rawData is Map<String, dynamic>) {
        employeeMap = rawData;
      }

      final employee = EmployeeReviewModel.fromJson(employeeMap);
      emit(state.copyWith(status: ReviewStatus.success, employee: employee));
    } on DioException catch (e) {
     final error = e.response?.statusMessage ?? "Failed to load profile";
      print("Fetch Error: $e");
      emit(
        state.copyWith(
          status: ReviewStatus.failure,
          message:error,
        ),
      );
    }
  }

  /// ================= UPDATE DOCUMENT APPROVAL LIFECYCLE =================
  Future<void> _onUpdateDocumentStatus(
    UpdateDocumentStatusEvent event,
    Emitter<OnboardingReviewState> emit,
  ) async {
    final currentEmployee = state.employee;
    if (currentEmployee == null) return;

    try {
      // 1. Fire network API modification call mutation
      await repository.updateDocumentStatus(
        documentId: event.docId,
        status: event.status,
        remarks: event.remarks ?? "",
      );

      // 2. Map updated verification flags across the local documents array cache safely
      final List<ReviewDocument> updatedDocs = currentEmployee.documents.map((
        doc,
      ) {
        return doc.id == event.docId
            ? ReviewDocument(
                id: doc.id,
                name: doc.name,
                fileUrl: doc.fileUrl,
                status: event.status,
              )
            : doc;
      }).toList();

      // 3. FIX: Safely parse and preserve model data parameters avoiding cast linter breakdowns
      emit(
        state.copyWith(
          employee: EmployeeReviewModel(
            id: currentEmployee.id,
            employeeCode: currentEmployee.employeeCode,
            firstName: currentEmployee.firstName,
            lastName: currentEmployee.lastName,
            status: currentEmployee.status,
            bgvStatus: currentEmployee.bgvStatus,
            joiningDate: currentEmployee.joiningDate,
            employmentType: currentEmployee.employmentType,
            workModel: currentEmployee.workModel,
            profilePhoto: currentEmployee.profilePhoto,
            department: currentEmployee.department,
            designation: currentEmployee.designation,
            education: List.from(currentEmployee.education),
            experience: List.from(currentEmployee.experience),
            documents: updatedDocs, // Your modified documents list
            // FIX: Added the missing required data objects from current state
            skills: currentEmployee.skills,
            bankDetails: currentEmployee.bankDetails,
            nominee: currentEmployee.nominee,
            compliance: currentEmployee.compliance,
          ),
        ),
      );
    } on DioException catch (e) {
     final error = e.response?.statusMessage ?? "Failed to load profile";
      print("Update Error: $e");
      emit(state.copyWith(message: error));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goexperts/core/invite_emp.dart/modal/invite_emp_repo.dart';

import 'invite_emp_event.dart';
import 'invite_emp_start.dart';


class InviteEmpBloc extends Bloc<InviteEmpEvent, InviteEmpState> {
  final InviteEmpRepo repository;

  InviteEmpBloc(this.repository) : super(InviteEmpState()) {
    on<LoadEmployeeInitialData>(_loadInitial);
    on<SelectDepartment>(_selectDepartment);
    on<SelectDesignation>(_selectDesignation);
    on<ToggleNewHire>(_toggleNewHire);
    on<SubmitEmployee>(_submitEmployee);
  }

  Future<void> _loadInitial(
    LoadEmployeeInitialData event,
    Emitter<InviteEmpState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    try {
      final res = await repository.getDepartments(event.companyId);

      emit(state.copyWith(
        loading: false,
        departments: List<Map<String, dynamic>>.from(res.data["data"]),
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _selectDepartment(
    SelectDepartment event,
    Emitter<InviteEmpState> emit,
  ) async {
    emit(state.copyWith(selectedDepartmentId: event.departmentId));

    try {
      final res = await repository.getDesignations(event.departmentId);

      emit(state.copyWith(
        designations: List<Map<String, dynamic>>.from(res.data["data"]),
        selectedDesignationId: null,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void _selectDesignation(
    SelectDesignation event,
    Emitter<InviteEmpState> emit,
  ) {
    emit(state.copyWith(selectedDesignationId: event.designationId));
  }

  void _toggleNewHire(
    ToggleNewHire event,
    Emitter<InviteEmpState> emit,
  ) {
    emit(state.copyWith(isNewHire: event.isNewHire));
  }

  Future<void> _submitEmployee(
    SubmitEmployee event,
    Emitter<InviteEmpState> emit,
  ) async {
    emit(state.copyWith(submitting: true, loading: true, success: false));

    try {

      final res = await repository.createEmployee(event.body);

      if (res.data["success"] == true) {
        emit(state.copyWith(submitting: false, loading: false, success: true));
      } else {
        emit(state.copyWith(submitting: false, loading: false, error: "Failed"));
      }
    } catch (e) {
      emit(state.copyWith(submitting: false, loading: false, error: e.toString()));
    }
  }
}
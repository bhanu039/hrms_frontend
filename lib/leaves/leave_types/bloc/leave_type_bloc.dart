import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/leave_type_repo.dart';
import 'leave_type_event.dart';
import 'leave_type_state.dart';

class LeaveTypeBloc extends Bloc<LeaveTypeEvent, LeaveTypeState> {
  final LeaveTypeRepository repository;

  LeaveTypeBloc({required this.repository}) : super(LeaveTypeState.initial()) {
    on<FetchLeaveTypesEvent>(_onFetchLeaveTypes);
    on<CreateLeaveTypeEvent>(_onCreateLeaveType);
    on<UpdateLeaveTypeEvent>(_onUpdateLeaveType);
    on<DeleteLeaveTypeEvent>(_onDeleteLeaveType);
  }

  Future<void> _onFetchLeaveTypes(FetchLeaveTypesEvent event, Emitter<LeaveTypeState> emit) async {
    emit(state.copyWith(status: LeaveTypeStatus.loading));
    try {
      final list = await repository.getAllLeaveTypes();
      emit(state.copyWith(status: LeaveTypeStatus.success, leaveTypes: list));
    } catch (e) {
      emit(state.copyWith(status: LeaveTypeStatus.failure, alertMessage: e.toString()));
    }
  }

  Future<void> _onCreateLeaveType(CreateLeaveTypeEvent event, Emitter<LeaveTypeState> emit) async {
    emit(state.copyWith(isActionLoading: true));
    try {
      await repository.createLeaveType(event.name, event.maxDays);
      final refreshedList = await repository.getAllLeaveTypes();
      emit(state.copyWith(isActionLoading: false, leaveTypes: refreshedList, isActionSuccess: true, alertMessage: "Leave type saved cleanly!"));
    } catch (e) {
      emit(state.copyWith(isActionLoading: false, isActionSuccess: false, alertMessage: e.toString()));
    }
  }

  Future<void> _onUpdateLeaveType(UpdateLeaveTypeEvent event, Emitter<LeaveTypeState> emit) async {
    emit(state.copyWith(isActionLoading: true));
    try {
      await repository.updateLeaveType(event.id, event.name, event.maxDays);
      final refreshedList = await repository.getAllLeaveTypes();
      emit(state.copyWith(isActionLoading: false, leaveTypes: refreshedList, isActionSuccess: true, alertMessage: "Configuration updated successfully!"));
    } catch (e) {
      emit(state.copyWith(isActionLoading: false, isActionSuccess: false, alertMessage: e.toString()));
    }
  }

  Future<void> _onDeleteLeaveType(DeleteLeaveTypeEvent event, Emitter<LeaveTypeState> emit) async {
    emit(state.copyWith(isActionLoading: true));
    try {
      await repository.deleteLeaveType(event.id);
      final updatedList = state.leaveTypes.where((type) => type.id != event.id).toList();
      emit(state.copyWith(isActionLoading: false, leaveTypes: updatedList, isActionSuccess: true, alertMessage: "Record dropped from server registry."));
    } catch (e) {
      emit(state.copyWith(isActionLoading: false, isActionSuccess: false, alertMessage: e.toString()));
    }
  }
}
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../leave_repo.dart';
import '../data/leaves_view_modal.dart';
import 'leaves_view_event.dart';
import 'package:goexperts/leaves/leaves_views/bloc/leaves_view_state.dart';

class LeavesViewBloc extends Bloc<LeaveViewEvent, LeavesViewState> {
  final LeaveRepository repository;

  LeavesViewBloc({required this.repository}) : super(LeavesViewState()) {
    on<GetLeaves>(_onGetLeaves);
    on<RefreshLeaves>(_onRefreshLeaves);
    on<ApproveLeave>(_onApproveLeave);
    on<RejectLeave>(_onRejectLeave);
    on<CancelLeave>(_onCancelLeave);
  }

  Future<void> _onGetLeaves(
    GetLeaves event,
    Emitter<LeavesViewState> emit,
  ) async {
    emit(state.copyWith(status: LeaveStatus.loading, clearError: true));

    try {
      final leaves = await repository.getLeaves(event.datatype);

      emit(state.copyWith(status: LeaveStatus.success, leaves: leaves));
    } catch (e) {
      print("DioException: ${e}");
      final errorMessage = "Failed to fetch leaves";
      emit(
        state.copyWith(status: LeaveStatus.failure, errorMessage: errorMessage),
      );
    }
  }

  Future<void> _onRefreshLeaves(
    RefreshLeaves event,
    Emitter<LeavesViewState> emit,
  ) async {
    try {
      final leaves = await repository.getLeaves(event.datatype);

      emit(state.copyWith(status: LeaveStatus.success, leaves: leaves));
    } catch (e) {
      emit(
        state.copyWith(
          status: LeaveStatus.failure,
          errorMessage: "Failed to refresh leaves",
        ),
      );
    }
  }

  Future<void> _onApproveLeave(
    ApproveLeave event,
    Emitter<LeavesViewState> emit,
  ) async {
    emit(state.copyWith(actionLoadingId: event.leaveId));

    try {
      await repository.updateLeaveStatus(event.leaveId, "APPROVED");

      final leaves = await repository.getLeaves(event.datatype);

      emit(
        state.copyWith(
          status: LeaveStatus.success,
          leaves: leaves,
          actionLoadingId: null,
          successMessage: "Leave approved successfully",
        ),
      );
    } catch (e) {
      emit(state.copyWith(actionLoadingId: null, errorMessage: e.toString()));
    }
  }

  Future<void> _onRejectLeave(
    RejectLeave event,
    Emitter<LeavesViewState> emit,
  ) async {
    emit(state.copyWith(actionLoadingId: event.leaveId));

    try {
      await repository.updateLeaveStatus(event.leaveId, "REJECTED");

      final leaves = await repository.getLeaves(event.datatype);

      emit(
        state.copyWith(
          status: LeaveStatus.success,
          leaves: leaves,
          actionLoadingId: null,
          successMessage: "Leave rejected successfully",
        ),
      );
    } catch (e) {
      emit(state.copyWith(actionLoadingId: null, errorMessage: e.toString()));
    }
  }

  Future<void> _onCancelLeave(
    CancelLeave event,
    Emitter<LeavesViewState> emit,
  ) async {
    emit(state.copyWith(actionLoadingId: event.leaveId));

    try {
      await repository.updateLeaveStatus(event.leaveId,"cancel");

      final leaves = await repository.getLeaves(event.datatype);

      emit(
        state.copyWith(
          status: LeaveStatus.success,
          leaves: leaves,
          actionLoadingId: null,
          successMessage: "Leave cancelled successfully",
        ),
      );
    } catch (e) {
      emit(state.copyWith(actionLoadingId: null, errorMessage: e.toString()));
    }
  }
}

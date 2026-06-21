import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goexperts/employe/emp_dashbord/data/repository_emp_dashboard.dart';

import '../data/emp_dashborad_modal.dart';
import 'emp_dashboard_event.dart';
import 'emp_dashboard_state.dart';

class EmpDashboardBloc extends Bloc<EmpDashboardEvent, EmpDashboardState> {
  final RepositoryEmpDashboard repositoryEmp;

  EmpDashboardBloc(this.repositoryEmp) : super(EmpDashboardInitial()) {
    on<EmpLoadDashboard>(_loadDashboard);
    on<CheckInEvent>(_checkIn);
    on<CheckOutEvent>(_checkOut);
  }

  /// ================= FETCH EMPLOYEE DASHBOARD METRICS =================
  Future<void> _loadDashboard(
    EmpLoadDashboard event,
    Emitter<EmpDashboardState> emit,
  ) async {
    emit(EmpDashboardLoading());
    try {
      final res = await repositoryEmp.getDashboard();
      final data = EmpDashboardModel.fromJson(res);
      emit(EmpDashboardLoaded(data));
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ??
          e.message ??
          "Failed to load dashboard data";
      print(message);
      emit(EmpDashboardError(message));
    }
  }

  /// ================= EXECUTE ATTENDANCE CHECK-IN =================
  Future<void> _checkIn(
    CheckInEvent event,
    Emitter<EmpDashboardState> emit,
  ) async {
    final currentState = state;

    // Safety Check: Only permit actions if the baseline dashboard frame is visible
    if (currentState is EmpDashboardLoaded) {
      emit(currentState.copyWith(loading: true, errorMessage: null));

      try {
        await repositoryEmp.checkIn(
          file: event.image!,
          latitude: event.latitude,
          longitude: event.longitude,
          mode: event.mode!,
        );

        // Re-fetch everything cleanly to update charts sequentially
        final res = await repositoryEmp.getDashboard();
        final data = EmpDashboardModel.fromJson(res);
        emit(EmpDashboardLoaded(data, loading: false));
      } on DioException catch (e) {
        final message =
            e.response?.data?["message"] ?? e.message ?? "Check-in failed";
        // FIX: Re-emits your cached dashboard data along with the error banner text instantly
        emit(currentState.copyWith(loading: false, errorMessage: message));
      }
    } else {
      // Fallback if state isn't loaded yet
      emit(
        EmpDashboardError(
          "Cannot perform check-in; employee dashboard uninitialized.",
        ),
      );
    }
  }

  /// ================= EXECUTE ATTENDANCE CHECK-OUT =================
  Future<void> _checkOut(
    CheckOutEvent event,
    Emitter<EmpDashboardState> emit,
  ) async {
    final currentState = state;

    // Safety Check: Only permit actions if the baseline dashboard frame is visible
    if (currentState is EmpDashboardLoaded) {
      emit(currentState.copyWith(loading: true, errorMessage: null));

      try {
        await repositoryEmp.checkOut(
          file: event.image!,
          latitude: event.latitude,
          longitude: event.longitude,
        );

        // Re-fetch everything cleanly to synchronize shift endpoints
        final res = await repositoryEmp.getDashboard();
        final data = EmpDashboardModel.fromJson(res);
        emit(EmpDashboardLoaded(data, loading: false));
      } on DioException catch (e) {
        final message =
            e.response?.data?["message"] ?? e.message ?? "Check-out failed";
        // FIX: Error details append directly onto local context memory variables securely
        emit(currentState.copyWith(loading: false, errorMessage: message));
      }
    } else {
      // Fallback if state isn't loaded yet
      emit(
        EmpDashboardError(
          "Cannot perform check-out; employee dashboard uninitialized.",
        ),
      );
    }
  }
}

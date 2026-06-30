import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goexperts/core/widgets/top_message.dart';
import 'package:goexperts/users/employe/emp_dashbord/data/repository_emp_dashboard.dart';

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
        final checkInResponse = await repositoryEmp.checkIn(
          file: event.image!,
          latitude: event.latitude,
          longitude: event.longitude,
          mode: event.mode!,
        );
        if (checkInResponse["success"] == true) {
          emit(ShowMessageState("Check-in submitted successfully"));
          final res = await repositoryEmp.getDashboard();
          final data = EmpDashboardModel.fromJson(res);
          emit(EmpDashboardLoaded(data, loading: false));
        } else {
          final String errMsg = checkInResponse["message"] ?? "Check-in failed";
          emit(currentState.copyWith(loading: false, errorMessage: errMsg));
        }

        // Re-fetch everything cleanly to update charts sequentially
      } on DioException catch (e) {
        print("this is the catch?????????????");

        String message = "Check-in failed";

        // SAFETY CHECK: Ensure data is an actual JSON Map before pulling the message key
        if (e.response?.data != null && e.response?.data is Map) {
          message = e.response?.data?["message"] ?? "Check-in failed";
        } else if (e.response?.data != null && e.response?.data is String) {
          // If backend returns a raw error string instead of a structured JSON object
          message = e.response?.data;
        } else {
          // Fallback to general network message or status code
          message =
              e.message ?? "Server error status: ${e.response?.statusCode}";
        }

        // Re-emits your cached dashboard data safely along with the handled error banner text
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
         print("this is from submitWork >>>>>>>>>>>>>>>${event.isDailyWork}>>>>");

        if (event.isDailyWork != true) {
          print("this is from submitWork >>>>>>>>>>>>>>>>>>>");
          // 1. Submit work details first
          final submitWorkResponse = await repositoryEmp.submitWork(
            workType: event.titile!,
            description: event.description!,
          );

          // Check for work submission failure
          if (submitWorkResponse["success"] != true) {
            final String errMsg =
                submitWorkResponse["message"] ?? "Work submission failed";
            emit(currentState.copyWith(loading: false, errorMessage: errMsg));
            return; // Stop execution; do not proceed to checkout
          }
        }
        print("this is from checkOut >>>>>>>>>>>>>>>>>>>");

        // 2. If work submission succeeded, proceed to checkout
        final checkoutResponse = await repositoryEmp.checkOut(
          file: event.image!,
          latitude: event.latitude,
          longitude: event.longitude,
          checkoutReason: event.reason,
        );

        // Check for checkout success
        if (checkoutResponse["success"] == true) {
          emit(ShowMessageState("Check-out and work submitted successfully"));

          // Re-fetch everything cleanly to synchronize shift endpoints
          final res = await repositoryEmp.getDashboard();
          final data = EmpDashboardModel.fromJson(res);

          emit(EmpDashboardLoaded(data, loading: false));
          emit(currentState.copyWith(loading: false));
        } else {
          print("this is the catch: ${checkoutResponse["message"]}");
          // Handle checkout failure
          final String errMsg =
              checkoutResponse["message"] ?? "Check-out failed";
          emit(currentState.copyWith(loading: false, errorMessage: errMsg));
        }
      } on DioException catch (e) {
        print("this is the catch: $e");
        final message =
            e.response?.data?["message"] ?? e.message ?? "Process failed";
        emit(currentState.copyWith(loading: false, errorMessage: message));
        print("this is the catch: $message");
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

  /// ================= EXECUTE WORK SUBMISSION =================
}

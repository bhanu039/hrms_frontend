import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/sessionservice.dart';
import '../data/hr_dashbord_modal.dart';
import '../data/hr_dashbord_repo.dart';
import 'hr_dashbord_state.dart';
import 'hr_dashbords_event.dart';

class HrDashboardBloc extends Bloc<HrDashboardEvent, HrDashboardState> {
  final HrDashboardRepository repository;

  HrDashboardBloc(this.repository) : super(HrDashboardInitial()) {
    on<LoadHrDashboard>(_onLoadDashboard);
    on<CheckInRequested>(_onCheckIn);
    on<CheckOutRequested>(_onCheckOut);
  }

  /// ================= FETCH DASHBOARD METRICS =================
  Future<void> _onLoadDashboard(
    LoadHrDashboard event,
    Emitter<HrDashboardState> emit,
  ) async {
    print("this is the _onLoadDashboard; ");
    emit(HrDashboardLoading());

    try {
      final data = await repository.getDashboard();
      print("this is the data from the bloc ${data.data}");
      print("this is the api success; ");
      
      final mapdata = HrDashboardModel.fromJson(
        Map<String, dynamic>.from(data.data as Map),
      );

      emit(HrDashboardLoaded(mapdata));
    } on DioException catch (e) {
      print("this is the error from the bloc ${e.toString()}");
      final message = e.response?.data?['message'] ?? e.message ?? "Failed to load dashboard data";
      print("this is message $message");
      emit(HrDashboardError(message));
    }
  }

  /// ================= EXECUTE ATTENDANCE CHECK-IN =================
  Future<void> _onCheckIn(
    CheckInRequested event,
    Emitter<HrDashboardState> emit,
  ) async {
    final currentState = state;
    
    // Safety Check: Only permit actions if the baseline dashboard frame is visible
    if (currentState is HrDashboardLoaded) {
      emit(currentState.copyWith(loading: true, errorMessage: null));

      try {
        final response = await repository.checkinData(
          event.image,
          event.latitude,
          event.longitude,
        );

        if (response["success"] == true) {
          // Re-fetch everything cleanly to update charts sequentially
          final data = await repository.getDashboard();
          final mapdata = HrDashboardModel.fromJson(
            Map<String, dynamic>.from(data.data as Map),
          );
          emit(HrDashboardLoaded(mapdata, loading: false));
        } else {
          final String errMsg = response["message"] ?? "Check-In Processing Refused";
          emit(currentState.copyWith(loading: false, errorMessage: errMsg));
        }
      } on DioException catch (e) {
        final message = e.response?.data?["message"] ?? e.message ?? "Check-in failed";
        // FIX: Re-emits your cached dashboard data along with the error banner text instantly
        emit(currentState.copyWith(loading: false, errorMessage: message));
      }
    } else {
      // Fallback fallback if state isn't loaded yet
      emit(HrDashboardError("Cannot perform check-in; dashboard metrics uninitialized."));
    }
  }

  /// ================= EXECUTE ATTENDANCE CHECK-OUT =================
  Future<void> _onCheckOut(
    CheckOutRequested event,
    Emitter<HrDashboardState> emit,
  ) async {
    final currentState = state;

    if (currentState is HrDashboardLoaded) {
      emit(currentState.copyWith(loading: true, errorMessage: null));

      try {
        final response = await repository.checkoutData(
          event.image,
          event.latitude,
          event.longitude,
        );

        if (response["success"] == true) {
          await SessionService.cleartime();
          
          // Re-fetch everything cleanly to synchronize shift endpoints
          final data = await repository.getDashboard();
          final mapdata = HrDashboardModel.fromJson(
            Map<String, dynamic>.from(data.data as Map),
          );
          emit(HrDashboardLoaded(mapdata, loading: false));
        } else {
          final String errMsg = response["message"] ?? "Check-Out Processing Refused";
          emit(currentState.copyWith(loading: false, errorMessage: errMsg));
        }
      } on DioException catch (e) {
        final message = e.response?.data?["message"] ?? e.message ?? "Check-out failed";
        // FIX: Error details append directly onto local context memory variables securely
        emit(currentState.copyWith(loading: false, errorMessage: message));
      }
    } else {
      emit(HrDashboardError("Cannot perform check-out; dashboard metrics uninitialized."));
    }
  }
}

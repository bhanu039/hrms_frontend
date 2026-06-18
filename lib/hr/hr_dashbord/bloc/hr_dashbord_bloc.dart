import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/sessionservice.dart';
import '../data/hr_dashbord_repo.dart';
import 'hr_dashbord_state.dart';
import 'hr_dashbords_event.dart';

class HrDashboardBloc extends Bloc<HrDashboardEvent, HrDashboardState> {
  final HrDashboardRepository repository;

  Timer? _timer;

  HrDashboardBloc(this.repository) : super(HrDashboardInitial()) {
    on<LoadHrDashboard>(_onLoadDashboard);
    on<CheckInRequested>(_onCheckIn);
    on<CheckOutRequested>(_onCheckOut);
    on<AttendanceTimerTicked>(_onTimerTicked);
  }

  Future<void> _onLoadDashboard(
    LoadHrDashboard event,
    Emitter<HrDashboardState> emit,
  ) async {
    emit(HrDashboardLoading());

    try {
      final data = await repository.getDashboard();
      print("this is the data from the bloc ${data.data}");

      emit(HrDashboardLoaded(data.data));
    } on DioException catch (e) {
      print("this is the error from the bloc ${e.toString()}");
      final message = e.response?.data?['message'] ?? e.message;
      print("thid is messege $message");
      emit(HrDashboardError(message));
    }
  }

  Future<void> _onCheckIn(
    CheckInRequested event,
    Emitter<HrDashboardState> emit,
  ) async {
    emit(const HrDashboardAttendanceState(status: AttendanceStatus.loading));

    try {
      final response = await repository.checkinData(
        event.image,
        event.latitude,
        event.longitude,
      );

      if (response["success"] == true) {
        final checkInTime = DateTime.now();

        _timer?.cancel();

        _timer = Timer.periodic(
          const Duration(seconds: 1),
          (_) => add(AttendanceTimerTicked()),
        );

        emit(
          HrDashboardAttendanceState(
            status: AttendanceStatus.checkedIn,
            isCheckedIn: true,
            checkInTime: checkInTime,
            workingDuration: Duration.zero,
            message: "Check-In Success",
          ),
        );

        await SessionService.save(Duration.zero);
      } else {
        emit(
          HrDashboardAttendanceState(
            status: AttendanceStatus.failure,
            message: response["message"],
          ),
        );
      }
    } catch (e) {
      emit(
        HrDashboardAttendanceState(
          status: AttendanceStatus.failure,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCheckOut(
    CheckOutRequested event,
    Emitter<HrDashboardState> emit,
  ) async {
    emit(const HrDashboardAttendanceState(status: AttendanceStatus.loading));

    try {
      final response = await repository.checkoutData(
        event.image,
        event.latitude,
        event.longitude,
      );

      if (response["success"] == true) {
        _timer?.cancel();

        await SessionService.cleartime();

        emit(
          const HrDashboardAttendanceState(
            status: AttendanceStatus.checkedOut,
            isCheckedIn: false,
            workingDuration: Duration.zero,
            message: "Check-Out Success",
          ),
        );
      } else {
        emit(
          HrDashboardAttendanceState(
            status: AttendanceStatus.failure,
            message: response["message"],
          ),
        );
      }
    } catch (e) {
      emit(
        HrDashboardAttendanceState(
          status: AttendanceStatus.failure,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _onTimerTicked(
    AttendanceTimerTicked event,
    Emitter<HrDashboardState> emit,
  ) async {
    if (state is! HrDashboardAttendanceState) return;

    final current = state as HrDashboardAttendanceState;

    if (current.checkInTime == null) return;

    final duration = DateTime.now().difference(current.checkInTime!);

    await SessionService.save(duration);

    emit(current.copyWith(workingDuration: duration));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

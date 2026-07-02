import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repository_Attendence.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendenceRepository repository;

  AttendanceBloc({AttendenceRepository? repository})
      : repository = repository ?? AttendenceRepository(),
        super(const AttendanceState()) {
    on<AttendanceStarted>(_onStarted);

    on<AttendanceSearchChanged>((event, emit) {
      emit(state.copyWith(search: event.query));
    });

    on<AttendanceStatusChanged>((event, emit) {
      emit(state.copyWith(status: event.status));
    });

    on<FromDateChanged>((event, emit) {
      emit(state.copyWith(fromDate: event.fromDate));
    });

    on<ToDateChanged>((event, emit) {
      emit(state.copyWith(toDate: event.toDate));
    });

    on<ApplyFilters>(_applyFilters);

    on<LoadMoreEmployees>(_loadMore);

    on<ResetFilters>(_resetFilters);

    on<FullAttendanceid>(_fullAttendance);
  }

  Future<void> _onStarted(
    AttendanceStarted event,
    Emitter<AttendanceState> emit,
  ) async {
    add(ApplyFilters());
  }

  Future<void> _applyFilters(
    ApplyFilters event,
    Emitter<AttendanceState> emit,
  ) async {
    try {
      emit(state.copyWith(
        isLoading: true,
        currentPage: 1,
      ));

      final response = await repository.getEmployeesAttendence(
        currentPage: 1,
        search: state.search,
        status: state.status,
        fromDate: state.fromDate,
        toDate: state.toDate,
      );

      emit(
        state.copyWith(
          isLoading: false,
          attendanceResponse: response,
          currentPage: 1,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
        ),
      );
    }
  }

  Future<void> _fullAttendance(
    FullAttendanceid event,
    Emitter<AttendanceState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));

      final response = await repository.getEmpFullAttendence(
        eid: event.employeeId,
      );

      emit(
        state.copyWith(
          isLoading: false,
          fullAttendence: response,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
        ),
      );
    }
  }

  Future<void> _loadMore(
    LoadMoreEmployees event,
    Emitter<AttendanceState> emit,
  ) async {
    try {
      

      final response = await repository.getEmployeesAttendence(
        currentPage:  event.currentPage,
        search: state.search,
        status: state.status,
        fromDate: state.fromDate,
        toDate: state.toDate,
      );

      emit(
        state.copyWith(
          attendanceResponse: response,
          currentPage:  event.currentPage,
        ),
      );
    } catch (_) {}
  }

  Future<void> _resetFilters(
    ResetFilters event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(const AttendanceState());

    add(ApplyFilters());
  }
}

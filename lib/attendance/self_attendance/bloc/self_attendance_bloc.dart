import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/attendance_model.dart';
import '../data/self_attendance_repository.dart';
import 'self_attendance_event.dart';
import 'self_attendance_state.dart';

class SelfAttendanceBloc extends Bloc<SelfAttendanceEvent, SelfAttendanceState> {
  final SelfAttendanceRepository repository;

  SelfAttendanceBloc({SelfAttendanceRepository? repository})
    : repository = repository ?? SelfAttendanceRepository(),
      super(const SelfAttendanceState()) {
    on<AttendanceStarted>(_onStarted);
    on<AttendanceDateChanged>((event, emit) {
      emit(state.copyWith(date: event.date));
    });
    on<AttendanceFromDateChanged>((event, emit) {
      emit(state.copyWith(fromDate: event.fromDate, month: '', year: ''));
    });
    on<AttendanceToDateChanged>((event, emit) {
      emit(state.copyWith(toDate: event.toDate, month: '', year: ''));
    });
    on<AttendanceMonthChanged>((event, emit) {
      emit(state.copyWith(month: event.month, fromDate: '', toDate: ''));
    });
    on<AttendanceYearChanged>((event, emit) {
      emit(state.copyWith(year: event.year, fromDate: '', toDate: ''));
    });
    on<AttendanceStatusChanged>((event, emit) {
      emit(state.copyWith(status: event.status));
    });
    on<AttendanceSortChanged>((event, emit) {
      emit(state.copyWith(sort: event.sort));
    });
    on<ApplyFilters>(_applyFilters);
    on<ResetFilters>(_resetFilters);
  }

  Future<void> _onStarted(
    AttendanceStarted event,
    Emitter<SelfAttendanceState> emit,
  ) async {
    final now = DateTime.now();
    emit(
      state.copyWith(
        month: now.month.toString(),
        year: now.year.toString(),
        date: '',
        fromDate: '',
        toDate: '',
        status: '',
        sort: 'desc',
        errorMessage: '',
      ),
    );

    add(ApplyFilters());
  }

  Future<void> _applyFilters(
    ApplyFilters event,
    Emitter<SelfAttendanceState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: ''));

      final response = await repository.getMyAttendance(
        date: state.date,
        fromDate: state.fromDate,
        toDate: state.toDate,
        month: state.month,
        year: state.year,
        status: state.status,
        sort: state.sort,
      );

      emit(state.copyWith(isLoading: false, attendanceResponse: response));
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
    }
  }

  Future<void> _resetFilters(
    ResetFilters event,
    Emitter<SelfAttendanceState> emit,
  ) async {
    final now = DateTime.now();
    emit(
      state.copyWith(
        date: '',
        fromDate: '',
        toDate: '',
        month: now.month.toString(),
        year: now.year.toString(),
        status: '',
        sort: 'desc',
        errorMessage: '',
      ),
    );

    add(ApplyFilters());
  }
}

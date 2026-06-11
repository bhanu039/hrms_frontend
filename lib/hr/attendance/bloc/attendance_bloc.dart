import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repository_Attendence.dart';
import 'attendance_event.dart';

import 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final repository = AttendenceRepository();
  AttendanceBloc() : super(const AttendanceState()) {
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

    on<ResetFilters>((event, emit) {
      emit(const AttendanceState());
      add(ApplyFilters());
    });
    on<FullAttendanceid>(_fullAttendance);

  }


  Future<void> _applyFilters(
    ApplyFilters event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, currentPage: 1));

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
  }
  Future<void> _fullAttendance(
    FullAttendanceid event,
    Emitter<AttendanceState> emit,
  ) async {
   

    final response = await repository.getEmpFullAttendence(
      eid: state.eId!
    );

    emit(
      state.copyWith(
        isLoading: false,
        fullAttendence: response,
       
      ),
    );
  }

  Future<void> _loadMore(
    LoadMoreEmployees event,
    Emitter<AttendanceState> emit,
  ) async {
    final nextPage = state.currentPage;

    final response = await repository.getEmployeesAttendence(
      currentPage: nextPage,
      search: state.search,
      status: state.status,
      fromDate: state.fromDate,
      toDate: state.toDate,
    );

    emit(state.copyWith(attendanceResponse: response, currentPage: nextPage));
  }

}
